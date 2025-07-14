## docker 镜像原理

![](.\pictures\docker生命周期.png)



docker 镜像原理

我们获取redis镜像的时候，发现是下载了多行信息，最终又得到了一个完整的镜像文件

```shell
[root@node1 ~]# docker pull redis
Using default tag: latest 
latest: Pulling from library/redis
a2abf6c4d29d: Already exists
c7a4e4382001: Pull complete
4044b9ba67c9: Pull complete
c8388a79482f: Pull complete
413c8bb60be2: Pull complete
1abfd3011519: Pull complete
Digest: sha256:db485f2e245b5b3329fdc7eff4eb00f913e09d8feb9ca720788059fdc2ed8339
Status: Downloaded newer image for redis:latest
```

来看一看docker的镜像原理

linux完整的操作系统，例如centos 包括2部分

第1部分linux内核：提供操作系统的基本功能和特性，如内存管理，进程调度，文件管理等等，uname -a 或者 cat /proc/version

第2部分发行版本：在内核的基础上，开发不同应用程序，组成一个完整的操作系统。查看发行版本 cat/etc/*-release;

docker能够灵活的切换发行版本，让我们使用不同的系统.

docker快速切换不同的发行版本，内核使用的都是宿主机的内核



![](.\pictures\Screenshot_1.png)

#### 理解docker镜像原理

## Docker镜像原理

### Docker镜像 分层原理

![在这里插入图片描述](https://img-bc.icode.best/20210708163824246.png)

```powershell
# 进入正在运行的容器内
[root@docker01 ~]# docker exec -it 455ebd1b9508 bash
root@455ebd1b9508:/# 

# 查看nginx运行使用的基础镜像
root@455ebd1b9508:/# cat /etc/os-release 
PRETTY_NAME="Debian GNU/Linux 10 (buster)"
NAME="Debian GNU/Linux"
VERSION_ID="10"
VERSION="10 (buster)"
VERSION_CODENAME=buster
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/
```

### Docker镜像 分层的好处

> 镜像分层的一大好处就是共享资源，例如有多个镜像都来自于同一个base(基础)镜像，那么docker host只需要存储一份base镜像。
>
> - 内存里也只需要加载一份host，即可为多个容器服务。
> - 即使多个容器共享一个base镜像，某个容器修改了base镜像的内容，例如修改/etc/下的配置文件，其他容器的/etc/下内容是不会被修改的，修改动作只限制在单个容器内，这就是容器写时复制特性(Copy On Write)，如下所示。

![在这里插入图片描述](https://img-bc.icode.best/20210708191031330.png)

![在这里插入图片描述](https://img-bc.icode.best/20210708184825341.png)

![在这里插入图片描述](https://img-bc.icode.best/20210708184633446.png)



## docker 实操

```perl
#下载安装docker
宿主机：linux（centos7）docker必须安装在centos7平台，且内核版本不低于3.10（内核查看：uname -r） 

#获取docker yum源（默认yum源在国外，下载速度慢）
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

#清理yum缓存和重建yum缓存，使最新的yum配置生效
yum clean all && yum makecache  

#查看当前镜像源中支持的docker版本
yum list docker-ce --showduplicates | sort -r 

#安装特定版本的docker-ce
必须指定 --setopt=obsoletes=0,否则yum会自动安装更高版本
yum install --setopt=obsoletes=0 docker-ce-18.06.3.ce-3.el7 -y 

#配置docker镜像加速器，用于更快的下载镜像文件
mkdir /etc/docker
cat <<EOF > /etc/docker/daemon.json

{

"registry-mirrors": ["https://kn0t2bca.mirror.aliyuncs.com"]

}

EOF 

#启动docker
systemctl restart docker
systemctl enable docker 

#卸载docker
yum remove -y docker-ce-xxx
```



## docker常用命令

```perl
#docker服务命令
systemctl start docker #启动
systemctl stop docker #停止
systemctl restart docker #重启
systemctl enable docker #docker设置随服务启动而自启动
systemctl status docker #查看docker运行状态
docker info #查看docker系统信息
docker version #显示docker版本
#镜像管理命令
docker search 镜像名 #搜索镜像
docker pull 镜像名：tag #拉取镜像
docker images ls #列出镜像
docker rmi 镜像id #删除镜像
docker save -o nginx.tar nginx:latest #打包镜像
docker load -i nginx.tar #导入镜像
#删除全部镜像  -a 意思为显示全部, -q 意思为只显示ID
docker rmi -f $(docker images -aq)

#容器管理命令
docker ps #列出正在运行的容器
docker ps -a #列出停止运行的容器
docker run 详细参数
-d :分离模式: 在后台运行
-i :即使没有附加也保持STDIN 打开
-t :分配一个伪终端
-v, --volume=[]            给容器挂载存储卷，挂载到容器的某个目录    顺序：主机：容器
--rm:容器停止后 自动删除容器
-p 宿主机端口：容器端口 #端口映射
-P 随机端口映射

#实例
docker exec -it nginx /bin/bash

docker commit 容器名 生成的镜像名 #将正在运行的容器生成新的镜像
docker stop 容器id/容器名
docker kill 容器ID/容器名 #kill 容器
docker start 启动容器
docker restart 容器id #重启容器
docker logs -f 容器id #查看容器日志
docker cp 容器名：路径 宿主机路径 #将容器里的文件拷贝到宿主机上
docker inspect 容器id #查看容器的详细信息
docker exec -it 容器id bash #进入容器内
docker port 容器id #查看容器端口映射

#删除全部容器
docker rm -f $(docker ps -aq)



```

## dockerfile

#### 镜像定制 

* 手动修改容器内容，导出新的镜像
* 基于dockerfile自行编写指令，基于指令流程创建镜像

dockerfile 主要组成部分

```dockerfile
FROM centos:7.8 #指定基础镜像
RUN yum install openssh-server -y #制作镜像操作执行指定
CMD ["bin/bash"] #容器启动时执行指令
```

dockerfile 指令学习

```dockerfile
FROM
MAINTAINER
RUN
ADD
WORKDIR
VOLUME
EXPOSE
CMD
```













