module BioRdf
  module Parsers
    module Extra
      module GWP
        def GWP::parse_digest(name,buf)
          lines = buf.split(/\n/).map { |s| s.split(/\s+/) }
          recs = {}
          lines.each do | a |
            cluster = /(cluster\d+)/.match(a[0])[1]
            r = recs[cluster] = {}
            r[:id] = name + '_' + cluster
            r[:model] = 'M78' if a[1] =~ /7/ 
            r[:lnL] = a[4].to_f
            r[:is_pos_sel] = (a[5] == '++')
            r[:sites] = a[6].to_i
            r[:seq_size] = a[8][1..-1].to_i if a[8] 
          end
          recs
        end
      end
    end
  end
end
