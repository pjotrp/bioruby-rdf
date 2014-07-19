#! /bin/sh

sparql=$1
shift

erb $sparql | ~/opt/bin/sparql-query "http://localhost:8000/sparql/?soft-limit=-1" -p -n |xalan -q -xsl $HOME/izip/git/opensource/ruby/bioruby-rdf/scripts/sparql-results-csv.xsl

