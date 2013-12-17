Feature: Parse copy number variation output (CNV)

  @cnv
  Scenario: Parse the output of CoDeCZ

    chr  start   end   gene  zscore  affected_regions  total_regions   perc_regions
 sample

    Given a textual output from CoDeCZ which contains
"""
17  37863243  37882912  ERBB2 3.80  25  28  89.29 TUMOR_F3_20131107.bam
"""
    Then I should get CoDeCZ RDF containing
"""
:codecz_TUMOR_F3_20131107_ch17_37863243 :chr "17" .
:codecz_TUMOR_F3_20131107_ch17_37863243 :start 37863243 .
:codecz_TUMOR_F3_20131107_ch17_37863243 :end 37882912 .
:codecz_TUMOR_F3_20131107_ch17_37863243 :gene "ERBB2" .
:codecz_TUMOR_F3_20131107_ch17_37863243 :z_score 3.8 .
:codecz_TUMOR_F3_20131107_ch17_37863243 :affected_regions 25 .
:codecz_TUMOR_F3_20131107_ch17_37863243 :total_regions 28 .
:codecz_TUMOR_F3_20131107_ch17_37863243 :perc_regions 89.29 .
:codecz_TUMOR_F3_20131107_ch17_37863243 :sample "TUMOR_F3_20131107" .
:codecz_TUMOR_F3_20131107_ch17_37863243 rdf:label "codecz_TUMOR_F3_20131107_ch17_37863243" .
:codecz_TUMOR_F3_20131107_ch17_37863243 :caller :codecz .
"""

