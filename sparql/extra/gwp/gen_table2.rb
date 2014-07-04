#! /usr/bin/env ruby
#
# Display relative contribution to Mi PSC.
#
#
require 'csv'
require 'solid_assert'

SolidAssert.enable_assertions

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
assert(minc_cluster_unique.size == 7) if TYPE=='CDS'

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
  plant  = false
  patho  = false
  free   = false
  other  = false

  ms.keys.each { | s |
    assert(s != 'Mi')  # Make sure there is no accidental self reference
    assert(s != 'Nema')  # Make sure there is no accidental self reference
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

  cds    = false
  dna    = false
  refseq = false

  ms.keys.each { | s |
    full = ms[s]
    if full =~ /_CDS/
      cds = true
    elsif full =~ /_DNA/
      dna = true
    else 
      refseq = true
    end
  }
  ann[cluster] << :refseq if refseq 
  ann[cluster] << :cds if cds
  ann[cluster] << :dna if dna
}
p [:annotated, ann]

minc_cluster_plantp = ann.keys.select { |k| ann[k].include?(:plant_pathogen) }
p [:plantP, minc_cluster_plantp.size ]
assert(minc_cluster_plantp.size == 9) if TYPE=='CDS' 

# ---- 2d and 2e. Annotate is in ann (&)

# ---- 3. Fetch matching PSC (catA).
#      Cat. A - create pairs of cluster + species, the list may contain
#      references to other Mi EST clusters, but not to self
listA = csv_parse.call("env HASH=\"species1=Mi,is_pos_sel=1,source1=#{TYPE},species2=Other,is_pos_sel2=1\" ../../../scripts/sparql-csv.sh match_clusters.rq").drop(1)

# p listA

# ---- 3a catA plant only
red_plant_pathogenA = listA.map{ |pair| pair[0] }.select { |c| ann[c] and ann[c].include?(:plant_pathogen) }
orange_planthogenA = listA.map{ |pair| pair[0] }.select { |c| ann[c] and ann[c].include?(:pathogen) }

# ---- Fetch conserved (catB)



exit # Old old old...


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


