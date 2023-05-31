### apt 软件包操作相关
```shell
# 更新软件仓库
apt update

# 查看所有已有仓库源
apt policy

# 查看 apt 所有已安装的软件包
apt list --installed

# 搜索关键字可安装的软件包
apt search dig |grep bin
# apt-file 方式搜索，结果更多
apt install apt-file
apt-file update
apt-file search dig |grep bin

# 搜索命令属于哪个软件包
dpkg -S /usr/bin/lsb_release
# 查看 apt 已安装的软件包所有相关文件
dpkg -L lsb-release



```