Feature: Parse GSEA cls file
  To get the phenotype class in a Broad Institute GSEA result
  we need to parse the CLS file:
  Categorical (e.g tumor vs normal) class file format (*.cls)

  The CLS file format defines phenotype (class or template) labels and
  associates each sample in the expression data with a label. The CLS file
  format uses spaces or tabs to separate the fields.

  Scenario: Parse CLS file
    Given I have a CLS file which contains
    """
26 2 1
# RS13482013  RS13482013_1
0 0 0 1 1 0 1 0 0 1 0 1 0 1 1 1 0 1 1 1 1 1 0 0 1 0
    """    
    Then I should fetch the phenotype names RS13482013 and RS13482013_1
    And I should be able to fetch the classes into an array 
