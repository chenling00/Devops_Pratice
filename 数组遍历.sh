#!/bin/bash
array=(A B "C" D)
index=1
for i in ${array[@]} #使用@ 或 * 可以获取数组中的所有元素
do
        echo "第$index元素为:$i"
        index=$(($index+1))

done


for i in $(seq 0 ${#array[*]}) #使用${array[@]}或者${#array[*]}获取素组长度
do
        val=${array[$i]}
        echo "第 $i 个 元素为:$val"
done

###
#for i in $(seq 0 ${#array[@]}) 这条语句中的 seq 获取的范围是大于等于 0 小于等于数组size的范围，这样你在遍历中就会遍历到数组最后一个元素的下一个元素。然而shell并不会报错，而是以空字符来处理#最后越界的那个元素。
###

num=${#array[@]}
num=$(expr $num - 1) #注意运算符 + - * / 前后必须要空格隔开
echo $num
for i in $(seq 0 $num)
do
        val=${array[$i]}
        echo "第 $i 个元素为:$val"
done
