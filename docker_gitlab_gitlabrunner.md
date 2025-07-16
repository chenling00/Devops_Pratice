# 基于 Docker ( Gitlab、Gitlab Runner ) 搭建一整套自动化CI、CD流程，完成从代码提交到自动打包编译到自动部署运行

![于 Docker ( Gitlab、Gitlab Runner ) 搭建一整套自动化CI、CD流程，完成从代码提交到自动打包编译到自动部署运行](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/61a7b7cb610e4cddbd4852dc0a311832~tplv-k3u1fbpfcp-zoom-crop-mark:3024:3024:3024:1702.awebp?)

> 作为一个前端，以前在公司内接触过搭建成熟的完整CI、CD流程，后来在想是否自己也能搭建这样一套系统，通过学习研究后有了这样一篇博客，和各位一起共同学习。

首先大家需要一台服务器，本机电脑也行（推荐2核8G配置以上，因为安装的服务比较占内存）。

### 一、安装 Docker

`linux`服务器使用`curl`下载快速安装的`shell`脚本

```arduino
curl -fsSL get.docker.com -o get-docker.sh
复制代码
```

下载完成后，可以`ls`命令查看一下。已经存在的话，使用`sh`命令执行这个脚本

```arduino
sh get-docker.sh
复制代码
```

注意如果不是`root`用户，需要使用`sudo su`获取超级管理员权限。

安装完成后启动一下`Docker Server`

```sql
systemctl start docker
复制代码
```

使用`docker version`命令能看到`Client`和`Server`就启动成功了。

### 二、基于 Docker 安装 Gitlab

#### 1. 一键安装命令

```lua
docker run --detach \
  --hostname localhost \
  --publish 443:443 --publish 80:80 --publish 222:22 \
  --name gitlab \
  --restart always \
  --privileged=true \
  --volume /home/gitlab/config:/etc/gitlab \
  --volume /home/gitlab/logs:/var/log/gitlab \
  --volume /home/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest
复制代码
```

`hostname`: 这里改成你自己的域名(域名要设置解析)或服务器ip

`publish`: 端口映射(服务器端口：容器内端口)

`restart`: 重启方式

`volume`: 目录挂载，把容器内目录挂载到服务器本地(服务器本地目录：容器内目录)
privileged=true:让容器获取宿主机root权限

`gitlab/gitlab-ce:latest` 镜像名称

#### 2. 安装完成后通过域名或服务器ip访问

通过`root`用户登陆

`root`用户默认密码，通过

```bash
docker exec -it gitlab sh
复制代码
```

shell命令方式进入容器内，然后

```bash
cat /etc/gitlab/initial_root_password
复制代码
```

查看默认密码，`root`用户登陆后，记得改默认密码，这个默认密码文件在24小时后会自动删除。

### 三、基于 Docker 安装 Gitlab Runner、

`Gitlab Runner` 就是提供我们的CI、CD能力的工具。

#### 1. 一键安装运行 Gitlab Runner

```arduino
docker run -d --name gitlab-runner --restart always \
  -v /home/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
复制代码
```

`-d`: 后台运行

`--name`: 指定运行后的容器名

`restart`: 重启方式

`-v`: 目录挂载

#### 2. 查看Gitlab Runner配置信息

安装好`Gitlab Runner`后，它只是在容器内运行的一个服务，我们需要让它与`Gitlab`关联起来，此时需要注册`Gitlab Runner`。

首先在`Gitlab`上，通过`root`用户个人设置页面，`overview`里面有个`Runners`的配置项，可以看到`token`，在注册的时候需要用。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/48f3a092251f4f89987dab99722d87fa~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp?)

#### 3. 注册Gitlab Runner

运行注册命令

```arduino
docker run --rm -v /home/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:latest \
  --url "http://localhost/" \
  --registration-token "xxxxxx" \
  --description "runner" \
  --tag-list "build" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"
复制代码
* --url`: 后面改成刚才你`gitlab`上的`url
* registration-token`: 后面改成`gitlab`上查看的`token
```

其他配置项都是些基本信息，如`tag`、`description`等。

注册成功后在`gitlab`刷新就可以看到

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f2c90aed55c74013a0db7a59677f18fb~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp?)

到这，我们基本的`CI、CD`能力已经有了，后面就是编写`.gitlab-ci.yml`来提供给我们`gitlab runner`相应的配置。它会按照我们编写的这个文件来执行相应的操作。

### 四、编写 .gitlab-ci.yml 提供CI、CD配置项

#### 1. 提供前端编译、构建功能

在项目根目录下创建一个`.gitlab-ci.yml`的文件，写入如下

```yaml
image: node:16.13.2-slim

stages: # 分段
  - install
  - eslint
  - build
  - deploy

cache: # 缓存
  paths:
    - node_modules
    - dist

job_install:
  tags:
    - build
  stage: install
  script:
    - npm install

job_build:
  tags:
    - build
  stage: build
  script:
    - npm run build
复制代码
image`: 指定基础镜像环境，前端就是`node、docker`等，后端有`java、python、docker
```

`stages`: 指定执行的阶段有哪些，流水线执行时会按照这个阶段顺序执行

`cache`: 针对哪些目录启用缓存

`job`: 指定每个阶段执行的任务，`tags`就是使用的`runner`，`stage`指定阶段，`script`指定相应执行的`shell`命令

代码`push`之后流水线就会自动根据这个文件执行，执行的情况可以在下图地方查看

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bd3e34de75f14b01a6e60c0c48b942ca~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp?)

#### 2. nginx配置文件编写

在项目根目录创建`nginx.conf`文件，把这个文件复制到容器内作为nginx配置文件，写入以下内容

```ini
server {
  #端口
  listen 80; 
  server_name localhost;

  #charset koi8-r;
  access_log /var/log/nginx/host.access.log main;
  error_log /var/log/nginx/error.log error;

  #配置 vue 路由 history模式
  location / {
    root /usr/share/nginx/html;
    try_files $uri $uri/ /index.html;
  }

  #error_page 404 /404.html;
  # redirect server error pages to the static page /50x.html
  #
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}
复制代码
```

#### 3. Dockerfile文件编写

在项目根目录下创建`Dockerfile`文件，`runner`会根据这个文件创建一个的`docker`镜像，文件写入以下内容

```ruby
FROM nginx
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
复制代码
```

#### 4. 使用docker自动部署前端项目

首先是`.gitlab-ci.yml`文件编写

```yaml
image: node:16.13.2-slim

stages: # 分段
  - install
  - eslint
  - build
  - deploy

cache: # 缓存
  paths:
    - node_modules
    - dist

job_install:
  tags:
    - build
  stage: install
  script:
    - npm install

job_build:
  tags:
    - build
  stage: build
  script:
    - npm run build

job_deploy:
    image: docker
    stage: deploy
    script:
      - docker build -t appimages .
      - if [ $(docker ps -aq --filter name=app-container) ]; then docker rm -f app-container;fi
      - docker run -d -p 8080:80 --name app-container appimages
复制代码
```

主要是多了`deploy`阶段的任务

`image`: 使用`docker`镜像

`script第一行`: 根据我们项目目录下的`Dockerfile`文件创建一个`docker`镜像

`script第二行`: 判断`name=app-container`这个容器是否在运行，在运行的话就进行销毁

`script第三行`: 根据我们打包出来的镜像启动一个`app-container`的容器

------

到此部署的配置基本完成，但是部署的时候可能会遇到一个连接错误的问题

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e30c5d8b61df4ad4944686413e84bea5~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp?)

通过

```arduino
vi /home/gitlab-runner/config/config.toml
复制代码
```

修改`runner`的配置项，对相应的`runner`内容卷这加`"/usr/bin/docker:/usr/bin/docker", "/var/run/docker.sock:/var/run/docker.sock"`

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dc20c650f7db470193ad296c923d124b~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp?)

**备注：volumes = ["/cache","/mnt/navdata:/mnt/navdata:rw"] 可以将宿主机mnt/navdata:映射到运行容器目录/mnt/navdata 中.**

> 
>   

## gitlab常用命令

```gitlab-ctl start 
gitlab-ctl stop # 停止所有 gitlab 组件；
gitlab-ctl restart # 重启所有 gitlab 组件；
gitlab-ctl status # 查看服务状态；
gitlab-ctl reconfigure # 重新加载配置；
gitlab-rake gitlab:check SANITIZE=true --trace # 检查gitlab；
gitlab-ctl tail # 查看日志；
cat /opt/gitlab/embedded/service/gitlab-rails/VERSION # 查看版本号
```

