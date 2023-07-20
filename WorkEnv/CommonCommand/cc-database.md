#### mysql
```shell
# init reset password
mysql -u root -p
mysql -u root --skip-password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root-password';

# create database with character
CREATE DATABASE yakir_test DEFAULT CHARACTER SET utf8mb4 COLLATE utf8_general_ci;

# create account and grant
use mysql
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'new_user'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'new_user'@'%';
FLUSH PRIVILEGES;


```

### postgres
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