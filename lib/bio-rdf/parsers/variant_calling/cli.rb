require 'bio-rdf/parsers/variant_calling/varscan2'
require 'bio-rdf/parsers/variant_calling/somaticsniper'
require 'bio-rdf/parsers/variant_calling/bamannotate'

module BioRdf
  module Parsers
    module Variant
      module Cli

        require 'bio-logger'
        include Bio::Log

        USAGE = """

  Example

    With Varscan2 form the ID from the file name using a regular expression:

      bio-rdf variant --id '/(T[^.]+)/' --caller varscan2 T_F3_20130618.pass

    With BamAnnotate form the ID from the file name using a regular expression:

      bio-rdf variant --id '/(T[^.]+)/' --caller bamannotate T_F3_20130618.inheritance.bed
"""

        def Cli::handle_options 
          log = LoggerPlus.new 'variant'
          options = OpenStruct.new()
          
          opts = OptionParser.new() do |o|
            o.banner = "Usage: #{File.basename($0)} variant [options] filename(s)"
  
            o.on("--caller type",[:varscan2,:somaticsniper,:bamannotate],"Use caller [varscan2|somaticsniper|bamannotate]") { | type |
              options.caller = type
            }

            o.on("--id expr",String,"Make id from expr") { |expr|
              options.regex = expr
            }

            o.on_tail("-h", "--help", "Show help and examples") {
              options.show_help = true
              print(o)
            }
          end

          opts.parse!(ARGV)

          if options.show_help
            print USAGE
            exit 0
          end

          if ARGV[0]
            ARGV.each do | fn |
              count = 0
              id = fn
              if options.regex
                fn =~ eval(options.regex) 
                id = $1
              end
              print <<EOH
# Generated by bioruby-rdf
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix : <http://biobeat.org/rdf/ns#>  .

EOH

              File.open(fn).each_line do |s|
                count += 1
                case options.caller
                  when :varscan2
                    rec = BioRdf::Parsers::Varscan2::ProcessSomatic.parse(id,s)
                    rdf = BioRdf::Writers::Turtle::hash_to_rdf(rec)
                    print rdf
                    print "\n"
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
