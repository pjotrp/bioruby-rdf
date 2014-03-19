#! /bin/sh

PORT=8000

for rdf in $* ; do
  echo "Loading $rdf"
  if [ ! -e $rdf ] ; then
    echo "Can not find file!!"
  else
    # ---- test syntax
    rapper -i turtle $rdf > /dev/null
    [ $? -ne 0 ] && exit 1

    uri=http://localhost:$PORT/data/http://biobeat.org/data/$rdf

    curl -X DELETE $uri
    curl -T $rdf -H 'Content-Type: application/x-turtle' $uri
  fi
done

