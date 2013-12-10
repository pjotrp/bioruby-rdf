module BioRdf
  module Parsers
    module Varscan2
      module ProcessSomatic
        def ProcessSomatic::parse(id,string)
          rec = {}
          values = string.strip.split(/\s+/)
          # chrom   position        ref     var     normal_reads1   normal_reads2   normal_var_freq normal_gt       tumor_reads1    tumor_reads2    tumor_var_freq  tumor_gtsomatic_status  variant_p_value somatic_p_value tumor_reads1_plus       tumor_reads1_minus      tumor_reads2_plus       tumor_reads2_minus      normal_reads1_plus      normal_reads1_minus     normal_reads2_plus      normal_reads2_minus
          [:chr,:pos,:ref,:variant,:ref_reads_in_normal,:variant_reads_in_normal,:variant_frequency_normal,:normal_gt,:ref_reads_in_tumor,:variant_reads_in_tumor,:variant_frequency_tumor,:tumor_gtsomatic_status,:type,:p_value_variant,:somatic_p_value,:tumor_reads1_plus,:tumor_reads1_minus,:tumor_reads2_plus,:tumor_reads2_minus,:normal_reads1_plus,:normal_reads1_minus,:normal_reads2_plus,:normal_reads2_minus].zip(values) {|a,b| rec[a] = b }
          rec_id = 'varscan2_' + id + '_ch' + rec[:chr] + '_' + rec[:pos]
          rec[:id] = rec_id
          rec[:caller] = :varscan2_processSomatic
          rec[:type] = :somatic
          [:chr,:pos,:ref_reads_in_normal,:variant_reads_in_normal,:ref_reads_in_tumor,:variant_reads_in_tumor,:tumor_reads1_plus,:tumor_reads1_minus,:tumor_reads2_plus,:tumor_reads2_minus,:normal_reads1_plus,:normal_reads1_minus,:normal_reads2_plus,:normal_reads2_minus].each { |k| rec[k] = rec[k].to_i }
          [:variant_frequency_normal,:variant_frequency_tumor,:p_value_variant,:somatic_p_value].each { |k| rec[k] = rec[k].to_f }
          rec
        end
      end
    end
  end
end

