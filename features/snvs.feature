Feature: Parse single nucleotide variants (SNVs)

  Variant callers, such as varscan2, produce lists of nucleotide 
  variations. Here we parse lists and turn them into RDF.

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
:varscan2_id1_ch17_3655022 :consensus_genotype_call_in_normal "C" .
:varscan2_id1_ch17_3655022 :ref_reads_in_tumor 26 .
:varscan2_id1_ch17_3655022 :variant_reads_in_tumor 7 .
:varscan2_id1_ch17_3655022 :variant_frequency_tumor 21.21 .
:varscan2_id1_ch17_3655022 :somatic_status "Y" .
:varscan2_id1_ch17_3655022 :type :somatic .
:varscan2_id1_ch17_3655022 :p_value_germline 1.0 .
:varscan2_id1_ch17_3655022 :p_value_somatic 1.8507588525888905e-05 .
:varscan2_id1_ch17_3655022 :tumor_reads1_plus 26 .
:varscan2_id1_ch17_3655022 :tumor_reads1_minus 0 .
:varscan2_id1_ch17_3655022 :tumor_reads2_plus 7 .
:varscan2_id1_ch17_3655022 :tumor_reads2_minus 0 .
:varscan2_id1_ch17_3655022 :normal_reads1_plus 93 .
:varscan2_id1_ch17_3655022 :normal_reads1_minus 19 .
:varscan2_id1_ch17_3655022 :normal_reads2_plus 0 .
:varscan2_id1_ch17_3655022 :normal_reads2_minus 0 .
:varscan2_id1_ch17_3655022 rdf:label "varscan2_id1_ch17_3655022" .
:varscan2_id1_ch17_3655022 :identifier "id1" .
:varscan2_id1_ch17_3655022 :caller :varscan2 .
"""

  Scenario: Parse the output of somatic-sniper

    Given a textual output from somaticsniper which contains
"""
17 63533065 C Y C 45  80  95  37  42  0 37  12  5 51  37  6 60  37  6 59  37 5 0 0 0
"""
    Then using the description in http://gmt.genome.wustl.edu/somatic-sniper/1.0.2/documentation.html I should get RDF containing
"""
:somaticsniper_id1_ch17_63533065 :chr 17 .
:somaticsniper_id1_ch17_63533065 :pos 63533065 .
:somaticsniper_id1_ch17_63533065 :ref "C" .
:somaticsniper_id1_ch17_63533065 :variant "Y" .
:somaticsniper_id1_ch17_63533065 :normal "C" .
:somaticsniper_id1_ch17_63533065 :somatic_score 45 .
:somaticsniper_id1_ch17_63533065 :tumor_consensus_quality 80 .
:somaticsniper_id1_ch17_63533065 :tumor_variant_quality 95 .
:somaticsniper_id1_ch17_63533065 :tumor_mean_mapping_quality 37 .
:somaticsniper_id1_ch17_63533065 :normal_consensus_quality 42 .
:somaticsniper_id1_ch17_63533065 :normal_variant_quality 0 .
:somaticsniper_id1_ch17_63533065 :normal_mean_mapping_quality 37 .
:somaticsniper_id1_ch17_63533065 :depth_in_tumor 12 .
:somaticsniper_id1_ch17_63533065 :depth_in_normal 5 .
:somaticsniper_id1_ch17_63533065 :base_quality_reads_supporting_ref_in_tumor 51 .
:somaticsniper_id1_ch17_63533065 :mapping_quality_reads_supporting_ref_in_tumor 37 .
:somaticsniper_id1_ch17_63533065 :depth_of_reads_supporting_ref_in_tumor 6 .
:somaticsniper_id1_ch17_63533065 :base_quality_reads_supporting_variant_in_tumor 60 .
:somaticsniper_id1_ch17_63533065 :mapping_quality_reads_supporting_variant_in_tumor 37 .
:somaticsniper_id1_ch17_63533065 :depth_of_reads_supporting_variant_in_tumor 6 .
:somaticsniper_id1_ch17_63533065 :base_quality_reads_supporting_ref_in_normal 59 .
:somaticsniper_id1_ch17_63533065 :mapping_quality_reads_supporting_ref_in_normal 37 .
:somaticsniper_id1_ch17_63533065 :depth_of_reads_supporting_ref_in_normal 5 .
:somaticsniper_id1_ch17_63533065 :base_quality_reads_supporting_variant_in_normal 0 .
:somaticsniper_id1_ch17_63533065 :mapping_quality_reads_supporting_variant_in_normal 0 .
:somaticsniper_id1_ch17_63533065 :depth_of_reads_supporting_variant_in_normal 0 .
:somaticsniper_id1_ch17_63533065 rdf:label "somaticsniper_id1_ch17_63533065" .
:somaticsniper_id1_ch17_63533065 :identifier "id1" .
:somaticsniper_id1_ch17_63533065 :caller :somaticsniper .
:somaticsniper_id1_ch17_63533065 :type :somatic .
"""


  Scenario: Parse the output of bamannotate

    Given a textual output from bamannotate which contains
"""
19  55798657  55798658  A/T_dom_BRSK1_pv:31,0
"""
    Then I should get bamannotate RDF containing
"""
:somaticsniper_id1_ch17_63533065 :chr 17 .
"""
    Given a textual output from bamannotate which contains
"""
19  55798658  1 A/T K103M 15.50 405.50  BRSK1 snv 0 1 533 278 0 31  0 0 0 86  0 0 100 69  ,=470|.=63  ,=172|.=20|t=8 6 NA  aAg/aTg novel missense_variant  ENST00000585418.1:c.308A>T  NA  ENSP00000467357.1:p.Lys103Met 0.96  probably d amaging 0.02  deleterious 4.290 3.735 95  NA  NA  ENSG00000160469 ENST00000585418 ENSP00000467357 19_60490470 REFSEQ _P= | UNIPROT=Q8TDC3 | REFSEQ_T= | GENE_DESC=BR serine/threonine kinase 1 [Source:HGNC Symbol;Acc:18994] | MIM_DESC= | UNIGENE=Hs.182081 | MIM_ID=
"""
    Then I should get bamannotate RDF containing
"""
:somaticsniper_id1_ch17_63533065 :chr 17 .
"""
