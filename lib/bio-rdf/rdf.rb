module BioRdf


  module RDF

    def RDF::valid_uri? uri
      uri =~ /^([!#$&-;=?_a-z~]|%[0-9a-f]{2})+$/i
    end

  end

  module Turtle

    def Turtle::identifier(id)
      raise "Illegal identifier #{id}" if id != Turtle::mangle_identifier(id)
    end

    # Replace letters/symbols that are not allowed in a Turtle identifier
    # (short hand URI). This should be the definite mangler and replace the 
    # ones in bioruby-table and bio-exominer.

    def Turtle::mangle_identifier(s)
      id = s.strip.gsub(/[^[:print:]]/, '').gsub(/[#)(,]/,"").gsub(/[%]/,"perc").gsub(/(\s|\.|\$|\/|\\)+/,"_")
      # id = URI::escape(id)
      id = id.gsub(/\|/,'_')
      id = id.gsub(/\-|:/,'_')
      if id != s 
        logger = Bio::Log::LoggerPlus['bio-rdf']
        $stderr.print "\nWARNING: Changed identifier <#{s}> to <#{id}>"
      end
      if not RDF::valid_uri?(id)
        raise "Invalid URI after mangling <#{s}> to <#{id}>!"
      end
      valid_id = if id =~ /^\d/
                   'r' + id
                 else
                   id
                 end
      valid_id  # we certainly hope so!
    end
  end
end
