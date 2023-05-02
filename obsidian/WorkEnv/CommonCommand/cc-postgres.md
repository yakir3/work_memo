```shell
# 登录
psql -U user

# 创建用户及授权
CREATE USER dbtest WITH PASSWORD 'dbtest';
GRANT ALL PRIVILEGES ON DATABASE dbtest TO dbtest;
GRANT ALL PRIVILEGES ON all tables in schema public TO dbtest;

# 查看所有库
\l

# 切换数据库
\c database

# 查看表
\d

```