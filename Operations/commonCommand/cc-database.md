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
# login
psql -U user [-d database]

# create user,database and grant privileges
CREATE USER yakirtest WITH PASSWORD 'yakirtest';
CREATE DATABASE yakirtest OWNER yakirtest;
GRANT ALL PRIVILEGES ON DATABASE yakirtest TO yakirtest;
GRANT ALL PRIVILEGES ON all tables in schema public TO yakirtest;

# select all database
\l

# switch database
\c database

# select custom table and table schema
\d
\d table;

# select all scheme
select * from information_schema.schemata;

# select all tables
select * from pg_tables;


```