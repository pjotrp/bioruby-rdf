module BioRdf
  module Parsers
    module BroadGSEA

      # Parses a 3 line CLS record (see features for an example)
      class ParseClsRecord
        attr_reader :classnames, :classes
        def initialize buf
          lines = buf.split("\n")
          raise "CLS record should be 3 lines" if lines.size != 3
          classline = lines[1]
          raise "Second line should start with #" if classline[0] != "#"
          @classnames = classline.split(/\s+/)[1..2]
          @classes = lines[2].split(/\s+/)
        end
      end

      # Parses a single line result lazily (see features for an example)
      #
      # GS SIZE SOURCE ES NES NOM-p-val FDR-q-val FWER-p-val Tag% Gene% Signal FDR_(median) glob.p.val
      class ParseResultRecord
        def initialize string
          @fields = string.strip.split(/\t/)
        end
        def to_list
          @fields
        end
        def geneset_name
          @fields[0]
        end
        def source
          @fields[2]
        end
        # ES: Enrichment score for the gene set; that is, the degree to which
        # this gene set is overrepresented at the top or bottom of the ranked
        # list of genes in the expression dataset.
        def es
          @es ||= @fields[3].to_f
        end 
        # NES: Normalized enrichment score; that is, the enrichment score for
        # the gene set after it has been normalized across analyzed gene sets.
        def nes
          @nes ||= @fields[4].to_f
        end
        # NOM p-value: Nominal p value; that is, the statistical significance
        # of the enrichment score. The nominal p value is not adjusted for gene
        # set size or multiple hypothesis testing; therefore, it is of limited
        # use in comparing gene sets.
        def nominal_p_value
          @nominal_p_value ||= @fields[5].to_f
        end
        # FDR q-value: False discovery rate; that is, the estimated probability
        # that the normalized enrichment score (NES) represents a false
        # positive finding. For example, an FDR of 25% indicates that the
        # result is likely to be valid 3 out of 4 times.
        def fdr_q_value
          @fdr_q_value ||= @fields[6].to_f
        end
        alias :fdr :fdr_q_value

        # FWER p-value: Familywise-error rate; that is, a more conservatively
        # estimated probability that the normalized enrichment score represents
        # a false positive finding. Because the goal of GSEA is to generate
        # hypotheses, the GSEA team recommends focusing on the FDR statistic.
        def fwer_p_value
          @fwer_p_value ||= @fields[7].to_f
        end
        def signal
          @signal ||= @fields[10].to_f
        end
        def median_fdr
          @median_fdr ||= @fields[11].to_f
        end
        def global_p_value
          @global_p_value ||= @fields[12].to_f
        end
      end

      class ParseResultFile
        include Enumerable
        def initialize filename
          @list = []
          f = File.open(filename)
          f.gets # skip header
          f.each_line do | line |
            @list << ParseResultRecord.new(line)
          end
        end
        def each
          @list.each do | rec |
            yield rec
          end
        end
      end

      module Parser

        def Parser::handle_options 
          options = OpenStruct.new()
          
          opts = OptionParser.new() do |o|
            o.banner = "Usage: #{File.basename($0)} gsea [options] dir"

            o.on_tail("-h", "--help", "Show help and examples") {
              print(o)
              exit()
            }
            o.on("-e filter","--exec filter",String, "Execute filter") do |s|
              options.exec = s
            end

            o.on("--tabulate","Output tab delimited table") do
              options.output = :tabulate
            end

          end
          opts.parse!(ARGV)
          dir = ARGV[0]
          if dir and File.directory?(dir)
            do_parse(dir, options.exec, options.output)
          else
            raise "you should supply a GSEA directory!" 
          end
        end

        require 'bio-logger'
        include Bio::Log

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
                cls = BioRdf::Parsers::BroadGSEA::ParseClsRecord.new(File.read(clsfilename))
                marker = cls.classnames[0]
              end
              gsea_results = BioRdf::Parsers::BroadGSEA::ParseResultFile.new(fn)
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
