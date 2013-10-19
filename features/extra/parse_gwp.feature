@gwp

Feature: Parse GWP files

  GWP generates a range of files which we parse and turn into RDF

  @gwp1
  Scenario: Parse digest 
    Given I have a digest file with name 'Ce_CDS' and contains
    """
cluster00396/results7*.txt
cluster00399/results7-8.txt M7-8  -1280.1  -1277.4      5.3
cluster00400/results7-8.txt M7-8   -857.0   -850.8     12.4 ++   6 sites (206 AA)
    """    
    Then I should fetch the cluster names 'cluster00399' and 'cluster00400'
    Then for cluster 400
    Then I should be able fetch the cluster :Ce_CDS_cluster00400
    And I should be able to fetch the model 'M7-8'
    And I should be able to fetch the lnL '12.4'
    And I should be able to fetch sequence size as 206
    And I should be able to assert it is positively selected for 6 sites
    And I should be able to output RDF
      """
:Ce_CDS_cluster00400 rdf:label "Ce_CDS_cluster00400" .
:Ce_CDS_cluster00400 :clusterid :Ce_CDS_cluster00400 .
:Ce_CDS_cluster00400 :model "M78" .
:Ce_CDS_cluster00400 :species "Ce" .
:Ce_CDS_cluster00400 :source "CDS" .
:Ce_CDS_cluster00400 :lnL 12.4 .
:Ce_CDS_cluster00400 :is_pos_sel true .
:Ce_CDS_cluster00400 :sites 6 .
:Ce_CDS_cluster00400 :seq_size 206 .

"""
    And I should be able to output RDF without pos. sel.
"""
:Ce_CDS_cluster00399 rdf:label "Ce_CDS_cluster00399" .
:Ce_CDS_cluster00399 :clusterid :Ce_CDS_cluster00399 .
:Ce_CDS_cluster00399 :model "M78" .
:Ce_CDS_cluster00399 :species "Ce" .
:Ce_CDS_cluster00399 :source "CDS" .
:Ce_CDS_cluster00399 :lnL 5.3 .
:Ce_CDS_cluster00399 :is_pos_sel false .

"""

  @gwp2
  Scenario: Parse BLAST results
    
    BLAST XML results are turned into a textual format

    Given I have a textual BLAST result with name 'Ce_CDS' in 'cluster00400'  which contains
    """
Caenorhabditis elegans\tNP_001251447\tProtein CDC-26, isoform c  > Protein CDC-26, isoform cgi|392887062|ref|NP_001251447.1\t\t1.76535e-89
Caenorhabditis elegans\tNP_001251447\tProtein CDC-26, isoform c  > Protein CDC-26, isoform cgi|392887062|ref|NP_001251447.1| [Ce_DNA] Parse\t\t1.76535e-89
Mi_CDS\tMinc19052c\tcluster00230\tlcl|Minc19052c\t3.75732e-28
    """
    Then I should be able fetch the Species name 'Ce'
    Then I should be able fetch the gene name 'NP_001251447'
    Then I should be able fetch the BLAST cluster :Ce_CDS_cluster00400
    Then I should be able fetch the description 'Protein CDC-262'
    Then I should be able fetch the E-value 1.76535e-89
    And I should be able to output BLAST RDF
      """
:Ce_CDS_cluster00400_NP_001251447 rdf:label "Ce_CDS_cluster00400_NP_001251447" .
:Ce_CDS_cluster00400_NP_001251447 :cluster :Ce_CDS_cluster00400 .
:Ce_CDS_cluster00400_NP_001251447 a :blast_match .
:Ce_CDS_cluster00400_NP_001251447 :homolog_species "Ce" .
:Ce_CDS_cluster00400_NP_001251447 :homolog_species_full "Caenorhabditis elegans" .
:Ce_CDS_cluster00400_NP_001251447 :homolog_gene "NP_001251447" .
:Ce_CDS_cluster00400_NP_001251447 :descr "Protein CDC-26, isoform c  > Protein CDC-26, isoform cgi|392887062|ref|NP_001251447.1" .
:Ce_CDS_cluster00400_NP_001251447 :e_value 1.76535e-89 .

"""
    And I should be able to output BLAST RDF from description
      """
:Ce_CDS_cluster00400_NP_001251447 rdf:label "Ce_CDS_cluster00400_NP_001251447" .
:Ce_CDS_cluster00400_NP_001251447 :cluster :Ce_CDS_cluster00400 .
:Ce_CDS_cluster00400_NP_001251447 a :blast_match .
:Ce_CDS_cluster00400_NP_001251447 :homolog_species "Ce" .
:Ce_CDS_cluster00400_NP_001251447 :homolog_species_full "[Ce_DNA]" .
:Ce_CDS_cluster00400_NP_001251447 :homolog_gene "NP_001251447" .
:Ce_CDS_cluster00400_NP_001251447 :descr "Protein CDC-26, isoform c  > Protein CDC-26, isoform cgi|392887062|ref|NP_001251447.1| [Ce_DNA] Parse" .
:Ce_CDS_cluster00400_NP_001251447 :e_value 1.76535e-89 .
:Ce_CDS_cluster00400_NP_001251447 :homolog_source "DNA" .

"""

    And I should be able to output Mi CDS BLAST RDF
      """
:Ce_CDS_cluster00400_Minc19052c rdf:label "Ce_CDS_cluster00400_Minc19052c" .
:Ce_CDS_cluster00400_Minc19052c :cluster :Ce_CDS_cluster00400 .
:Ce_CDS_cluster00400_Minc19052c a :blast_match .
:Ce_CDS_cluster00400_Minc19052c :homolog_species "Mi" .
:Ce_CDS_cluster00400_Minc19052c :homolog_species_full "Mi_CDS" .
:Ce_CDS_cluster00400_Minc19052c :homolog_gene "Minc19052c" .
:Ce_CDS_cluster00400_Minc19052c :homolog_cluster :Mi_CDS_cluster00230 .
:Ce_CDS_cluster00400_Minc19052c :e_value 3.75732e-28 .
:Ce_CDS_cluster00400_Minc19052c :homolog_source "CDS" .

"""

