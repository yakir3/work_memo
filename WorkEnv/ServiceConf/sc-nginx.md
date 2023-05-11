```shell
# 编译安装参数
./configure --with-openssl =... --with-zlib=... --with-pcre=... --with-cc-opt=-02 --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-htp_addition_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module with-stream_ssl_preread_module with-stream_with-compat --add-module=ngx_http_geoip2_module/ --add-module=ngx_devel_kit/--add-module=echo-nginx-module/ --add-module=array-var-nginx-module/ --add-module=headers-more-nginx-module/ --add-module=set-misc-nginx-module/ --add-module=lua-nginx-module/ --add-module=nginx-upstream_check_module/ --with-ld-opt=-Wl,-rpath,/usr/local/nginx/luajit2/lib/

# Fastdfs模块
--add-module=fastdfs-nginx-module-master/src
# rtmp模块
--add-module=../nginx-rtmp-module

1、proxy_redirect 重定向url

2、获取用户ip及原理
proxy_set_header


proxy_set_header Host $host; ###
proxy_set_header X-Real-IP $remote_addr; ###X-real-ip是一个自定义的变量名，名字可以随意取，这样做完之后，用户的真实ip就被放在X-real-ip这个变量里
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; ###客户端ip和第一台nginx的ip，两层nginx “用户的真实ip，第一台nginx的ip”，
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $connection_upgrade

3、session_sticky
首先根据轮询RR随机到某台后端，然后在响应的Set-Cookie上加上route=md5(upstream)字段，第二次请求再处理的时候，发现有route字段，直接导向原来的那个节点


4、nginx支持websocket长连接
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade"

5、变量
$uri 指的是请求的文件和路径，不包含”?”或者”#”之类的东西
$request_uri 则指的是请求的整个字符串，包含了后面请求的东西
例如：
$uri： www.baidu.com/document
$request_uri： www.baidu.com/document?x=1

6、thinkphp重写规则

7、sni
http://blog.csdn.net/cccallen/article/details/6672451
编译openssl和nginx时候开启TLS SNI (Server Name Identification) 支持，这样你可以安装多个SSL，绑定不同的域名，可以共享同一个ip


8、limit_conn、limit_req模块
```
