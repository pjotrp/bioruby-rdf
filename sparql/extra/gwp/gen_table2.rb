#! /usr/bin/env ruby
#
# Display relative contribution to Mi PSC
#
require 'csv'

TYPE='CDS'
PATHOGENS=['Mi','Mh','Gp','Bx']

# ---- Get the total tally of CDS PSC
count_pos = CSV::parse(`env count=1 ../../../scripts/sparql-csv.sh count_pos_sel.rq`)
cds_count_pos = {}
count_pos.each do | l |
  (s,t,num) = l
  cds_count_pos[s.to_sym] = num.to_i if t=='CDS'
end
total = cds_count_pos[:Mi]
p [:total,total]

# ---- Cat. A
catA = CSV::parse(`env HASH="species1=Mi,is_pos_sel=1,source1=CDS,species2=Other,source2=CDS,is_pos_sel2=1" ../../../scripts/sparql-csv.sh match_clusters.rq`)
total_catA = catA.size-1
p catA
p [:catA,total_catA]
subcatA = catA[1..-1].map {|duo| duo[1]}.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}

p [:subcatA,subcatA]

# ---- Cat. B
catB1 = CSV::parse(`env HASH="species=Mi,source1=CDS" ../../../scripts/sparql-csv.sh blast2.rq`)
total_catB = catB1.size-1 - total_catA
p [:catB,total_catB]
cnames = catB1.flatten[1..-1]
# p cnames
cluster = {}
cnames.map { |c| cluster[c] = [] }
catB = CSV::parse(`env HASH="by_gene=1,species=Mi,source1=CDS" ../../../scripts/sparql-csv.sh blast2.rq`)[1..-1].map {|row| cluster[row[0]] << row[2] }

# subcategorise B, first split into plantp, non-plantp, refseq, and dna
#
# The idea is to first find the Refseq matches, next the CDS and
# finally the DNA.
wormp = []; worm = []; refseq=[]; orf=[]
cluster.each do | cname, species |
  # Look for CDS pathogens annotated
  non_pathogen = nil
  matched = nil
  species.each do | s |
    if (match = /(\S\S)_CDS/.match(s))
      matched = true
      if not PATHOGENS.include?(match[1])
        non_pathogen = true 
      end
    end
  end
  if matched
    if non_pathogen
      worm << cname
    else
      wormp << cname
    end
    next # cluster
  end
  next
  # Look for RefSeq annotated or DNA
  is_orf = false
  matched = false
  species.each do | s |
    if (match = /(\S\S)_DNA/.match(s))
      matched = true
      is_pathogen = true if PATHOGENS.include?(match[1])
    end
  end
  if matched
    if is_pathogen
      wormp << cname
    else
      worm << cname
    end
    next # cluster
  end
end
p wormp
p worm

exit

# ---- Cat. C
total_catC = total - total_catB - total_catA
p [:catC,total_catC]

