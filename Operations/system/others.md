#### env
```shell
# add share lib search
# option1 for tmp 
LD_LIBRARY_PATH=/opt/pgsql/lib
export LD_LIBRARY_PATH
# option2 for persistent
echo "/opt/pgsql/lib" >> /etc/ld.so.conf.d/pgsql.conf
ldconfig


# add env and man path
# option1 for tmp
PATH=/usr/local/pgsql/bin:$PATH
export PATH
MANPATH=/usr/local/pgsql/share/man:$MANPATH
export MANPATH
# option2 for persistent
echo "PATH=/usr/local/pgsql/bin:$PATH" >> ~/.bashrc
source ~/.bashrc


# free vm memory
# 0：不释放（系统默认值）
# 1：释放页缓存
# 2：释放 dentries 和 inodes
# 3：释放所有缓存
# 释放完内存后将值改为0让系统重新自动分配内存
echo 0 > /proc/sys/vm/drop_caches


# position 
$#               # args len
${[*]}  ${[@]}   # foreach list
$*   # args list, when use "", all parameter as one world
$@   # args list


```

#### truncate string
```shell
# truncate string
variable="Hello World"
echo "${variable#He}"   # output: llo World
echo "${variable%ld}"   # output: Hello Wor
echo "${variable:3:5}"  # output: lo Wo
echo "${variable#*o}"   # output: rld
echo "${#variable}"     # length
variable="path/to/some/file.txt"
result="${variable##*/}"   # longest match from start, get: file.txt
variable="path/to/some/file.txt"
result="${variable%%/*}"   # longest match from end, get: path

```

