# bio-rdf

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-rdf.png)](http://travis-ci.org/pjotrp/bioruby-rdf)

Library and tools for using an RDF triple-store with biological data.
It includes tools for storing parsed data into a triple store. The
name includes RDF, but that really is too a narrow view of the purpose
of this tool, unfortunately alternative names (bio-semweb and
bio-triplestore) are even worse.

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

Functionality:

* [PubMed:Entrez](http://www.ncbi.nlm.nih.gov/sites/gquery) to table and RDF
* [GSEA](http://www.broadinstitute.org/gsea/index.jsp), gene set enrichment analysis, to table

(more information below) 

Note that any table file can be turned into RDF using the bio-table rubygem,
which is automatically installed by bio-rdf. E.v.

  bio-table --format rdf table.csv

This project is linked with next generation sequencing, genome
browsing, visualisation and QTL mapping.  E.g.

* [bio-ngs](http://www.biogems.info/#bio-ngs)
* [bio-bio-ucsc-api](http://www.biogems.info/#bio-ucsc-api)
* [bio-qtlHD](http://www.biogems.info/#bio-qtlHD)

Note: this software is under active development and will grow
significantly over time! See also the [design
doc](https://github.com/pjotrp/bioruby-rdf/blob/master/doc/design.md).

## Examples

### Pubmed:Entrez (NCBI Pubmed)

PubMed comprises more than 22 million citations for biomedical
literature from MEDLINE, life science journals, and online books.

bio-rdf uses the BioRuby PubMed module to fetch Pubmed records and
writes them to a tab delimited output with

```bash
  bio-rdf pubmed --tabulate --search "Prins [au] BioGem"
```

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

## Installation

```sh
    gem install bio-rdf
```

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

Copyright (c) 2012 Pjotr Prins. See LICENSE.txt for further details.

