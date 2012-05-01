Feature: Parse GSEA cls file
  To get the phenotype class in a Broad Institute GSEA result
  we need to parse the CLS file

  Scenario: Parse CLS file
    Given I have a CLS file which contains
    """
26 2 1
# RS13482013  RS13482013_1
0 0 0 1 1 0 1 0 0 1 0 1 0 1 1 1 0 1 1 1 1 1 0 0 1 0
    """    
    Then I should fetch the phenotype names RS13482013 and RS13482013_1
