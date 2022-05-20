# shell脚本学习总结

### shell 环境

#！是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使哪一种shell

linux的shell种类众多，常见的有 ：

* Bourne Shell（/usr/bin/sh 或/bin/sh）
* Bourne Again Shell (/bin/bash)
* C Shell (/usr/bin/csh)
* K Shell (/usr/bin/ksh)
* Shell for Root (/sbin/sh)

### 变量

注意：

* 变量名和=之间不能有空格
* 命名时，首个字符不能以数字开头
* 中间不能有空格，可以使用下划线_  
* 不能使用标点符号
* 不能使用bash里的关键字（可以用help查看保留关键字）

实例：

* 1. 有效变量名: RUNOOB LD_LIHD_PATH _var var2;
* 2. 无效变量名：？hd 2test user*name ...

只读变量：readonly variable_name

删除变量：unset variable_name

### 字符串
单引号：

* 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
* 单引号字串中不能出现单独一个单引号（对单引号使用转义符后也不行），但是可以成对出现，作为字符串拼接使用；

双引号：
* 双引号里可以有变量；
* 双引号里可以出现转义字符；

实例：
```
[anaconda@hicdlxap08 ~]$ your_name="runoob"
#使用双引号拼接字符串
[anaconda@hicdlxap08 ~]$ str="hello, I know you are \"$your_name\"! \n"
[anaconda@hicdlxap08 ~]$ echo -e $str
hello, I know you are "runoob"!
#双引号中可以有变量
[anaconda@hicdlxap08 ~]$ str3="hello, I know you are ${your_name}"
[anaconda@hicdlxap08 ~]$ echo -e $str3
hello, I know you are runoob


#使用单引号拼接
[anaconda@hicdlxap08 ~]$ str1='hello, i know you are '$your_name''
[anaconda@hicdlxap08 ~]$ echo -e $str1
hello, i know you are runoob
#单引号的变量是无效的，会原样输出；
[anaconda@hicdlxap08 ~]$ str2='hello, i know you are $your_name!'
[anaconda@hicdlxap08 ~]$ echo -e $str2
hello, i know you are $your_name!
```
获取字符串长度

变量为字符串时，${#string} 等价于 ${#string[0]}

实例：
```
#获取字符串长度
[anaconda@hicdlxap08 JPN]$ string="abcd"
[anaconda@hicdlxap08 JPN]$ echo ${#string}
4
[anaconda@hicdlxap08 JPN]$ echo ${#string[0]}
4

```

提取子字符串从2个提取到第4个

实例：
```
[anaconda@hicdlxap08 JPN]$ string="this is a test"
[anaconda@hicdlxap08 JPN]$ echo ${string:1:4}
his
```

查找子字符串

实例：
```
[anaconda@hicdlxap08 JPN]$ string="this is a test"
[anaconda@hicdlxap08 JPN]$ echo `expr index "${string}" a`
9
```

### 传递参数

|
|----------------|----------------|
| $#| 传递参数的总个数 |
| $*| 以"$1 $2 $3 $4...$N形式传递所有参数|
| $$| 脚本运行的当前进程ID号|
| $!| 后台运行的最后一个进程的ID号|
| $@| 与 $* 相同，表示所有参数 |
| $-| 显示Shell使用的当前选项，与set命令功能相同|
| $?| 显示最后命令的退出状态。0表示没有错误，其他任何值表示有错误 |

### 数组
array_name=(value1 value2 ... valuen)

|
|----------------|----------------|
|读取数组|$ {array[index]} |
|获取数组所有元素| ${array[@]} , ${array[*]}|
|获取数组长度 |${#array[@]} , ${#array[*]}|

### 运算符 expr
```
#使用反引号
[anaconda@hicdlxap08 JPN]$ val=`expr 2 + 2`
[anaconda@hicdlxap08 JPN]$ echo $val
4

#使用 $()
[anaconda@hicdlxap08 JPN]$ val=$(expr 2 + 2)
[anaconda@hicdlxap08 JPN]$ echo $val
4
```
注意：

表达式和运算符之间要有空格，必须写成 2 + 2

条件表达式要放在方括号之间，并且要有空格，例如:[$a==$b]是错误的，必须写成[ $a == $b]

乘号（*）前边必须加反斜杠（\）才能实现乘法运算

实例：
```
a=10
b=20
[anaconda@hicdlxap08 JPN]$ val=`expr $a \* $b`;echo $val # *前需要加\
200
[anaconda@hicdlxap08 JPN]$ val=`expr $a % $b`;echo $val
10
[anaconda@hicdlxap08 JPN]$ val=`expr $b % $a`;echo $val
0
[anaconda@hicdlxap08 JPN]$ val=`expr $b / $a`;echo $val
2

[anaconda@hicdlxap08 JPN]$ [ $a == $b ];echo $? #返回false
1
[anaconda@hicdlxap08 JPN]$ [ $a != $b ];echo $? #返回true
0

```
### 关系运算符
a=10 ;b=20

|运算符|说明|例子
|----------------|----------------|
|-eq|等于|[ $a -eq $b ] 返回false|
|-ne|不相等| [ $a -ne $b ] 返回true |
|gt|大于| [ $a -gt $b ] 返回false|
|ge|大于等于| [ $a -ge $b ] 返回false|
|lt|小于| [ $a -lt $b ] 返回true|
|le|小于等于| [ $a -le $b ] 返回true|

|布尔运算符
|----------------|----------------|
|-！|非运算|
|-a|与运算|
|-o|或运算|

### printf

%s %c %d %f 都是格式替代符，％s 输出一个字符串，％d 整型输出，％c 输出一个字符，％f 输出实数，以小数形式输出。

%-10s 指一个宽度为 10 个字符（- 表示左对齐，没有则表示右对齐），任何字符都会被显示在 10 个字符宽的字符内，如果不足则自动以空格填充，超过也会将内容全部显示出来。

%-4.2f 指格式化为小数，其中 .2 指保留2位小数。

实例：
```
[anaconda@hicdlxap08 JPN]$ printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg
姓名     性别   体重kg
[anaconda@hicdlxap08 JPN]$ printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234
郭靖     男      66.12
[anaconda@hicdlxap08 JPN]$ printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543
杨过     男      48.65
[anaconda@hicdlxap08 JPN]$ printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876
郭芙     女      47.99

```

### test

实例：
```
num1=100
num2=100
if test $[num1] -eq $[num2]
then
    echo '两个数相等！'
else
    echo '两个数不相等！'
fi
```
字符串测试

|
|----------------|----------------|
|=|等于则为真（注意数字运算时是“==”表示等于）|
|！=|不等于则为真|
|-z 字符串|字符串长度为0则为真|
|-n 字符串|字符串长度不为0则为真|

文件测试

|
|----------------|----------------|
|-e 文件名|如果文件存在则为真|
|-r 文件名|文件存在且可读则为真|
|-w 文件名|文件存在且可写则为真|
|-X 文件名|文件存在且可执行则为真|
|-s 文件名|文件存在且有一个字符则为真|
|-d 文件名|文件存在且为目录则为真|
|-f 文件名|文件存在且为普通文件则为真|

### 函数
实例：
注意：
函数返回值在调用该函数后通过\$? 来获得, \$?仅对其上一条指令负责，一旦函数返回后其返回值没有立即保存入参数，那么其返回值将不再能通过 $? 获得
```
#!/bin/bash

function demoFun1(){
    echo "这是我的第一个 shell 函数!"
    return `expr 1 + 1`
}

demoFun1
echo $?
echo $?

输出结果：
这是我的第一个 shell 函数!
2
0
```

### 输入输出重定向
|
|----------------|----------------|
|command > file| 将输出重定向到file|
|command < file| 将输入重定向到file:本来需要从键盘获取输入的命令会转移到文件读取内容。|
|command >> file|将输出以追加的方式重定向到 file。|
|n > file|	将文件描述符为 n 的文件重定向到 file。|
|n >> file|	将文件描述符为 n 的文件以追加的方式重定向到 file|
|n >& m|将输出文件 m 和 n 合并。|
|n >& m|将输入文件 m 和 n 合并。|
|<< tag|将开始标记 tag 和结束标记 tag 之间的内容作为输入|

* 标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
* 标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
* 标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息

如何理解输入重定向：本来需要从键盘获取输入的命令会转移到文件读取内容

实例：
```
cat <flie1>file2 #读取file1并将cat输出添加到file2

[anaconda@hicdlxap08 ~]$ echo "1111" > 1.txt
[anaconda@hicdlxap08 ~]$ cat 1.txt
1111
[anaconda@hicdlxap08 ~]$ cat < 1.txt >3.txt
[anaconda@hicdlxap08 ~]$ cat 3.txt
1111

cat >1.txt << EOF # 读取EOF开头到以EOF结果的内容，然后将输出重定向到1.txt
test1
test2
test3
EOF

如果希望 stderr 重定向到 file，可以这样写：
$ command 2>file

如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：
$ command > file 2>&1

/dev/null 文件
如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到 /dev/null：

$ command > /dev/null

如果希望屏蔽 stdout 和 stderr，可以这样写：

$ command > /dev/null 2>&1

注意：0 是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。
这里的 2 和 > 之间不可以有空格，2> 是一体的时候才表示错误输出
```

### 文件包含
. filename   # 注意点号(.)和文件名中间有一空格 或 source filename
实例：
```
test1.sh 代码如下：

#!/bin/bash
url="http://www.runoob.com"

test2.sh 代码如下：

#!/bin/bash
#使用 . 号来引用test1.sh 文件
. ./test1.sh

# 或者使用以下包含文件代码
# source ./test1.sh
echo "菜鸟教程官网地址：$url"

接下来，我们为 test2.sh 添加可执行权限并执行：
$ chmod +x test2.sh 
$ ./test2.sh 
菜鸟教程官网地址：http://www.runoob.com
```
注：被包含的文件 test1.sh 不需要可执行权限。





  
