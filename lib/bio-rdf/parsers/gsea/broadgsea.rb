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
          @fields = string.split(/\t/)
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
        def es
          @es ||= @fields[3].to_f
        end
        def nes
          @nes ||= @fields[4].to_f
        end
        # NOM p-value
        # Nominal p value; that is, the statistical significance of the
        # enrichment score. The nominal p value is not adjusted for gene set
        # size or multiple hypothesis testing; therefore, it is of limited use
        # in comparing gene sets.
        def nominal_p_value
          @nominal_p_value ||= @fields[5].to_f
        end
        # FDR q-value
        # False discovery rate; that is, the estimated probability that the
        # normalized enrichment score represents a false positive finding.
        def fdr_q_value
          @fdr_q_value ||= @fields[6].to_f
        end
        alias :fdr :fdr_q_value

        # FWER p-value
        # Familywise-error rate; that is, a more conservatively estimated
        # probability that the normalized enrichment score represents a false
        # positive finding. Because the goal of GSEA is to generate hypotheses,
        # the GSEA team recommends focusing on the FDR statistic.
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
    end
  end
end
