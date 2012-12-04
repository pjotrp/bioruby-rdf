# R/Bioconductor (semantic web mashups)

[R/Bioconductor](http://www.bioconductor.org/) contains a lot of modules with
annotation data. Here we explore how to get this annotation data into
a triple store. In the first exercise, we locate Affy probe
information to gene ID mapping information for _Arabidopsis thaliana_, and get
the matching nucleotide sequences via a shared TAIR ID. Next we do a
similar exercise for _Saccharomyces cerevisiae_ (yeast).

In the final step we automate the exercise by using an R script from the
bio-rdf
command and output the mapped probes to a regular table. The bio-table gem can
turn this information into RDF.

This exercise, by Pjotr Prins, was started at the Semantic Web Biohackathon 2012, Toyama,
Japan, as part of the Bio* work group.

## Fetching Arabidopsis probe information using ath1121501.db

The ath1121501.db package contains Affymetrix
Arabidopsis ATH1 Genome Array annotation data (chip ath1121501).

In R install the Arabidobsis Affymetrix package with

```R
    source("http://bioconductor.org/biocLite.R")
    biocLite("ath1121501.db")
```

With the data on the system, start to explore with the '??package' command.
Some interesting information for exploring R data can be found 
[here](http://www.win-vector.com/blog/2009/09/survive-r/).

```R
    ??ath1121501

      ath1121501.db::ath1121501GENENAME
                        Map between Manufacturer IDs and Genes
      ath1121501.db::ath1121501GO
                        Map between Manufacturer IDs and Gene Ontology
                        (GO)
      ...
```

We are interested in finding mapped gene names. 
Inspect an entry

```R
    ?ath1121501.db::ath1121501GENENAME
```

Load the element, and explore using class, names, attributes and str

```R
    library(ath1121501.db)
    x <- ath1121501.db::ath1121501GENENAME
    dim(x)
    [1] 30166     2
    class(x)
      [1] "ProbeAnnDbBimap"
      attr(,"package")
      [1] "AnnotationDbi"
    names(x)
    attributes(x)
      $Lkeys
      [1] NA

      $Rkeys
      [1] NA

      $ifnotfound
      list()

      $datacache
      <environment: 0xa913568>

      $objName
      [1] "GENENAME"

      $objTarget
      [1] "chip ath1121501"

      $class
      [1] "ProbeAnnDbBimap"
      attr(,"package")
      [1] "AnnotationDbi"
      Slot "tablename":
      [1] "gene_info"

      Slot "Lcolname":
      [1] "_id"

      Slot "tagname":
      [1] NA

      Slot "Rcolname":
      [1] "gene_name"

      Slot "Rattribnames":
      character(0)

      Slot "Rattrib_join":
      [1] NA

      Slot "filter":
      [1] "1"

    str(x)
      Formal class 'ProbeAnnDbBimap' [package "AnnotationDbi"] with 8 slots
        ..@ L2Rchain  :List of 3
        .. ..$ :Formal class 'L2Rlink' [package "AnnotationDbi"] with 8 slots
        .. .. .. ..@ tablename   : chr "probes"
        .. .. .. ..@ Lcolname    : chr "probe_id"
        .. .. .. ..@ tagname     : chr NA
        .. .. .. ..@ Rcolname    : chr "gene_id"
        .. .. .. ..@ Rattribnames: chr(0) 
        .. .. .. ..@ Rattrib_join: chr NA
        .. .. .. ..@ filter      : chr "{is_multiple}='0'"
        .. .. .. ..@ altDB       : chr(0) 
        .. ..$ :Formal class 'L2Rlink' [package "AnnotationDbi"] with 8 slots
        .. .. .. ..@ tablename   : chr "genes"
        .. .. .. ..@ Rattrib_join: chr NA
        .. .. .. ..@ filter      : chr "1"
        .. .. .. ..@ altDB       : chr "org.At.tair"
        .. ..$ :Formal class 'L2Rlink' [package "AnnotationDbi"] with 8 slots
        .. .. .. ..@ tablename   : chr "gene_info"
        .. .. .. ..@ Lcolname    : chr "_id"
        .. .. .. ..@ tagname     : chr NA
        .. .. .. ..@ Rcolname    : chr "gene_name"
        .. .. .. ..@ Rattribnames: chr(0) 
        .. .. .. ..@ Rattrib_join: chr NA
        .. .. .. ..@ filter      : chr "1"
        .. .. .. ..@ altDB       : chr "org.At.tair"
        ..@ direction : int 1
        ..@ Lkeys     : chr NA
        ..@ Rkeys     : chr NA
        ..@ ifnotfound: list()
        ..@ datacache :<environment: 0xa913568> 
        ..@ objName   : chr "GENENAME"
        ..@ objTarget : chr "chip ath1121501"

```

Sometimes it is useful to further explore by unclass, which removes print() and summary() methods

```R
    # was model = unclass(ath1121501GENENAME)
    model = unclass(ath1121501.db::ath1121501GENENAME)

    str(model)
      Formal class 'S4' [package ""] with 0 slots
      list()

    # print model
    model
      <S4 Type Object>
      attr(,"L2Rchain")
      attr(,"L2Rchain")[[1]]
      An object of class "L2Rlink"
      Slot "tablename":
      [1] "probes"
      (...)
      attr(,"objName")
      [1] "GENENAME"
      attr(,"objTarget")
      [1] "chip ath1121501"
```

We noticed the model has keys. Print the keys

```R
    keys(x) 
      [22797] "AFFX-r2-Bs-phe-M_at"     "AFFX-r2-Bs-thr-3_s_at"  
      [22799] "AFFX-r2-Bs-thr-5_s_at"   "AFFX-r2-Bs-thr-M_s_at"  
      [22801] "AFFX-r2-Ec-bioB-3_at"    "AFFX-r2-Ec-bioB-5_at"   
      [22803] "AFFX-r2-Ec-bioB-M_at"    "AFFX-r2-Ec-bioC-3_at"   
      [22805] "AFFX-r2-Ec-bioC-5_at"    "AFFX-r2-Ec-bioD-3_at"   
      [22807] "AFFX-r2-Ec-bioD-5_at"    "AFFX-r2-P1-cre-3_at"    
```

Locating methods for a class, does not help here

```R
    methods(x) 
```

According to the manual, we can find the keys that have been mapped to IDs with

```R
    mapped_probes <- mappedkeys(x)      
    xx <- as.list(x[mapped_probes])
    if(length(xx) > 0) {
      # Get the GENENAME for the first five probes
      xx[1:5]
      # Get the first one
      xx[[1]]
    }

    > xx[1]
    $`244901_at`
      [1] "encodes a plant b subunit of mitochondrial ATP synthase based on structural similarity and the presence in the F(0) complex."
    > xx[[1]]
      [1] "encodes a plant b subunit of mitochondrial ATP synthase based on structural similarity and the presence in the F(0) complex."
    
```

Convert key to a useful ID

```R
    symbols = ath1121501.db::ath1121501SYMBOL
    dim(symbols)
    [1] 17186     2
    # Get the probe identifiers that are mapped to a gene symbol
    mapped_probes <- mappedkeys(symbols)
    # Convert to a list
    xx <- as.list(symbols[mapped_probes])
      if(length(xx) > 0) {
      # Get the SYMBOL for the first five probes
      xx[1:5]
      # Get the first one
      xx[[1]]
    } 
    [1] "ORF25"
    
    > xx[200]
    $`245228_at`
    [1] "COBL2"
```

Multiple IDs are possible per probe, and not all probes have an ID.
These IDs can be used with Entrez, and probably Bio2RDF.  Similarly you can fetch
pubmed IDs.

In the case of Arabidobsis, the gene symbols are availabel in the TAIR files, e.g.

```sh
  grep COBL2 *
    gene_aliases.20120207.txt:AT3G29810     COBL2   COBRA-like protein 2 precursor
    TAIR10_cdna_20101214_updated:>AT3G29810.1 | Symbols: COBL2 | COBRA-like protein 2 precursor | chr3:11728113-11730239 FORWARD LENGTH=1506
    TAIR10_cds_20101214_updated:>AT3G29810.1 | Symbols: COBL2 | COBRA-like protein 2 precursor | chr3:11728212-11730158 FORWARD LENGTH=1326
```

Note that many entries have no symbol, and some entries have multiple symbols, e.g.

```sh
    >AT1G15960.1 | Symbols: NRAMP6, ATNRAMP6 | NRAMP metal ion transporter 6 | chr1:5482202-5485066 REVERSE LENGTH=1584
    >AT1G14980.1 | Symbols: CPN10 | chaperonin 10 | chr1:5165930-5166654 REVERSE LENGTH=297
    >AT1G14910.1 | Symbols:  | ENTH/ANTH/VHS superfamily protein | chr1:5139928-5143571 REVERSE LENGTH=2079
```

So, one route to getting from Affymetrix probes to sequence information, is to
use the SYMBOLS information. Perhaps a better way is to use the AGI locus id, which is the
first identifier styled T1G15960.1 (the dot 1 is splicing variant 1 - out of 1).

```R
    agi = ath1121501.db::ath1121501ACCNUM
    dim(agi)
    [1] 21148     2
    # Get the probe identifiers that are mapped to an AGI
    mapped_probes <- mappedkeys(agi)
    # Convert to a list
    xx <- as.list(agi[mapped_probes])
    if(length(xx) > 0) {
      # Get the SYMBOL for the first five probes
      xx[1:5]
      # Get the first one
      xx[[1]]
    } 
    [1] "ATMG00640"
    xx[200]
    $`245129_at`
      [1] "AT2G45350"
```

At least we get more mappings this way (21148)!

Output to table

```R
  sink("ath1121501-probe2agi.tab")
  cat("affy\tagi\n")
  for (n in names(xx)) { cat(n,"\t"); cat(xx[[n]],sep="\n") }
  sink()
    affy    agi
    244901_at       ATMG00640
    244902_at       ATMG00650
    244903_at       ATMG00660
    244904_at       ATMG00670
    244905_at       ATMG00680
    244906_at       ATMG00690
    244907_at       ATMG00710
    244908_at       ATMG00720
    (...)
```

We set out to match gene sequences against each probe. Download the TAIR CDS fasta file, which
contains records, such as

```
    >AT1G51370.2 | Symbols:  | F-box/RNI-like/FBD-like domains-containing protein | chr1:19045615-19046748 FORWARD LENGTH=1041
    ATGGTGGGTGGCAAGAAGAAAACCAAGATATGTGACAAAGTGTCACATGAGGAAGATAGGATAAGCCAGTTACCGGAACC
    TTTGATATCTGAAATACTTTTTCATCTTTCTACCAAGGACTCTGTCAGAACAAGCGCTTTGTCTACCAAATGGAGATATC
    TTTGGCAATCGGTTCCTGGATTGGACTTAGACCCCTACGCATCCTCAAATACCAATACAATTGTGAGTTTTGTTGAAAGT
```

Also turn this into a table using my [bigbio](https://github.com/pjotrp/bigbio) biogem, with a 
short script:

```ruby
  #! /usr/bin/env ruby

  require 'bigbio'

  i = 1
  print "num\tagi\tseq\n"
  FastaReader.new(ARGV[0]).each do | rec |
    if rec.id =~ /(AT\w+)\.1$/   # only take the first splice variant, if there are more
      print i,"\t",$1,"\t",rec.seq,"\n"
      i += 1
    end
  end
```

writes

```sh
num     agi       seq
1       AT1G51370       ATGGTGGGTGGCAAGAAGAAAACCAAGATATGTGACAAAGTGTCAC...
2       AT1G50920       ATGGTTCAATATAATTTCAAGAGGATCACAGTTGTTCCCAATGGGA...
(etc)
```

Both tables can be turned into RDF using bioruby-table, e.g.

```sh
bio-table --format rdf ath1121501-probe2agi.tab > ath1121501-probe2agi.rdf
```

And sunk into a triple store for matching! 

Note: for quick matching you could also have used the bio-table --merge command.

