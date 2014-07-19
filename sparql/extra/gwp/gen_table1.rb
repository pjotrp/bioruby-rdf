#! /usr/bin/env ruby
#
# A search for pos_sel clusters in each species:
#
# Category A: matching pos_sel in another species
#          B: matching homologs in other species (minus A)
#          C: Unique to each species (pos_sel - B - A)

require 'csv'

SPECIES=[:Mi, :Mh, :Gp, :Ts, :Pp, :Ce, :Pi ]
# CATS   ={"Mi A"=> "Mi", "A" => "Other" ,"Mi B" => "Mi","B" => "Other", "C" => nil}
CATS   ={"A" => "Other" ,"B" => "Other", "C" => nil}
TYPE   =:CDS

# Fetch pos. sel. clusters
count_pos = CSV::parse(`env count=1 ../../../scripts/sparql-csv.sh count_pos_sel.rq`)
cds_count_pos = {}
count_pos.each do | l |
  (s,t,num) = l
  cds_count_pos[s.to_sym] = num.to_i if t=='CDS'
end

# Read table
m = {}

# Here we fetch the matching clusters for cat. A and B.
SPECIES.each do |s|
  m[s] ||= {}
  CATS.each do | c,v |
    case c 
      when 'A'
        res = `env HASH="species1=#{s},is_pos_sel=1,source1=CDS,species2=#{v},source2=#{TYPE},is_pos_sel2=1" ../../../scripts/sparql-csv.sh match_clusters.rq |wc -l`
        m[s]['A'] ||= res.to_i - 1 # Exclude header line
      when 'B'
        res =`env HASH="species=#{s},source1=#{TYPE}" ../../../scripts/sparql-csv.sh blast2.rq|wc -l`
        m[s]['B'] ||= res.to_i - 1 # Exclude header line
      when 'C'
        m[s]['C'] = cds_count_pos[s]
    end
  end
end
p cds_count_pos
p m

# Print table
out = lambda {
  print "\t",CATS.keys.join("\t"),"\n"
  SPECIES.each do | s |
    print s.to_s,"\t"
    print CATS.keys.map { |c| (m[s][c] ? m[s][c] : "" ) }.join("\t")
    print "\n"
  end
}

out.call

# Category A: matching pos_sel in another species
#          B: matching homologs in other species (minus A)
#          C: Unique to each species (pos_sel - B - A)

# C is C - B
SPECIES.each do | s |
  m[s]["C"] -= m[s]["B"]
end
# B is B - A
SPECIES.each do | s |
  m[s]["B"] -= m[s]["A"]
end
# Special case, subtract Mi matches
# {"A" => "Mi A" ,"B" => "Mi B"}.each do | c,c2 |
#   SPECIES.each do | s |
#     m[s][c] -= m[s][c2]
#   end
# end

out.call

require 'rspec'
raise 'Error' if m[:Mh]['A'] != 7
raise 'Error' if m[:Mh]['B'] != 6
raise 'Error' if m[:Mh]['C'] != 3
