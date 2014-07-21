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

      module Digest
        def Digest::to_rdf attrib
          Turtle::hash_to_rdf(attrib)
        end
      end

      module Blast
        def Blast::to_rdf attrib
          # convert 
          # {:id=>"Ce_CDS_NP_001251447", :species=>"Ce", :homolog_species=>"Caenorhabditis elegans", :homolog_gene=>"NP_001251447", :descr=>"Protein CDC-26, isoform c  > Protein CDC-26, isoform c", :e_value=>1.76535e-89}
          Turtle::hash_to_rdf(attrib)
        end
      end

      def Turtle::hash_to_rdf(h)
        rdf = ""
        id = h[:id].to_s
        turtle_id = id # BioRdf::Turtle::mangle_identifier(id)
        h.each do | k,v |
          if k != :id
            # Subject (mangled short hand notation)
            if turtle_id !~ /:/
              rdf += ':'+turtle_id + ' '
            else
              rdf += turtle_id + ' '
            end
            # Predicate
            if k.kind_of? String
              rdf += k
            elsif k.kind_of? Symbol
              rdf += ':'+k.to_s
            else
              raise "Unhandled type "+k
            end
            # Object
            if v.kind_of? String
              rdf += ' '+BioRdf::RDF::quoted_stringify_literal(v)
            elsif v.kind_of? Symbol
              if v.to_s =~ /:/
                rdf += ' '+v.to_s
              else
                rdf += ' :'+v.to_s
              end
            else
              # another literal
              rdf += " " + v.to_s 
            end
            rdf += " .\n"
          else
            rdf += ':' if turtle_id !~ /:/
            rdf += turtle_id + ' rdf:label "' + id + "\" .\n"
          end
        end
        rdf
      end

    end
  end
end
