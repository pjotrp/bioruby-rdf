module BioRdf
  module Parsers
    module BamAnnotate
      # 17 63533065 C Y C 45  80  95  37  42  0 37  12  5 51  37  6 60  37  6 59  37 5 0 0 0
      # FIELDS= { chr: :to_i, pos: :to_i, ref: :to_s, variant: :to_s,normal: :to_s,somatic_score: :to_i,tumor_consensus_quality: :to_i,tumor_variant_quality: :to_i, tumor_mean_mapping_quality: :to_i, normal_consensus_quality: :to_i, normal_variant_quality: :to_i, normal_mean_mapping_quality: :to_i, depth_in_tumor: :to_i, depth_in_normal: :to_i, base_quality_reads_supporting_ref_in_tumor: :to_i, mapping_quality_reads_supporting_ref_in_tumor: :to_i, depth_of_reads_supporting_ref_in_tumor: :to_i,  base_quality_reads_supporting_variant_in_tumor: :to_i, mapping_quality_reads_supporting_variant_in_tumor: :to_i, depth_of_reads_supporting_variant_in_tumor: :to_i,base_quality_reads_supporting_ref_in_normal: :to_i, mapping_quality_reads_supporting_ref_in_normal: :to_i, depth_of_reads_supporting_ref_in_normal: :to_i,base_quality_reads_supporting_variant_in_normal: :to_i, mapping_quality_reads_supporting_variant_in_normal: :to_i, depth_of_reads_supporting_variant_in_normal: :to_i,    }
      FIELDS1 = { chr: :upcase, pos_start: nil, pos: :to_i, descr: :to_s }
      FIELDS2 = { chr: :upcase, pos: :to_i}
      def BamAnnotate::parse(id,string)
        rec = {}
        print string
        values = string.strip.split(/\t/)
        if values.size == 4
          fields = FIELDS1
        elsif values.size == 46
          fields = FIELDS2
        else
          p values
          raise "Size problem (was #{values.size}, expected 46)"
        end
        p fields
        fields.keys.zip(values) do |a,b| 
          rec[a] = b.send(fields[a]) if fields[a]
        end
        rec_id = 'bamannotate_' + id + '_ch' + rec[:chr].to_s + '_' + rec[:pos].to_s
        rec[:id] = rec_id
        rec[:identifier] = id
        rec[:caller] = :bamannotate
        rec[:type] = if fields == FIELDS1
                       :somatic 
                     else
                       :snp
                     end
        rec
      end
    end
  end
end

