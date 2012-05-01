# bio-rdf

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-rdf.png)](http://travis-ci.org/pjotrp/bioruby-rdf)

Library and tools for using a triple-store with biological data.  It
includes tools for storing parsed data into a triple store. The name
includes RDF, the XML representation of triples, but that really is
too a narrow view of the purpose of this biogem. The alternative names
(bio-semweb and bio-triplestore) even look worse.

The first functionality includes parsing the results of gene set
enrichment analysis
([GSEA](http://www.broadinstitute.org/gsea/index.jsp)) into triples
(more below). 

This project is linked with next generation sequencing, genome
browsing, visualisation and QTL mapping.  E.g.

* [bio-ngs](http://www.biogems.info/#bio-ngs)
* [bio-bio-ucsc-api](http://www.biogems.info/#bio-ucsc-api)
* [bio-qtlHD](http://www.biogems.info/#bio-qtlHD)

Note: this software is under active development! See also the [design
doc](https://github.com/pjotrp/bioruby-rdf/blob/master/doc/design.md).

## Examples

### Gene set enrichment analysis (GSEA)

GSEA is a computational method that determines whether an a priori
defined set of genes shows statistically significant, concordant
differences between two biological states. The [GSEA
tool](http://www.broadinstitute.org/gsea/index.jsp) produces two
result files for every two biological states. We wrote a parser
for the summary files, which outputs either a single table of results
(based on a cut-off value). This table can be converted into a
triple-store.



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

