# GWP pipe-line

## Introduction

The GWP pipe-line searches evidence of evolutionary positive selection in gene
families. The tools are run in a pipe-line and the results are in a tree of
files. 

# GWP RDF

## Creating GWP RDF

We parse this information and store the results in a triple-store to
ease data exploration. The parsers that are used to generate RDF are stored in
./lib/bio-rdf/extra/gwp.

The generated RDF can be viewed in the cucumber features, which are listed
[https://github.com/pjotrp/bioruby-rdf/blob/master/features/extra/parse_gwp.feature](here).
Essentially all clusters showing evidence of positive selection are listed by
their cluster identifier. Separately, all genes that are included in some
cluster and show homology to another cluster are listed by a gene identifier.
The power of SPARQL allows us to do within species and between species
comparisons of genes and their (putative) gene families.

## Loading RDF

The RDF turtle file can be loaded all [http://www.w3.org/RDF/](W3C semantic web) triple stores (that is what standards are for!), 
thouge you may have to convert to XML RDF first, e.g. with rapper. When using
4store follow the instructions in the bio-rdf [https://github.com/pjotrp/bioruby-rdf](README). 

The latest RDF file can be fetched from biobeat.org (FIXME). Load it into 
4store with, for example,

```sh
curl -T all.rdf -H 'Content-Type: application/x-turtle'  http://localhost:8000/data/gwp.rdf
```

When pointing the browser at http://localhost:8000/status you should see at least
X million triples imported.

## Querying GWP RDF with SPARQL

In this section presents SPARQL queries available for the GWP triple store.
With 4store these queries can be run using the script ./scripts/sparql.sh.
This script uses sparql-query which has direct tabular output on the terminal.
Alternatively you could use direct 4store SPARQL queries and transform the
XML output with XSLT into tabular data or XHTML.

All SPARQL queries are listed in ./sparql/extra/gwp. A query can be run
with 

```sh
  ./scripts/sparql.sh query.rq
```

### Query for clusters under positive selection

In the first query we simply count the number of clusters and
group them by species and source (where source may be CDS or EST
sequences):

```sparql
  SELECT ?species ?source (COUNT(?cluster) AS ?num) WHERE 
  { 
    ?cluster :species ?species .
    ?cluster :source ?source .
  }
  GROUP by ?species ?source
  ORDER by ?species ?source
```

The full listing is in count.rq.

Next we count the subset of clusters that show
evidence of positive selection:

```sparql
  SELECT ?species ?source (COUNT(?name) AS ?num) WHERE 
  { 
    ?cluster :is_pos_sel true .
    ?cluster :species ?species .
    ?cluster :source ?source .
  }
  GROUP by ?species ?source
  ORDER by ?species ?source
```

which picks out all ?cluster identifiers which have :is_pos_sel set
to true. 
The full listing is in count_pos_sel.rq.
