#! /bin/sh

dbname=biorubyrdftest

if [ "$1" = "-r" ]; then
  killall 4s-httpd
  killall 4s-backend
  4s-backend-setup $dbname
fi

4s-backend $dbname
4s-httpd -p 8000 $dbname

