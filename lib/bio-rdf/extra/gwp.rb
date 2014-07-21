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
              r[:id] = ('gwp:' + name + '_' + cluster).to_sym
              # r[:clusterid] = clusterid.to_sym
              r[:model] = 'M78' if a[1] =~ /7/ 
              r[:species] = species
              r[:source] = type
              r[:lnL] = a[4].to_f
              r[:is_pos_sel] = (a[5] == '++')
              r[:sites] = a[6].to_i if a[6]
              r[:seq_size] = a[8][1..-1].to_i if a[8] 

              # Assertions
              raise "Error "+buf if not /\S\S_(CDS|DNA|EST)_cluster\d+$/.match(r[:id])
              raise "Error "+buf if not /(CDS|DNA|EST)$/.match(r[:source])
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
              descr = a[2]
      
              r = {}
              r[:id] = name + '_' + cluster + '_' + gene
              r[:cluster] = ('gwp:'+clusterid).to_sym
              r['a'] = :blast_match
              # r[:species] = species
              # r[:source] = type
              hfull = a[0]
              if hfull !~ /_(DNA|CDS|EST)/
                hfull = /\[(\S+_(CDS|DNA|EST))\]/.match(buf)[1]
              end
              raise "Expected Ss_TYPE (e.g., Mi_CDS) instead of #{hfull} for "+buf if hfull !~ /\S\S_(CDS|DNA|EST)/
              r[:homolog_species] = hfull.split.map { |w| w[0] }.join('')
              r[:homolog_gene] = gene
              hcluster = /(cluster\d+)/.match(descr)[1]
              # $stderr.print hcluster,"\n"
              raise "Missing cluster for "+buf if not hcluster
              r[:homolog_cluster] = ('gwp:'+hfull+'_'+hcluster).to_sym
              raise "Illegal hcluster <#{r[:homolog_cluster]}> for "+buf if r[:homolog_cluster] =~ /\s/
              r[:descr] = descr
              r[:e_value] = a[4].to_f
              # p "HERE",descr
              if descr =~ /(\[(\w+)_(DNA|CDS|EST)\])/ or hfull =~ /((\w+)_(DNA|CDS|EST))/
                r[:homolog_species_full] = $1
                r[:homolog_species] = $2
                r[:homolog_source] = $3
              end
              r[:homolog_species_full] = hfull.sub(/\[|\]/,"") # remove brackets
              # assertions
              raise "Error <#{r[:homolog_source]}> "+buf if not /(CDS|DNA|EST)$/.match(r[:homolog_source])
              raise "Error <#{r[:homolog_species_full]}> "+buf if not /\w+_(CDS|DNA|EST)$/.match(r[:homolog_species_full])
              raise "Error "+buf if not /\S\S_(CDS|DNA|EST)_cluster\d+$/.match(r[:homolog_cluster])
              # override species
              recs << r
            end
            recs
          end
        end
      end
    end
  end
end
