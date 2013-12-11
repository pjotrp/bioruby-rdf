module BioRdf
  module Parsers
    module SomaticSniper
      FIELDS=[:chr,:pos]
      INTEGERS= FIELDS
      FLOATS = {}
      #  [:chr,:pos,:ref,:variant,:ref_reads_in_normal,:variant_reads_in_normal,:variant_frequency_normal,:consensus_genotype_call_in_normal,:ref_reads_in_tumor,:variant_reads_in_tumor,:variant_frequency_tumor,:somatic_status,:type,:p_value_germline,:p_value_somatic,:tumor_reads1_plus,:tumor_reads1_minus,:tumor_reads2_plus,:tumor_reads2_minus,:normal_reads1_plus,:normal_reads1_minus,:normal_reads2_plus,:normal_reads2_minus]
      def SomaticSniper::parse(id,string)
        rec = {}
        values = string.strip.split(/\s+/)
        FIELDS.zip(values) {|a,b| rec[a] = b }
        rec_id = 'somaticsniper_' + id + '_ch' + rec[:chr] + '_' + rec[:pos]
        rec[:id] = rec_id
        rec[:identifier] = id
        rec[:caller] = :somaticsniper
        rec[:type] = :somatic
        INTEGERS.each { |k| rec[k] = rec[k].to_i }
        FLOATS.each { |k| rec[k] = rec[k].to_f }
        rec
      end
    end
  end
end

