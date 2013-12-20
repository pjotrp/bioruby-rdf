#! /bin/sh

rdf=$1
# ---- test syntax
rapper -i turtle $rdf > /dev/null

uri=http://localhost:8000/data/http://biobeat.org/data/$rdf

curl -X DELETE $uri
curl -T $rdf -H 'Content-Type: application/x-turtle' $uri


