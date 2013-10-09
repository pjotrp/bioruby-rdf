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
          # o.on("-e filter","--exec filter",String, "Execute filter") do |s|
          #   options.exec = s
          # end

          # o.on("--tabulate","Output tab delimited table") do
          #   options.output = :tabulate
          # end

        end
        opts.parse!(ARGV)
        dir = ARGV[0]
        if dir and File.directory?(dir)
          ARGV.each do | path |
            do_parse(path, options.exec, options.output)
          end
        else
          raise "you should supply a valid directory!" 
        end
      end

    end
  end
end

