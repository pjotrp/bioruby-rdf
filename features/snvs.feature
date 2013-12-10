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
:id1_ch17_3655022 :id "id1" .
:id1_ch17_3655022 :type :Somatic .
:id1_ch17_3655022 :ref "C" .
:id1_ch17_3655022 :variant "T" .
:id1_ch17_3655022 :p_value_variant 1.0 .
:id1_ch17_3655022 :somatic_p_value 1.8507588525888905E-5 .
:id1_ch17_3655022 :variant_frequency_in_normal 0.0 .
:id1_ch17_3655022 :variant_frequency_in_tumor 21.21 .
:id1_ch17_3655022 :ref_reads_in_normal 112 .
:id1_ch17_3655022 :variant_reads_in_normal 0 .
:id1_ch17_3655022 :ref_reads_in_tumor 112 .
:id1_ch17_3655022 :variant_reads_in_tumor 0 .
"""

