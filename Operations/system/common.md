free memory
```shell
# free vm memory
# 0：不释放（系统默认值）
# 1：释放页缓存
# 2：释放 dentries 和 inodes
# 3：释放所有缓存
# 释放完内存后将值改为0让系统重新自动分配内存
echo 0 > /proc/sys/vm/drop_caches

```