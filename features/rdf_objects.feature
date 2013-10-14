@rdf

Feature: Support RDF objects and validators

  bio-rdf generates valid RDF from other data formats. RDF formats are
  strictly defined by W3C. Here we define helpers for creating valid
  RDF.

  Scenario: Create a RDF string literal

    Given an RDF container
    When I create a string literal
    Then I should escape quotes as in
    | a " double quote  | a \" double quote |
    | a \" double quote | a \" double quote |
    Then I should escape single slashes as in 'a \ slash'
    Then I should escape special characters as defined in http://www.w3.org/TeamSubmission/turtle/

  Scenario: Create a Turtle RDF URI

    Given an RDF container
    When I create a Turtle shorthand URI reference object in the default name space
    Then it should allow identifiers 
    """
    gene1
    """
    Then it should not allow identifiers 
    """
    gene.1
    """
    When a Turtle identifiers contains invalid letters
    Then I have the option to mangle them. First begets second:
      | gene.1            | gene_1         |

