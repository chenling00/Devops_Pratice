公钥创建

cd ~/.ssh

ssh-keygen -t rsa -C "youremail@example.com"

## 2.2 Git配置

> Git 提供了一个叫做 git config 的工具，专门用来配置或读取相应的工作环境变量。
> 配置用户信息
>
> 1. `/etc/gitconfig` 文件: 包含系统上每一个用户及他们仓库的通用配置。 如果在执行 `git config` 时带上 `--system` 选项，那么它就会读写该文件中的配置变量。 （由于它是系统配置文件，因此你需要管理员或超级用户权限来修改它。）
> 2. `~/.gitconfig` 或 `~/.config/git/config` 文件：只针对当前用户。 你可以传递 `--global` 选项让 Git 读写此文件，这会对你系统上 **所有** 的仓库生效。
> 3. 当前使用仓库的 Git 目录中的 `config` 文件（即 `.git/config`）：针对该仓库。 你可以传递 `--local` 选项让 Git 强制读写此文件，虽然默认情况下用的就是它。。 （当然，你需要进入某个 Git 仓库中才能让该选项生效。）

```
#配置全局的用户和用户名，所有项目默认情况下使用全部配置
git config --global user.name "kaliarch"
git config --global user.email kaliarch@anchnet.com

#当你想单独配置某个项目的用户和用户名
cd 项目文件夹 git config 读写的是 当前使用仓库的 Git 目录中的 `config` 文件（即 `.git/config`）
git config user.name "xxxx"
git config user.email "xxxx"

* 当同时配置了 git config --global user.name 和 git config user.name和 --默认情况下 优先使用的是
git config user.name。

git config --list     #查看配置
你可能会看到重复的变量名，因为 Git 会从不同的文件中读取同一个配置（例如：/etc/gitconfig 与 ~/.gitconfig）。 这种情况下，Git 会使用它找到的每一个变量的最后一个配置。

你可以通过输入 git config <key>： 来检查 Git 的某一项配置
$ git config user.name

**再次强调，如果使用了 --global 选项，那么该命令只需要运行一次，因为之后无论你在该系统上做任何事情， Git 都会使用那些信息。 当你想针对特定项目使用不同的用户名称与邮件地址时，可以在那个项目目录下运行没有 --global 选项的命令来配置。

note:
	
由于 Git 会从多个文件中读取同一配置变量的不同值，因此你可能会在其中看到意料之外的值而不知道为什么。 此时，你可以查询 Git 中该变量的 原始 值，它会告诉你哪一个配置文件最后设置了该值：

$ git config --show-origin rerere.autoUpdate
file:/home/johndoe/.gitconfig	false
```

## 2.3 创建仓库

> Git 使用 git init 命令来初始化一个 Git 仓库，Git 的很多命令都需要在 Git 的仓库中运行，所以`git init`是使用 Git 的第一个命令。
> 在执行完成 git init 命令后，Git 仓库会生成一个 .git 目录，该目录包含了资源的所有元数据，其他的项目目录保持不变（不像 SVN 会在每个子目录生成 .svn 目录，Git 只在仓库的根目录生成 .git 目录）。
> 该命令执行完后会在当前目录生成一个 .git 目录。
> 使用我们指定目录作为Git仓库。
> 初始化后，会在 newrepo 目录下会出现一个名为 .git 的目录，所有 Git 需要的数据和资源都存放在这个目录中。
> 如果当前目录下有几个文件想要纳入版本控制，需要先用 git add 命令告诉 Git 开始对这些文件进行跟踪，然后提交：

```
git add *.c
git add README
git commit -m '初始化项目版本'
git clone
```

# 三、基础操作

> 3.1 创建目录初始化

```
mkdir /workspace
cd /workspace
git init
```

> 此时Git仓库就创建完成了，此时为一个空仓库（empty Git repository），可以发现当前目录下有一个隐藏的目录`.git`，此目录为Git来跟踪管理版本库，建议不要修改内部文件，以免Git仓库遭到破坏。
> 使用`git clone`拷贝一个Git仓库到本地，可以进行项目查看与修改

```
git add files 接下来我们执行 git add 命令来添加文件：
git commit -m "xxxx"
git log
git status -s     git status 以查看在你上次提交之后是否有修改

```

![GIT笔记](http://i2.51cto.com/images/blog/201712/12/8c6afdb88ee1e49e35cc2daad3e3c139.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)

> 3.2 版本回退

连续添加多个文件后，执行`commit`提交后，使用`git log`查看不同版本
可以使用`--oneline`选项查看历史记录简洁版本，也可用`--graph`选项，查看历史中什么时候出现了分支、合并，
也可用`--reverse`参数逆向显示所有日志。
![GIT笔记](http://i2.51cto.com/images/blog/201712/12/d04123a33ac281b59e95c84870258426.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)
添加文件第一步使用`git add`是将文件添加进暂存区，第二部`git commit`提交更改，实际上为讲暂存区的所有内容提交到当前分支。
git reset HEAD 命令用于取消缓存的内容。
HEAD指向的版本，因此，Git允许回退版本，使用命令`git reset --hard commit_id`
回退前，可使用`git log`查看历史提交记录，以便确回退到那个版本
重新返回回退前的，使用git reflog查看历史命令，回到到未来的某个版本。
Git 跟踪并管理的是修改，而非文件，当使用git add命令后，在工作区的第一次修改给放如暂存区，但是 ，在工作区的第二次修改没放入暂存区，用git commit只负责把暂存区的修改提交，也就是第一次的修改被提交了，第二次的修改未被提交。

> 3.3 删除文件

直接在工作区删除，对暂存区和版本库没有任何影响。本地删除如果要反映在暂存区中应该用git rm命令，对不想删除的文件执行git checkout -- <file>，可以让文件在工作区重现。用git rm命令执行删除后，删除动作加入了暂存区，这时执行提交动作就从真正意义上执行了文件删除，不过文件只是在版本库的最新提交中被删除了，在历史提交中尚在。

> 3.4 移动文件（改名操作）

改名操作相当于对旧文件执行删除，对新文件执行添加

```
git mv可以由git rm和git add两条命令取代
$ git mv oldname newname 完成改名操作
```

> 3.5 恢复删除文件

`git checkout -- readme.txt`
命令git checkout -- readme.txt意思就是，把readme.txt文件在工作区的修改全部撤销，这里有两种情况：
一种是readme.txt自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态；
一种是readme.txt已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。
总之，就是让这个文件回到最近一次git commit或git add时的状态。
用命令git reset HEAD file可以把暂存区的修改撤销掉（unstage），重新放回工作区：

> 一般情况下，你通常直接在文件管理器中把没用的文件删了，或者用rm命令删了：
> 1.一是确实要从版本库中删除该文件，那就用命令git rm删掉，并且git commit
> 2.一种情况是删错了，因为版本库里还有呢，所以可以很轻松地把误删的文件恢复到最新版本：
> git checkout -- test.txt

# 四、分支管理

几乎所有的版本控制系统都存在某种意义上的分支支持，使用分支意味这可以从开放主线来分离出来，可以在不影响主线的情况下继续工作

> 创建分支：

`git branch (branchname)`
`git checkout -b (branchname)` #创建并切换到该分支下

> 查看分支

```
git branch
```

> 切换分支

```
git checkout (branchname)
```

当切换分支时，Git会用该分支的最后提交快照替换工作目录的内容，所以分支不需要多个目录

> 合并分支

```
git merge
```

当执行`git init`时，缺省情况下Git会创建master分支
![GIT笔记](http://i2.51cto.com/images/blog/201712/12/bdbddb6769b42074d76d93eca20235b6.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)

> 删除分支

`git branch -d (branchname) -D` #强制删除