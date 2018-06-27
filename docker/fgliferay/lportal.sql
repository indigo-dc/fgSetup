drop database if exists LFRY_DBNAME;
create database LFRY_DBNAME;
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
