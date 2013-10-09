module BioRdf
  module Extra
    module Parsers
      def Parsers::handle_options 
        options = OpenStruct.new()
        
        opts = OptionParser.new() do |o|
          o.banner = "Usage: #{File.basename($0)} extra gwp [options] path(s)"

          o.on_tail("-h", "--help", "Show help and examples") {
            print(o)
            exit()
          }
          o.on("--type digest",[:digest], "Parse digest") do |s|
            if s == :digest
              options.digest = true 
              require 'bio-rdf/extra/gwp'
              options.func = GWP::Digest.method(:do_parse)
            end
          end

          # o.on("--tabulate","Output tab delimited table") do
          #   options.output = :tabulate
          # end

        end
        opts.parse!(ARGV)
        p options
        ARGV.each do | fn |
          options.func.call(fn)
        end
      end

    end
  end
end

