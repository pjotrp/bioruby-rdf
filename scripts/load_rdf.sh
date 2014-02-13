#! /bin/sh

PORT=8000

for rdf in $* ; do
  echo "Loading $rdf"
  # ---- test syntax
  rapper -i turtle $rdf > /dev/null

  uri=http://localhost:$PORT/data/http://biobeat.org/data/$rdf

  curl -X DELETE $uri
  curl -T $rdf -H 'Content-Type: application/x-turtle' $uri
done

