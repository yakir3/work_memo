#### Build Install
```shell
# centos
yum install -y make gcc zlib-devel bzip2-devel openssl-devel ncurses-devel libffi-devel

# ubuntu
apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget libbz2-dev libsqlite3-dev

# build 
./configure --prefix=/usr/local/python3_11_1 --enable-loadable-sqlite-extensions --enable-shared --enable-optimizations
# 常用的编译参数
--enable-shared: 开启动态链接库支持，允许其他程序链接 Python 库
--enable-optimizations: 开启编译优化
--enable-ipv6: 开启 IPv6 支持
--enable-loadable-sqlite-extensions: 允许动态加载 SQLite 扩展
--with-system-expat: 使用系统的 expat 库
--with-system-ffi: 使用系统的 ffi 库
--with-openssl: 指定 OpenSSL 库的路径
--with-zlib=: 指定 zlib 库的路径
--with-bz2=: 指定 bzip2 库的路径
--with-tcltk=: 指定 Tcl/Tk 库的路径

# install
make && make install
```

#### Pycharm
##### active
```shell
cat ideaActive/ja-netfilter-all/ja-netfilter/readme.txt
```

##### config
```shell
# Editor
Font
Color Scheme

# Plugins
# themes
gradianto
# json show
rainbow brackets

# Project
Python Interpreter

# Build,Execution,Deployment
Deployment

# Tools
Python Intergrated Tools -> Docstring format: Google

```

