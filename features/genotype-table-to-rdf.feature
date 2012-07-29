@genotype
Feature: Convert genotype table to RDF

  bio-table can convert data to RDF. A genotype table sets the genotype
  of an indidual at a marker location to either A,B or H(etereozygous).
  We want to store that in RDF so the genotype can be queried.

  Scenario: Read a comma separated genotype table and write RDF
    Given a comma separated table
        """
        Id,Chromosome,Pos,AXB1,AXB2,AXB4,AXB5,AXB6,AXB10,AXB12,AXB13,AXB15,AXB19,AXB23,AXB24,BXA1,BXA2,BXA4,BXA7,BXA8,BXA11,BXA12,BXA13,BXA14,BXA16,BXA24,BXA25,BXA26
        rs13475701,1,0,AA,BB,AA,BB,BB,AA,BB,BB,BB,AA,AA,AA,AA,AA,AA,AA,AA,BB,AA,AA,AA,AA,AA,BB,AA
        rs3654377,1,1.46,AA,BB,AA,BB,BB,AA,BB,BB,BB,AA,AA,AA,AA,AA,AA,BB,AA,BB,AA,AA,AA,AA,AA,BB,AA
        rs8237062,1,87.334,AA,AA,BB,BB,BB,BB,BB,BB,AA,H,BB,AA,AA,AA,AA,BB,BB,BB,BB,AA,BB,BB,AA,AA,BB
        rs3669485,1,2.19,AA,BB,AA,BB,BB,AA,BB,BB,BB,AA,AA,AA,AA,AA,BB,BB,AA,BB,AA,AA,AA,AA,AA,BB,AA
        """
    When I load the genotype table
    Then I should turn it into RDF so it contains for the table header
        """
        :AXB1 rdf:label "AXB1" ; a :colname; :index 3 .
        """
    Then and it contains for the rows
        """
        :rs13475701 rdf:label "rs13475701" ; a :colname ; ; :Id "rs13475701" ; :Chromosome "1" ; :Pos "0" ; :AXB1 "AA" ; :AXB2 "BB" ; :AXB4 "AA" ; :AXB5 "BB" ; :AXB6 "BB" ; :AXB10 "AA" ; :AXB12 "BB" ; :AXB13 "BB" ; :AXB15 "BB" ; :AXB19 "AA" ; :AXB23 "AA" ; :AXB24 "AA" ; :BXA1 "AA" ; :BXA2 "AA" ; :BXA4 "AA" ; :BXA7 "AA" ; :BXA8 "AA" ; :BXA11 "BB" ; :BXA12 "AA" ; :BXA13 "AA" ; :BXA14 "AA" ; :BXA16 "AA" ; :BXA24 "AA" ; :BXA25 "BB" ; :BXA26 "AA" .
        """
    When I store the RDF in a triple store
    And query marker "rs8237062" to be at location "87.334" of chromosome "1" with
        """
SELECT ?marker WHERE { 
  ?marker :Chromosome "1". 
  ?marker :Pos "87.334" 
} LIMIT 1000
        """
    And query the genotype of strain "AXB4" at marker "rs8237062" to be "BB" with 
        """
        SELECT ?genotype WHERE { 
          ?marker :Id "rs8237062".
          ?marker :AXB4 ?genotype.
        } 
        """
    And query the genotype of strain "AXB1" to be "AA,AA,AA,AA" with
        """
        SELECT ?genotype WHERE { 
          ?marker :AXB1 ?genotype.
        } 
        """
    When I add that 'AXB1' is a genotype with
        """
        :AXB1 a :genotype
        :AXB2 a :genotype
        """
    Then I can directly query for the genotypes with
