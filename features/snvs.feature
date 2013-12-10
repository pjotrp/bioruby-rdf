Feature: Parse single nucleotide variants (SNVs)

  Variant callers, such as varscan2, produce lists of nucleotide 
  variations. Here we parse lists and turn them into RDF.

  @snv
  Scenario: Parse the output of varscan2's processSomatic module

    Given a textual output from somatic.hc which contains
"""
17 3655022 C T 112 0 0% C 26 7 21.21% Y Somatic 1.0 1.8507588525888905E-5 26 0 7 0 93 19 0 0
"""
    Then using the description in http://varscan.sourceforge.net/somatic-calling.html I should get RDF containing
"""
:varscan2_id1_ch17_3655022 :chr 17 .
:varscan2_id1_ch17_3655022 :pos 3655022 .
:varscan2_id1_ch17_3655022 :ref "C" .
:varscan2_id1_ch17_3655022 :variant "T" .
:varscan2_id1_ch17_3655022 :ref_reads_in_normal 112 .
:varscan2_id1_ch17_3655022 :variant_reads_in_normal 0 .
:varscan2_id1_ch17_3655022 :variant_frequency_normal 0.0 .
:varscan2_id1_ch17_3655022 :normal_gt "C" .
:varscan2_id1_ch17_3655022 :ref_reads_in_tumor 26 .
:varscan2_id1_ch17_3655022 :variant_reads_in_tumor 7 .
:varscan2_id1_ch17_3655022 :variant_frequency_tumor 21.21 .
:varscan2_id1_ch17_3655022 :tumor_gtsomatic_status "Y" .
:varscan2_id1_ch17_3655022 :type :somatic .
:varscan2_id1_ch17_3655022 :p_value_variant 1.0 .
:varscan2_id1_ch17_3655022 :somatic_p_value 1.8507588525888905e-05 .
:varscan2_id1_ch17_3655022 :tumor_reads1_plus 26 .
:varscan2_id1_ch17_3655022 :tumor_reads1_minus 0 .
:varscan2_id1_ch17_3655022 :tumor_reads2_plus 7 .
:varscan2_id1_ch17_3655022 :tumor_reads2_minus 0 .
:varscan2_id1_ch17_3655022 :normal_reads1_plus 93 .
:varscan2_id1_ch17_3655022 :normal_reads1_minus 19 .
:varscan2_id1_ch17_3655022 :normal_reads2_plus 0 .
:varscan2_id1_ch17_3655022 :normal_reads2_minus 0 .
:varscan2_id1_ch17_3655022 rdf:label "varscan2_id1_ch17_3655022" .
:varscan2_id1_ch17_3655022 :caller :varscan2_processSomatic .
"""

