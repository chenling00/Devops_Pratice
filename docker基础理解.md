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



## docker 实超

1.下载安装docker

宿主机：linux（centos7）docker必须安装在centos7平台，且内核版本不低于3.10（内核查看：uname -r）

 

1.获取docker yum源（默认yum源在国外，下载速度慢）

wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

 

2.清理yum缓存和重建yum缓存，使最新的yum配置生效

yum clean all && yum makecache 

 

3.查看当前镜像源中支持的docker版本

yum list docker-ce --showduplicates | sort -r

 

4.安装特定版本的docker-ce

必须指定 --setopt=obsoletes=0,否则yum会自动安装更高版本

yum install --setopt=obsoletes=0 docker-ce-18.06.3.ce-3.el7 -y

 

5.配置docker镜像加速器，用于更快的下载镜像文件

mkdir /etc/docker

cat <<EOF > /etc/docker/daemon.json

{

"registry-mirrors": ["https://kn0t2bca.mirror.aliyuncs.com"]

}

EOF

 

6.启动docker

systemctl restart docker

systemctl enable docker

 

卸载docker

yum remove -y docker-ce-xxx







