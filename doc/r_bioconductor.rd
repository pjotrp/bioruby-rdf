# R/Bioconductor

[R/Bioconductor](http://www.bioconductor.org/) contains a lot of modules with
annotation data. We would like to get this information into an RDF triple-store.

## Arabidopsis probe information

For example the ath1121501.db package contains Affymetrix
Arabidopsis ATH1 Genome Array annotation data (chip ath1121501).

In R install this package with

```R
    source("http://bioconductor.org/biocLite.R")
    biocLite("ath1121501.db")
```

Now with the data on the system, start to explore with the '??package'
command. Some interesting information can be found on http://www.win-vector.com/blog/2009/09/survive-r/.

```R
    ??ath1121501

      ath1121501.db::ath1121501GENENAME
                        Map between Manufacturer IDs and Genes
      ath1121501.db::ath1121501GO
                        Map between Manufacturer IDs and Gene Ontology
                        (GO)
      ...
```

to inspect an entry

```R
    ?ath1121501.db::ath1121501GENENAME
```

and find the element

```R
    library(ath1121501.db)
    x <- ath1121501GENENAME
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

    model = unclass(ath1121501GENENAME)

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

    keys(x) 
      [22797] "AFFX-r2-Bs-phe-M_at"     "AFFX-r2-Bs-thr-3_s_at"  
      [22799] "AFFX-r2-Bs-thr-5_s_at"   "AFFX-r2-Bs-thr-M_s_at"  
      [22801] "AFFX-r2-Ec-bioB-3_at"    "AFFX-r2-Ec-bioB-5_at"   
      [22803] "AFFX-r2-Ec-bioB-M_at"    "AFFX-r2-Ec-bioC-3_at"   
      [22805] "AFFX-r2-Ec-bioC-5_at"    "AFFX-r2-Ec-bioD-3_at"   
      [22807] "AFFX-r2-Ec-bioD-5_at"    "AFFX-r2-P1-cre-3_at"    
            

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
    
    
    x <- ath1121501SYMBOL
    # Get the probe identifiers that are mapped to a gene symbol
    mapped_probes <- mappedkeys(x)
```
    # Convert to a list
    xx <- as.list(x[mapped_probes])
    if(length(xx) > 0) {
    # Get the SYMBOL for the first five probes
    xx[1:5]
    # Get the first one
    xx[[1]]
    } 

    > xx[200]
    $`245228_at`
    [1] "COBL2"

Multiple IDs are possible.
Which can be used with Entrez, and probably Bio2RDF.  Similarly you can fetch
pubmed IDs.

