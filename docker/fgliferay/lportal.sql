drop database if exists LFRY_DBNAME;
DROP USER IF EXISTS 'LFRY_DBUSER'@'%';
DROP USER IF EXISTS 'LFRY_DBUSER'@'localhost';
create database LFRY_DBNAME CHARACTER SET utf8 COLLATE utf8_general_ci;
create user 'LFRY_DBUSER'@'%';
alter user 'LFRY_DBUSER'@'%' identified by "LFRY_DBPASS";
grant all privileges
on LFRY_DBNAME.*
to 'LFRY_DBUSER'@'%'
with grant option;
create user 'LFRY_DBUSER'@'localhost';
alter user 'LFRY_DBUSER'@'localhost' identified by "LFRY_DBPASS";
grant all privileges
on LFRY_DBNAME.*
to 'LFRY_DBUSER'@'localhost'
with grant option;
