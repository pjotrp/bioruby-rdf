# bio-rdf

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-rdf.png)](http://travis-ci.org/pjotrp/bioruby-rdf)

Library and tools for using an RDF triple-store with biological data.  To work
with RDF it is often necessary to parse some (tabular) data and output RDF.
This repository contains a collection of functions to parse files and generate
RDF, allowing one to store data into a triple store. 

There are some nuggets of gold to be found in this repository

1. Generic data parsers and generic generators that churn out (Turtle) RDF
2. bioruby-table as a tool for RDF generation from tabular data
3. Command line SPARQL combined with ERB templating

also

4. Cucumber tests for RDF generation

The name includes RDF, but that really is too a narrow view of the
purpose of this tool, unfortunately alternative names (bio-semweb and
bio-triplestore) are even worse, so we'll stick to bio-rdf.

At this point this library is a work in progress. Together with the
[https://github.com/wstrinz/publisci](publisci) module by Will Strinz,
we aim to get to a unified approach for data parsing and RDF output.

## Parsers

First there are the parsers.  Every (native) data-type has a parser
module. This parser module controls the parsing flow. The actual
parsing is handled by lower level routines, which may even reside in
other libraries, such as BioRuby. The basic flow is 

  input -> parser -> output

The *input* can be anything, from directories, files to web based
resources.

The *output* of the parser should be in some form of RDF triple format,
though simple tab delimited tables can also be supported (depending on
the parser/outputter).

Existing functionality:

* [PubMed:Entrez](http://www.ncbi.nlm.nih.gov/sites/gquery) to table and RDF
* [GSEA](http://www.broadinstitute.org/gsea/index.jsp), gene set enrichment analysis, to table and RDF
* Somatic calling and copy number variation: varscan2, somatic sniper and more

more information on that below.

Note that any table file can be turned into RDF using the bio-table rubygem,
which is automatically installed by bio-rdf. Example:

  bio-table --format rdf table.csv

This project is linked with next generation sequencing, genome
browsing, visualisation and QTL mapping.  E.g.

* [biointerchange](https://github.com/BioInterchange/BioInterchange)
* [bio-ngs](http://www.biogems.info/#bio-ngs)
* [bio-bio-ucsc-api](http://www.biogems.info/#bio-ucsc-api)
* [bio-qtlHD](http://www.biogems.info/#bio-qtlHD)

See also the [design
doc](https://github.com/pjotrp/bioruby-rdf/blob/master/doc/design.md).

A list of important converters is at
[W3C](http://www.w3.org/wiki/ConverterToRdf).

## Parser functionality

Existing bio-rdf parsers are listed on
[github](https://github.com/pjotrp/bioruby-rdf/tree/master/lib/bio-rdf/parsers).
Here we describe the important ones:

### Pubmed:Entrez (NCBI Pubmed)

PubMed comprises more than 22 million citations for biomedical
literature from MEDLINE, life science journals, and online books.

bio-rdf uses the BioRuby PubMed module to fetch Pubmed records and
writes them to a tab delimited output with

```bash
  bio-rdf pubmed --tabulate --search "Prins [au] BioGem"
```

prints 

"pubmed","authors","title","journal","year","volume","issue","pages","doi","url"
"Sharing programming resources between Bio* projects through remote procedure call and native call stack strategies.","Methods Mol Biol","2012","856","","513-527","10.1007/978-1-61779-585-5_21","http://www.ncbi.nlm.nih.gov/pubmed/22399473"

You can reformat the author list output with 

```bash
  bio-rdf pubmed --tabulate --search 'Pjotr Prins [au] Bio' --format-author "surname+' '+initials.join('')" --format-authors-join ', '
```

which produces "Prins P, Goto N, Yates A, Gautier L, Willis S, Fields C, Katayama T" rather than
the default. 

You can convert the tabular format to RDF by using the included
bioruby-table tool.

### Gene set enrichment analysis (GSEA)

GSEA is a computational method that determines whether an a priori
defined set of genes shows statistically significant, concordant
differences between two biological states. The [GSEA
tool](http://www.broadinstitute.org/gsea/index.jsp) produces two
result files for every two biological states. We wrote a parser
for the summary files, which outputs either a single table of results
(based on a cut-off value). This table can be converted into a
triple-store. 

To create a tab delimited file from a GSEA result, where FDR < 0.25

```bash
  bio-rdf gsea --tabulate --exec "rec.fdr <= 0.25" ./gsea/output/ > results.txt
```

You can convert the tabular format to RDF by using the included
bioruby-table tool.

### Mapping Affymetrix probes to sequence information, through R/Bioconductor

[R/Bioconductor](http://www.bioconductor.org/) contains a lot of
modules with
annotation data. This 
[document](https://github.com/pjotrp/bioruby-rdf/blob/master/doc/r_biocondutor.md).
explores getting annotation data into a triple
store. E.g., the first exercise matches Arabidipsis Affy probe to gene ID mapping
information, and fetches the matching nucleotide sequences via a shared TAIR ID.

See [document](https://github.com/pjotrp/bioruby-rdf/blob/master/doc/r_biocondutor.md).

### Somatic variant calling and copy number variation

```bash
  bio-rdf variant --help
```

### More examples

Research oriented RDF parsers (aka one-offs) are included in
[extra](https://github.com/pjotrp/bioruby-rdf/tree/master/lib/bio-rdf/extra).
The documentation can be found in 
[doc](https://github.com/pjotrp/bioruby-rdf/tree/master/doc/extra).

## Installation

```sh
    gem install bio-rdf
```

In principle you can use bio-rdf with *any* RDF triple store.

To run the tests, however, you'll also need to install and run the 
[4store](http://4store.org/) RDF triple
store, which supports Linux and OS X only. E.g. on Debian/Ubuntu

```sh 
    apt-get install 4store    
```

you may need to add the user to the fourstore group and create the
/var/lib/4store/ directory with the appropriate permissions. E.g.

```sh
    dbname=biorubyrdftest
    # as root
    mkdir /var/lib/4store/
    mkdir /var/lib/4store/$dbname
    chown fourstore.fourstore -R /var/lib/4store/
    chmod g+rw -R /var/lib/4store/
    # as normal user (this is what the test system does)
    4s-backend-setup $dbname
    4s-backend $dbname
    4s-httpd -p 8000 $dbname
```

now this should work

```sh
    # as user (if added to the fourstore group)
    bundle exec rake
```

To test for valid Turtle RDF rapper may help:

```sh
    rapper -i turtle file.rdf
```
    
Also visit http://localhost:8080/status/

Load 4-store with a database through

Load with

```sh
  rdf=file.rdf
  rapper -i turtle $rdf
  uri=http://localhost:8080/data/http://biobeat.org/data/$rdf

  curl -X DELETE $uri
  curl -T $rdf -H 'Content-Type: application/x-turtle' $uri
```

Again visit http://localhost:8080/status/

Next

```sh
  ~/opt/local/bin/sparql-query --pipe localhost:8000/sparql/ < test_gsea.rq 
```

Convert XML with XSL to a comma separated file (CSV)

```sh
  xalan -xsl ./scripts/sparql-results-csv.xsl -in sparql-result.xml
```

~
Useful headers

# RDF output by bio-exominer https://github.com/pjotrp/bioruby-exominer
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix hgnc: <http://identifiers.org/hgnc.symbol/> .
@prefix ncbigene: <https://www.google.nl/search?q=ncbi+gene+alias+> .
@prefix : <http://biobeat.org/rdf/exominer/ns#>  .


Command line SPARQL queries can be done with 4s-query and
[sparql-query](https://github.com/pjotrp/sparql-query). The latter has 
the advantage of generating readable (non-XML) output. To install 
sparql-query, fetch the git repository and

```sh
    apt-get install libglib2.0-dev libcurl4-openssl-dev libxml2-dev
    make
```

Example:

```sh
./sparql-query "http://localhost:8080/sparql/" 'SELECT * WHERE { ?s ?p ?o } LIMIT 10'
  .--------------.
  | ?s | ?p | ?o |
  |----+----+----|
  '--------------'
```

Empty result, if it is empty :). Note the final slash on the URL. For
4store you also may want to disable the 
the soft-limit, e.g.

```sh
./sparql-query "http://localhost:8080/sparql/?soft-limit=-1" 'SELECT * WHERE { ?s ?p ?o } LIMIT 10'
```

## SPARQL with ERB and parameters

ERB can help reuse SPARQL queries. Here is an
[example](https://github.com/pjotrp/bioruby-rdf/tree/master/sparql/variant_calling/varscan_freq_vs_coverage.rq).

## Usage

```ruby
    require 'bio-rdf'
```

The API doc is online. For more code examples see the test files in
the source tree.
        
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/pjotrp/bioruby-rdf

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at [#bio-rdf](http://biogems.info/index.html)

## Copyright

Copyright (c) 2012,2013,2014 Pjotr Prins. See LICENSE.txt for further details.

