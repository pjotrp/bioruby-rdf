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
    And I should be able to fetch the model 'M7-8'
    And I should be able to fetch the lnL '12.4'
    And I should be able to fetch sequence size as 206
    And I should be able to assert it is positively selected for 6 sites
    And I should be able to output RDF
      """
:Ce_CDS_cluster00400 rdf:label "Ce_CDS_cluster00400" ,
    a :cds ,
    a :family ,
    :model :M78 ,
    :lnL 12.4 ,
    :is_pos_sel true ,
    :sites 6 ,
    :seq_size 206 ,
    :species "Ce" .

"""

  @gwp2
  Scenario: Parse BLAST results
    
    BLAST XML results are turned into a textual format

    Given I have a textual BLAST result with name 'Ce_CDS' in 'cluster00400'  which contains
    """
Caenorhabditis elegans\tNP_001251447\tProtein CDC-26, isoform c  > Protein CDC-26, isoform c\tgi|392887062|ref|NP_001251447.1|\t1.76535e-89
    """
    Then I should be able fetch the Species name 'Caenorhabditis elegans'
    Then I should be able fetch the gene name 'NP_001251447'
    Then I should be able fetch the description 'Protein CDC-262'
    Then I should be able fetch the E-value 1.76535e-89
    And I should be able to output RDF
      """
:Ce_CDS_cluster00400_NP_001251447 rdf:label "NP_001251447" ,
    a :homolog ,
    :family Ce_CDS_cluster00400,
    :model :M78 ,
    :lnL 12.4 ,
    :sites 6 ,
    :seq_size 206 .

"""


