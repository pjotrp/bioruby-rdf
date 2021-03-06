module BioRdf
  module Parsers
    module SomaticSniper
      # Using the classic tab delimited file (because of the filters)
      #
      # Chromosome
      # Position
      # Reference base
      # IUB genotype of tumor
      # IUB genotype of normal
      # Somatic Score
      # Tumor Consensus quality
      # Tumor variant allele quality
      # Tumor mean mapping quality
      # Normal Consensus quality
      # Normal variant allele quality
      # Normal mean mapping quality
      # Depth in tumor (# of reads crossing the position)
      # Depth in normal (# of reads crossing the position)
      # Mean base quality of reads supporting reference in tumor
      # Mean mapping quality of reads supporting reference in tumor
      # Depth of reads supporting reference in tumor
      # Mean base quality of reads supporting variant(s) in tumor
      # Mean mapping quality of reads supporting variant(s) in tumor
      # Depth of reads supporting variant(s) in tumor
      # Mean base quality of reads supporting reference in normal
      # Mean mapping quality of reads supporting reference in normal
      # Depth of reads supporting reference in normal
      # Mean base quality of reads supporting variant(s) in normal
      # Mean mapping quality of reads supporting variant(s) in normal
      # Depth of reads supporting variant(s) in normal
      # 17 63533065 C Y C 45  80  95  37  42  0 37  12  5 51  37  6 60  37  6 59  37 5 0 0 0
      FIELDS= { chr: :upcase, pos: :to_i, ref: :to_s, variant: :to_s,normal: :to_s,somatic_score: :to_i,tumor_consensus_quality: :to_i,tumor_variant_quality: :to_i, tumor_mean_mapping_quality: :to_i, normal_consensus_quality: :to_i, normal_variant_quality: :to_i, normal_mean_mapping_quality: :to_i, depth_in_tumor: :to_i, depth_in_normal: :to_i, base_quality_reads_supporting_ref_in_tumor: :to_i, mapping_quality_reads_supporting_ref_in_tumor: :to_i, depth_of_reads_supporting_ref_in_tumor: :to_i,  base_quality_reads_supporting_variant_in_tumor: :to_i, mapping_quality_reads_supporting_variant_in_tumor: :to_i, depth_of_reads_supporting_variant_in_tumor: :to_i,base_quality_reads_supporting_ref_in_normal: :to_i, mapping_quality_reads_supporting_ref_in_normal: :to_i, depth_of_reads_supporting_ref_in_normal: :to_i,base_quality_reads_supporting_variant_in_normal: :to_i, mapping_quality_reads_supporting_variant_in_normal: :to_i, depth_of_reads_supporting_variant_in_normal: :to_i,    }
      def SomaticSniper::parse(id,string)
        rec = {}
        values = string.strip.split(/\s+/)
        # p FIELDS
        FIELDS.keys.zip(values) do |a,b| 
          rec[a] = b.send(FIELDS[a])
        end
        rec_id = 'somaticsniper_' + id + '_ch' + rec[:chr].to_s + '_' + rec[:pos].to_s
        rec[:id] = rec_id
        rec[:identifier] = id
        rec[:caller] = :somaticsniper
        rec[:type] = :somatic
        rec
      end
    end
  end
end

