#! /usr/bin/env ruby
#
# Display relative contribution to Mi PSC.
#
#
require 'csv'

TYPE = if ARGV[0] == 'DNA'
         'DNA'
       else
         'CDS'
       end
PLANT_PATHOGENS=['Mi','Mh','Gp','Bx','Pi']
ANIMAL_PATHOGENS=['Bm','Ts','Sr']
FREE_LIVING=['Ce','Cb','Pp']

ALL_PATHOGENS  = PLANT_PATHOGENS + ANIMAL_PATHOGENS + FREE_LIVING

csv_parse = lambda { |cmd|
  $stderr.print "===> Calling: #{cmd}\n"
  CSV::parse(`#{cmd}`)
}

minc_cluster_prop = {}
# ---- 1. Get the full list of Minc PSC in minc_psc (&)
minc_psc1 = csv_parse.call("env species=Mi source=#{TYPE} ../../../scripts/sparql-csv.sh count_pos_sel.rq")
minc_psc = minc_psc1.drop(1).map { |l| c = l[2] ; minc_cluster_prop[c] = {} ; c }
p [:num_PSC, minc_psc.size]

# ---- 2. Annotate for homologs
# ---- 2a. Get all PSC that have homologs (&)
catB1 = csv_parse.call("env HASH=\"clusters=1,species=Mi,source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq").drop(1).flatten
# p catB1

# ---- 2b. Now we have the unique PSC (catC green) (&)
minc_cluster_unique = minc_psc - catB1
p [:unique_PSC, minc_cluster_unique.size]
raise "Error" if TYPE=='CDS' and minc_cluster_unique.size != 7

# ---- 2c. Annotate plantP only (&)
#      CatB1 contains all ann PSC. So we can select those that
#      contain only-plant matches
list1 = csv_parse.call("env HASH=\"by_gene=1,species=Mi,source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq").drop(1)
# Create a hash of clusters that contain species and num
matches = list1.inject(Hash.new) { |h,a| 
  cluster = a[0]
  h[cluster] ||= {}
  match = a[1]
  h[cluster][match] = a[2]
  h
}
# p [:matches, matches]

ann = {}

matches.each { |cluster,ms| 
  plant = false
  patho = false
  free  = false
  other = false
  ms.keys.each { | s |
    if PLANT_PATHOGENS.include?(s)
      plant = true 
    elsif ANIMAL_PATHOGENS.include?(s)
      patho = true 
    elsif FREE_LIVING.include?(s)
      free = true
    else
      other = true
    end
  }
  ann[cluster] = [:matches => ms.keys ]
  if other
    # nothing
  elsif free
    ann[cluster] << :free
  elsif patho
    ann[cluster] << :pathogen
  elsif plant
    ann[cluster] << :pathogen
    ann[cluster] << :plant_pathogen
  end
}

minc_cluster_plantp = ann.keys.select { |k| ann[k].include?(:plant_pathogen) }
p [:plantP, minc_cluster_plantp.size ]
raise "Error" if TYPE=='CDS' and minc_cluster_plantp.size != 9
exit

# ---- 2d and 2e. Annotate is in ann (&)

# ---- 3. Fetch matching PSC (catA).
#      Cat. A - create pairs of cluster + species
listA = csv_parse.call("env HASH=\"species1=Mi,is_pos_sel=1,source1=#{TYPE},species2=Other,is_pos_sel2=1\" ../../../scripts/sparql-csv.sh match_clusters.rq").drop(1)

p listA


exit # Old old old...

exit

# Create hash of clusters with matching species
catA = listA.drop(1).inject(Hash.new) { |h,pair| 
  h[pair[0]] ||= []
  h[pair[0]] << pair[1] 
  h
}
total_catA = catA.size
p catA
p [:catA_PSC_PSC,total_catA]
raise "Error" if TYPE=='CDS' and total_catA!=10

exit

# ---- 1b. Get the other PSC
count_pos = csv_parse.call("env count=1 ../../../scripts/sparql-csv.sh count_pos_sel.rq")
type_count_pos = {}
count_pos.each do | l |
  (s,t,num) = l
  type_count_pos[s.to_sym] = num.to_i if t==TYPE
end
total = type_count_pos[:Mi]
p [:total,total] 
raise "Error" if TYPE=='CDS' and total!=43

  # ---- subcat A1 count PlantP only
  subcatA = catA.keys.map { |cluster| 
    species = catA[cluster]
    p species
    species.inject(true) { |cnt,s|
      (!PLANT_PATHOGENS.include?(s) ? false : cnt )
    }
  }
  p [:subcatA,subcatA.count(true)]

# Not quite done yet, we need to subtract the ones that have matches in catB
# as they are not totally unique!

# ---- Cat. B
  total_catB = catB1.size-1 - total_catA
  p [:catB,total_catB]
  cnames = catB1.flatten[1..-1]
  # p cnames
  cluster = {}
  cnames.map { |c| cluster[c] = [] }
  catB = csv_parse.call("env HASH=\"by_gene=1,species=Mi,source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq")[1..-1].map {|row| cluster[row[0]] << row[2] }

  # subcategorise B, first split into plantp, non-plantp, refseq, and dna
  #
  # The idea is to first find the Refseq matches, next the TYPE and
  # finally the DNA.
  wormp = []; worm = []; refseq=[]; orf=[]
  cluster.each do | cname, species |
    # Look for CDS pathogens ann
    non_pathogen = nil
    matched = nil
    species.each do | s |
      if (match = /(\S\S)_CDS/.match(s))
        matched = true
        if not PLANT_PATHOGENS.include?(match[1])
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
    # Look for RefSeq ann or DNA
    is_orf = false
    matched = false
    species.each do | s |
      if (match = /(\S\S)_DNA/.match(s))
        matched = true
        is_pathogen = true if PLANT_PATHOGENS.include?(match[1])
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
  

