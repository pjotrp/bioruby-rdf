module BioRdf
  module Extra
    module Parsers
      module GWP
        module Digest
          def Digest::parse(name,cluster,buf)
            raise "Missing name!" if name.nil?
            species,type = name.split(/_/)
            lines = buf.split(/\n/).map { |s| 
              s.split(/\s+/) 
            }
            recs = {}
            lines.each do | a |
              cluster = /(cluster\d+)/.match(a[0])[1]
              clusterid = name + '_' + cluster
              r = recs[cluster] = {}
              r[:id] = name + '_' + cluster
              r[:cluster] = clusterid.to_sym
              r[:model] = 'M78' if a[1] =~ /7/ 
              r[:species] = species
              r[:source] = type
              r[:lnL] = a[4].to_f
              r[:is_pos_sel] = (a[5] == '++')
              r[:sites] = a[6].to_i if a[6]
              r[:seq_size] = a[8][1..-1].to_i if a[8] 
            end
            recs
          end
        end

        module Blast
          def Blast::parse(name,cluster,buf)
            raise "Missing name!" if name.nil?
            raise "Missing cluster name!" if cluster.nil?
            # Caenorhabditis elegans\tNP_001251447\tProtein CDC-26, isoform c  > Protein CDC-26, isoform c\tgi|392887062|ref|NP_001251447.1|\t1.76535e-89
            # p buf
            species,type = name.split(/_/)
            lines = buf.split(/\n/).map { |s| s.split(/\t/) }
            # p lines[0]
            recs = []
            lines.each do | a |
              clusterid = name + '_' + cluster
              gene = a[1]
              r = {}
              r[:id] = name + '_' + cluster + '_' + gene
              r[:cluster] = clusterid.to_sym
              r['a'] = :blast_match
              r[:species] = species
              r[:source] = type
              hfull = a[0]
              r[:homolog_species] = hfull.split.map { |w| w[0] }.join('')
              r[:homolog_species_full] = hfull
              r[:homolog_gene] = gene
              r[:descr] = a[2]
              r[:e_value] = a[4].to_f
              recs << r
            end
            recs
          end
        end
      end
    end
  end
end
