#! /bin/sh

killall 4s-httpd
killall 4s-backend

dbname=biorubyrdftest
4s-backend-setup $dbname
4s-backend $dbname
4s-httpd -p 8000 $dbname

