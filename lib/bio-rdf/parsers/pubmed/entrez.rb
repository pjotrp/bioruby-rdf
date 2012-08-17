module BioRdf
  module Parsers
    module PubMed

      module Parser

        require 'bio-logger'
        include Bio::Log

        def Parser::handle_options 
          log = LoggerPlus.new 'gsea'
          options = OpenStruct.new()
          
          opts = OptionParser.new() do |o|
            o.banner = "Usage: #{File.basename($0)} pubmed [options] --search string"

            o.on_tail("-h", "--help", "Show help and examples") {
              print(o)
              exit()
            }
            o.on("--tabulate","Output tab delimited table (default)") do
              options.output = :tabulate
            end
            o.on("--search query",String,"Search query") do |query|
              options.search = query
            end

          end
          opts.parse!(ARGV)
          p options
        end

        def Parser::do_parse input, filter, output
          log = LoggerPlus.new 'gsea'
          log.level = INFO
          log.outputters = Outputter.stderr
          log.warn("Fetching "+input)
          print "Marker\tGenotype\tGS\tSIZE\tSOURCE\tES\tNES\tNOM p-val\tFDR q-val\tFWER p-val\tTag \%\tGene \%\tSignal\tFDR (median)\tglob.p.val\n"
          Dir.foreach(input) do |entry| # two step search, because of many dirs
            next if entry == '.' or entry == '..'
            log.info("Parsing directory "+entry)
            clsfilename = File.join(input,entry,"*cls")
            clsfilename = Dir.glob(clsfilename)
            raise "We need one cls file: #{clsfilename}" if clsfilename.size != 1
            clsfilename = clsfilename[0]
            # log.info(resultfilenames)
            resultfilenames = File.join(input,entry,"*SUMMARY.RESULTS.REPORT.[01].txt")
            Dir.glob(resultfilenames) do |fn|
              genotype = "A"
              genotype = "B" if fn =~ /1.txt/
              marker = "unknown"
              # fetch marker name
              if File.exist?(clsfilename)
                cls = BioRdf::Parsers::PubMed::ParseClsRecord.new(File.read(clsfilename))
                marker = cls.classnames[0]
              end
              gsea_results = BioRdf::Parsers::PubMed::ParseResultFile.new(fn)
              recs = gsea_results.find_all { | rec | rec.fdr_q_value <= 0.25 }
              recs.each do | rec |
                print "#{marker}\t#{genotype}\t"+rec.to_list.join("\t"),"\n"
              end
            end
          end
        end
      end
    end
  end
end
