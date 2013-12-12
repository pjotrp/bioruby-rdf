Feature: Parse BED format

  @bed
  Scenario: Parse a BED file

    Given a textual BED file containing
"""
track name=pairedReads description="Clone Paired Reads" useScore=1
chr22 1000 5000 cloneA 960 + 1000 5000 0 2 567,488, 0,3512
chr22 2000 6000 cloneB 900 - 2000 6000 0 2 433,399, 0,3601
"""
    Then using the description I should get RDF containing
"""
:bed_ch22_1000_5000 :chr "22" .
:bed_ch22_1000_5000 :pos_start 1000 .
:bed_ch22_1000_5000 :pos_end 5000 .
:bed_ch22_1000_5000 :name "cloneA" .
:bed_ch22_1000_5000 :score 960 .
:bed_ch22_1000_5000 :strand "+" .
:bed_ch22_1000_5000 :thick_start 1000 .
:bed_ch22_1000_5000 :thick_end 5000 .
:bed_ch22_1000_5000 :rgb "0" .
:bed_ch22_1000_5000 :count 2 .
:bed_ch22_1000_5000 :block_sizes "567,488," .
:bed_ch22_1000_5000 :block_starts "0,3512" .
:bed_ch22_1000_5000 rdf:label "bed_ch22_1000_5000" .
:bed_ch22_1000_5000 :identifier "id1" .
:bed_ch22_1000_5000 :type :bed .
"""
