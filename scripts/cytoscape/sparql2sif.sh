#! /bin/sh

sparql=$1
shift

erb $sparql | ~/opt/bin/sparql-query "http://localhost:8000/sparql/?soft-limit=-1" > sparql-result.xml -n

# edit file!

xalan -xsl ~/izip/git/opensource/ruby/bioruby-rdf/scripts/sparql-results-csv.xsl -in sparql-result.xml > sparql-result.csv 

~/izip/git/opensource/ruby/bioruby-table/bin/bio-table sparql-result.csv 

~/izip/git/opensource/ruby/bioruby-table/bin/bio-table sparql-result.csv --rewrite 'field[0] = "PATHWAY\t"+field[0]' 
