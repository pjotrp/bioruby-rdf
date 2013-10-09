module BioRdf
  module Writers
    module Turtle
      HEADER =<<HEAD
# RDF output by bio-exominer https://github.com/pjotrp/bioruby-exominer
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix hgnc: <http://identifiers.org/hgnc.symbol/> .
@prefix ncbigene: <https://www.google.nl/search?q=ncbi+gene+alias+> .
@prefix : <http://biobeat.org/rdf/exominer/ns#>  .

HEAD
      def Turtle::header
        HEADER
      end

      def Turtle::rdfize attrib
        ':' + attrib[:id] + ' rdf:label "' + attrib[:id] + "\" ," +
        """
a :cds ,
a :family ,
:model :#{attrib[:model]} ,
:lnL #{attrib[:lnL]} ,
:sites #{attrib[:sites]} ,
:seq_size #{attrib[:seq_size]} .
"""


      end
    end
  end
end
