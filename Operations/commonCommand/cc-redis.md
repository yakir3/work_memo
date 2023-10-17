```shell
# redis cluster 
# pattern search key
redis-cli -h host -a password -c --scan --pattern "mykey*"
# batch delete key
redis-cli -h host -a password -c --scan --pattern "mykey*" |xargs -I {} redis-cli  -h host -a password del {}


```