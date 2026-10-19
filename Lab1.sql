Microsoft Windows [Version 10.0.26200.9711]
(c) Microsoft Corporation. All rights reserved.

C:\Users\OMEN>cd C:\Program Files\MySQL\MySQL Server 26.7\bin

C:\Program Files\MySQL\MySQL Server 26.7\bin>mysql -u root -p
Enter password: *********
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 26.7.0 MySQL Community Server - GPL

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
mysql> CREATE DATABASE demo_test;
Query OK, 1 row affected (0.099 sec)

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| demo_test          |
| information_schema |
| mysql              |
| performance_schema |
| sen307_2411264     |
| sys                |
+--------------------+
6 rows in set (0.025 sec)

mysql> CREATE DATABASE sen307_2411264;
ERROR 1007 (HY000): Can't create database 'sen307_2411264'; database exists
mysql> USE sen307_2411264;
Database changed
mysql> SELECT DATABASE();
+----------------+
| DATABASE()     |
+----------------+
| sen307_2411264 |
+----------------+
1 row in set (0.005 sec)

mysql> SHOW DATABASES;
