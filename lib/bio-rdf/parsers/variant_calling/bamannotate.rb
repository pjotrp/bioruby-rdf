module BioRdf
  module Parsers
    module BamAnnotate
      # chr  pos strand  na_change aa_change pv_mean cov_mean  gene_name
      # vartype in_1  in_2  cov_3 cov_4 pv_3  pv_4  fvc_3 fvc_4 rvc_3 rvc_4
      # po_3  po_4  pr_3  pr_4  calls_3 calls_4 ccds_id codon snp_id  effect
      # hgvs_t  hgvs_c  hgvs_p  poly phen_s  polyphen_p  sift_s  sift_p  gerp
      # gerp_region grantham  high_freq high_popu gene_id tran_id prot_id
      # ncbi36_h g18 info
      # 
      FIELDS1 = { chr: :upcase, pos_start: nil, pos: :to_i, descr: :to_s }
      FIELDS2 = { chr: :upcase, pos: :to_i,
strand: :to_i, na_change: :to_s, aa_change: :to_s, pv_mean: :to_f, cov_mean: :to_f,  gene_name: :to_s,
vartype: :to_s, in_1: :to_s,  in_2: :to_s,  cov_3: :to_i, cov_4: :to_i, pv_3: :to_i,  pv_4: :to_i,  fvc_3: :to_i, fvc_4: :to_i, rvc_3: :to_i, rvc_4: :to_i,
po_3: :to_i,  po_4: :to_i, pr_3: :to_i , pr_4: :to_i ,calls_3: :to_s, calls_4: :to_s, ccds_id: :to_s, codon: :to_s, snp_id: :to_s,  effect: :to_s,
hgvs_t: :to_s,  hgvs_c: :to_s,  hgvs_p: :to_s,  polyphen_s: :to_f,  polyphen_p: :to_f,  sift_s: :to_f,  sift_p: :to_f,  gerp: :to_f,
gerp_region: :to_s, grantham: :to_s,  high_freq: :to_s, high_popu: :to_s, gene_id: :to_s, tran_id: :to_s, prot_id: :to_s,
ncbi36_hg18: :to_s, info: :to_s



      }
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

