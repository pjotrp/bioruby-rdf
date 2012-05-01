Feature: Parse GSEA results
  To get the enrichment values in a Broad Institute GSEA result file
  we need to parse the tab delimited results file. An example is

GS      SIZE    SOURCE  ES      NES     NOM p-val       FDR q-val       FWER p-val      Tag \%  Gene \% Signal  FDR (median)    glob.p.val
BIOCARTA_RACCYCD_PATHWAY        25      http://www.broadinstitute.org/gsea/msigdb/cards/BIOCARTA_RACCYCD_PATHWAY.html   0.55588 1.7947  0.004149        1       0.647   0.44    0.198   0.354   1       0.633
REACTOME_MRNA_3_END_PROCESSING  31      http://www.broadinstitute.org/gsea/msigdb/cards/REACTOME_MRNA_3_END_PROCESSING.html     0.6396  1.7613  0       1       0.752   0.613   0.242   0.466   1       0.579
(...)


  Scenario: Parse one line in a Broad GSEA results file
    Given I have a Broad GSEA results file which contains the line
    """
BIOCARTA_RACCYCD_PATHWAY        25      http://www.broadinstitute.org/gsea/msigdb/cards/BIOCARTA_RACCYCD_PATHWAY.html   0.55588 1.7947  0.004149        1       0.647   0.44    0.198   0.354   1       0.633
    """    
    Then I should be able to the name of the geneset BIOCARTA_RACCYCD_PATHWAY
    And I should be able to fetch all values as a list
    And I should be able to fetch all other values (lazily), where
    And I should be able to fetch the source
    And ES is 0.55588
    And NES is 1.7947
    And p-value is 0.004149
    And FDR is 1
    And global p-value is 0.633
    And Median FDR is 1
