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
        res = ':' + attrib[:id] + ' rdf:label "' + attrib[:id] + "\" ,"
        res += 
        """
a :cds ,
a :family ,
:model :#{attrib[:model]} ,
:lnL #{attrib[:lnL]} ,"""
        res += "\n:is_pos_sel #{attrib[:is_pos_sel]} ," if attrib[:is_pos_sel]
        res += "\n:sites #{attrib[:sites]} ," if attrib[:sites] and attrib[:sites]>0
        res += "\n:seq_size #{attrib[:seq_size]} ," if attrib[:seq_size] and attrib[:seq_size] > 0
        res += "\n:species \"#{attrib[:species]}\" .\n"

        res
      end
    end
  end
end
