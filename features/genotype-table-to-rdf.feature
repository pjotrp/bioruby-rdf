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
    Then I should turn it into RDF so it contains
        """
        """
    When I store the RDF in a triple store
    And query the genotype of strain AXB4 at marker rs8237062 to be BB with 
        """
        SELECT genotype WHERE { ?s ?p ?o } 
        """
    And query the genotype of strain AXB1 to be "AA,AA,AA,AA" with
        """
        SELECT genotype WHERE { ?s ?p ?o } 
        """
    And query marker rs8237062 to be at location 87.334 of chromosome 1 with
        """
        SELECT Chromosome,Pos WHERE { ?s ?p ?o } 
        """


