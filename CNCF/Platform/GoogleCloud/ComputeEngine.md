##### how to add a storage disk
```shell
# 1. add new disk to VM instances
#operate in console
# 2. init pv volume
# create pv volume
pvcreate /dev/sdb
# create vg volume
vgcreate vg_name /dev/sdb
# create lvs volume
lvcreate -l +100%free -n lv_name vg_name
# format lvs
mkfs.ext4 /dev/vg_name/lv_name
# mount
uuid=$(blkid /dev/mapper/vg_name-lv_name |awk '{print $2}' |awk -F'[="]+' '{print $2}')
echo "UUID=$uuid /mnt/dir ext4 defaults 0 0" >> /etc/fstab
mount -a


# expand disk capacity
## option1: expand the original disk
# get original disk name and pvresize
fdisk /dev/sdb # if /dev/sdb partition
pvs -a -o +devices
pvresize /dev/sdb
# get lv name and extend
lvdisplay
lvextend -l +100%free /dev/vg_name/lv_name
resize2fs /dev/vg_name/lv_name

## option2: add new disk to expand
pvcreate /dev/sdc
# get vg name and add new pv to vg group
vgs
vgextend vg_name /dev/sdc
# get lv name and extend 
lvdisplay
lvextend -l +100%free /dev/vg_name/lv_name
resize2fs /dev/vg_name/lv_name

```