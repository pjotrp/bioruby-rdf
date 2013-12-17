Feature: Parse copy number variation output (CNV)

  Scenario: Parse the output of CoDeCZ

    chr  start   end   gene  zscore  affected_regions  total_regions   perc_regions
 sample

    Given a textual output from CoDeCZ which contains
"""
17  37863243  37882912  ERBB2 3.80  25  28  89.29 TUMOR_F3_20131107.bam
"""
    Then I should get CoDeCZ RDF containing
"""
:varscan2_id1_ch17_3655022 :chr "17" .
"""

