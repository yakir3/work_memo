```shell
# add share lib search
# option 1 
LD_LIBRARY_PATH=/opt/pgsql/lib
export LD_LIBRARY_PATH
# option 2
ldconfig 


# add env and man path
PATH=/usr/local/pgsql/bin:$PATH
export PATH
MANPATH=/usr/local/pgsql/share/man:$MANPATH
export MANPATH


# position 
$# 表示参数的个数
${[*]}  ${[@]} 相同，遍历数组
$@ 表示参数列表
$* 则把所有的参数当作一个字符串显示
$* 和 $@ 区别：当它们被双引号(" ")包含时，"$*" 会将所有的参数作为一个整体，以"$1 $2 … $n"的形式输出所有参数；"$@" 会将各个参数分开，以"$1" "$2" … "$n" 的形式输出所有参数


# 释放内存 sync
echo 1 > /proc/sys/vm/drop_caches
# drop_caches的值可以是0-3之间的数字，代表不同的含义
# 0：不释放（系统默认值）
# 1：释放页缓存
# 2：释放dentries和inodes
# 3：释放所有缓存
# 释放完内存后改回去让系统重新自动分配内存
echo 0 > /proc/sys/vm/drop_caches
# 释放所有缓存
echo 3 > /proc/sys/vm/drop_caches

```
