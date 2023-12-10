#### iostat
```shell
# install
apt install sysstat
# use
iostat [options] [delay [count]]


# probe uninterrupted every 2 seconds
iostat 2
# probe 10 times per second
iostat 1 10


# display info
-c     Display the CPU utilization report.
-d     Display the device utilization report.
-h     Display human
-x     Display extended statistics
-t     Display timestamp

# example
iostat -dhx sda sdb 1 10


```