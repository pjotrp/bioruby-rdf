module BioRdf
  module Extra
    module Parsers
      def Parsers::handle_options 
        $stderr.print "Entering extra mode\n"
        p ARGV
        options = OpenStruct.new()
        
        opts = OptionParser.new() do |o|
          o.banner = "Usage: #{File.basename($0)} extra gwp [options] path(s)"

          o.on_tail("-h", "--help", "Show help and examples") {
            print(opts)
            print <<OPTIONS

Examples:

    bio-rdf extra gwp --type digest --name Ce_CDS test/data/parsers/extra/gwp/digest.txt 
OPTIONS
            exit()
          }
          o.on("--name name",String,"Set name") do |n|
            options.name = n
          end
          o.on("--type digest",[:digest], "Parse digest") do |s|
            if s == :digest
              # ./bin/bio-rdf extra gwp --type digest --name Ce_CDS test/data/parsers/extra/gwp/digest.txt
              options.digest = true 
              require 'bio-rdf/extra/gwp'
              options.func = GWP::Digest.method(:parse)
            end
          end

          # o.on("--tabulate","Output tab delimited table") do
          #   options.output = :tabulate
          # end

        end
        opts.parse!(ARGV)
        command = ARGV.shift
        p options
        ARGV.each do | fn |
          File.open(fn).each do | line |
            rec = options.func.call(options.name,line)
            rec.each { | k,v |
              print BioRdf::Writers::Turtle::Digest::to_rdf(v)
              print "\n"
            }
          end
        end
      end

    end
  end
end

