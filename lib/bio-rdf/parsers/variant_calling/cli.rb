module BioRdf
  module Parsers
    module Variant
      module Cli

        require 'bio-logger'
        include Bio::Log

        def Cli::handle_options 
          log = LoggerPlus.new 'variant'
          options = OpenStruct.new()
          
          opts = OptionParser.new() do |o|
            o.banner = "Usage: #{File.basename($0)} variant [options] filename(s)"
  
            o.on("--caller type",[:bamannotate],"Use caller [varscan2|somaticsniper|bamannotate]") { | type |
              require 'bio-rdf/parsers/variant_calling/bamannotate'
              options.caller = type
            }

            o.on("--regex expr",String,"Make id from filename") { |expr|
              options.regex = expr
            }

            o.on_tail("-h", "--help", "Show help and examples") {
              print(o)
              exit()
            }

          end
          opts.parse!(ARGV)
          if ARGV[0]
            ARGV.each do | fn |
              count = 0
              id = fn
              if options.regex
                # p fn
                # p options.regex
                fn =~ eval(options.regex) 
                id = $1
              end
              File.open(fn).each_line do |s|
                count += 1
                case options.caller
                  when :bamannotate
                    next if count == 1
                    rec = BioRdf::Parsers::BamAnnotate.parse(id,s)
                    rdf = BioRdf::Writers::Turtle::hash_to_rdf(rec)
                    print rdf
                    print "\n"
                  else
                    raise "You should provide a caller"
                end
              end
            end
          else
            raise "you should supply a valid file name!" 
          end
        end

        def Cli::do_parse input, filter, output
          log = LoggerPlus.new 'variant'
          log.level = INFO
          log.outputters = Outputter.stderr
          log.warn("Fetching "+input)
        end
      end
    end
  end
end
