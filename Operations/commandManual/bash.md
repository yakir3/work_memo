##### env
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

##### exec
```shell
# define shell script output log
exec 1> /dev/null
exec 1>> /tmp/output.log
exec 2> /dev/null
exec 2>> /tmp/err.log

# custom file descriptor output
#/usr/bin/env bash
exec 999<>/tmp/yakir.log
echo console_output >&999
commanderror 2>&999 >&999
exec 999>&-

#
exec $@

```

##### function
```shell
# define local variable
# option1: use local
fuction test() {
    local my_key=my_value
    echo $my_key
}
# option2: use (), function will be executed in chirldr process
function test() (
    my_key=my_value
    echo $my_key
)

```

##### set 
```shell
# set to environment variable
set -a testk
set -o allexport

# exit the shell script if returned by the command is not equal 0
set -e
set -o errexit
# return the value of pipline rightmost command if it non-zero status 
set -o pipefail

# cancle to use wildcards
set -f 
set -o noglob

# monitor mode
set -m
set -o monitor

# only reads instructions without actually executing them
set -n
set -o noexec

# exit after reading and executing one command.
set -t
set -o onecmd

# display error if variable not exists
set -u
set -o nounset

# display parameters after executing command
set -x
set -o xtrace



```

##### truncate string
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



>Reference:
> 1. [Shell command official manual](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
> 2. [关于 Bash 的 10 个常见误解](https://xie.infoq.cn/article/247481c8dc6dc4607c1d7515e)
