module BioRdf
  module Parsers
    module Varscan2
      module ProcessSomatic
        def ProcessSomatic::parse(id,string)
          rec = {}
          values = string.strip.split(/\s+/)
          [:chr,:pos,:ref,:variant,:ref_reads_in_normal,:variant_reads_in_normal,:variant_frequency_normal,:consensus_genotype_call_in_normal,:ref_reads_in_tumor,:variant_reads_in_tumor,:variant_frequency_tumor,:somatic_status,:type,:p_value_germline,:p_value_somatic,:tumor_reads1_plus,:tumor_reads1_minus,:tumor_reads2_plus,:tumor_reads2_minus,:normal_reads1_plus,:normal_reads1_minus,:normal_reads2_plus,:normal_reads2_minus].zip(values) {|a,b| rec[a] = b }
          rec_id = 'varscan2_' + id + '_ch' + rec[:chr] + '_' + rec[:pos]
          rec[:id] = rec_id
          rec[:identifier] = id
          rec[:caller] = :varscan2
          rec[:type] = rec[:type].downcase.to_sym
          [:chr,:pos,:ref_reads_in_normal,:variant_reads_in_normal,:ref_reads_in_tumor,:variant_reads_in_tumor,:tumor_reads1_plus,:tumor_reads1_minus,:tumor_reads2_plus,:tumor_reads2_minus,:normal_reads1_plus,:normal_reads1_minus,:normal_reads2_plus,:normal_reads2_minus].each { |k| rec[k] = rec[k].to_i }
          [:variant_frequency_normal,:variant_frequency_tumor,:p_value_germline,:p_value_somatic].each { |k| rec[k] = rec[k].to_f }
          rec
        end
      end
    end
  end
end

