module BioRdf
  module Parsers
    module CoDeCZ
      # chr  start   end   gene  zscore  affected_regions  total_regions   perc_regions sample
      # 
      FIELDS = { chr: :upcase, start: :to_i, end: :to_i, gene: :to_s, z_score: :to_f, 
                 affected_regions: :to_i, total_regions: :to_i, perc_regions: :to_f, sample: :to_s }
      def CoDeCZ::parse(string)
        rec = {}
        # print string
        values = string.strip.split(/\t/)
        if values.size == 9
          fields = FIELDS
        else
          p values
          raise "Size problem (was #{values.size}, expected 9)"
        end
        # p fields
        fields.keys.zip(values) do |a,b| 
          rec[a] = b.send(fields[a]) if fields[a]
        end
        p rec
        id = rec[:sample].gsub(/\.bam$/,'')
        rec[:sample] = id
        rec_id = 'codecz_' + id + '_ch' + rec[:chr].to_s + '_' + rec[:start].to_s
        rec[:id] = rec_id
        rec[:caller] = :codecz
        rec
      end
    end
  end
end

