#! /bin/bash
#
#  Options
#
#    -r     Restart server
#    -d     Delete DB and restart server

if [ "$1" == "-r" ] ; then
  echo "Restarting"
  restart=1
  shift
fi
if [ "$1" == "-d" ] ; then
  echo "Deleting"
  delete=1
  shift
fi

dbname=biorubyrdftest
if [ ! -z $1 ] ; then
  dbname=$1
  shift
fi

echo Starting DB $dbname

if [ "$restart" == "1" ]; then
  killall 4s-httpd
  killall 4s-backend
fi

if [ "$delete" == "1" ]; then
  killall 4s-httpd
  killall 4s-backend
  4s-backend-setup $dbname
fi


4s-backend $dbname
4s-httpd -p 8000 $dbname

