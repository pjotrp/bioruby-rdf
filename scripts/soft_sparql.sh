#! /bin/sh

sparql=$1
shift

~/opt/bin/sparql-query "http://localhost:8000/sparql/?soft-limit=100" -p < $sparql
