module BioRdf
  module Extra
    module Parsers
      def Parsers::handle_options 
        $stderr.print "Entering extra mode\n"
        # p ARGV
        options = OpenStruct.new()
        
        opts = OptionParser.new() do |o|
          o.banner = "Usage: #{File.basename($0)} extra gwp [options] path(s)"

          o.on_tail("-h", "--help", "Show help and examples") {
            print(opts)
            print <<OPTIONS

Examples:

    bio-rdf extra gwp --type digest --name Ce_CDS test/data/parsers/extra/gwp/digest.txt 
    bio-rdf extra gwp --type blast --name Ce_CDS test/data/parsers/extra/gwp/digest.txt 
OPTIONS
            exit()
          }
          o.on("--name name",String,"Set name") do |n|
            options.name = n
          end
          o.on("--cluster cluster",String,"Set cluster name") do |n|
            options.cluster = n
          end
          o.on("--type digest",[:digest,:blast], "Parse digest") do |type|
            require 'bio-rdf/extra/gwp'
            options.type = type
            case type 
              when :digest
                options.func   = GWP::Digest.method(:parse)
                options.to_rdf = BioRdf::Writers::Turtle::Digest.method(:to_rdf)
              when :blast
                options.func   = GWP::Blast.method(:parse)
                options.to_rdf = BioRdf::Writers::Turtle::Blast.method(:to_rdf)
            end
          end

          # o.on("--tabulate","Output tab delimited table") do
          #   options.output = :tabulate
          # end

        end
        opts.parse!(ARGV)
        command = ARGV.shift
        # p options
        print <<HEADER
# RDF output by bio-rdf https://github.com/pjotrp/bioruby-rdf
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix hgnc: <http://identifiers.org/hgnc.symbol/> .
@prefix ncbigene: <https://www.google.nl/search?q=ncbi+gene+alias+> .
@prefix : <http://biobeat.org/rdf/ns#>  .
HEADER
        
        ARGV.each do | fn |
          File.open(fn).each do | line |
            rec = options.func.call(options.name,options.cluster,line)
            if rec.kind_of? Hash  # ugh, FIXME
              rec.each { | k,v |
                print options.to_rdf.call(v)
                print "\n"
              }
            else
              rec.each { | r |
                print options.to_rdf.call(r)
                print "\n"
              }
            end
          end
        end
      end

    end
  end
end

