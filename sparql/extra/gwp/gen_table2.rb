#! /usr/bin/env ruby
#
# Display relative contribution to Mi PSC.
#
# catA: PSC-PSC
# catB: PSC-conserved
# catC: PSC-unique
# all:  All PSC 
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
# ---- 1. Get the full list of Minc PSC in all (&)
all1 = csv_parse.call("env species=Mi source=#{TYPE} ../../../scripts/sparql-csv.sh count_pos_sel.rq")
all = all1.drop(1).map { |l| c = l[2] ; minc_cluster_prop[c] = {} ; c }
p [:num_PSC, all.size]
assert(all.size == 43)

# ---- 2. Annotate for homologs
# ---- 2a. Get all PSC that have homologs (&)
# Note that catB1 overlaps with catA
catB1 = csv_parse.call("env HASH=\"clusters=1,species=Mi,source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq").drop(1).flatten
# p catB1

# ---- 2b. Now we have the unique PSC (catC green) (&)
catC1 = all - catB1
p [:unique_PSC, catC1.size]
assert(catC1.size == 7,"Expect 7") if TYPE=='CDS'

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
catA = listA.map{ |pair| pair[0] }

catC = catC1 - catA # subtract those unique which fall into catA
assert(catA - catC == catA,"There should be no overlap between catA and catC")

# ---- 3a catA plant only
red_plant_pathogenA = listA.map{ |pair| pair[0] }.select { |c| ann[c] and ann[c].include?(:plant_pathogen) }
p [:red, red_plant_pathogenA.size]
orange_planthogenA = catA - red_plant_pathogenA
p [:orange, orange_planthogenA.size]

assert(red_plant_pathogenA.size == 2) if TYPE=='CDS' 

# ---- Fetch conserved (catB)
p '************************'
p all
p '************************'
p catA
p '************************'
p catC
p '************************'
p catB
assert(all.size == catA.size + catB.size + catC.size, [catA,catB,catC,all].map {|i| i.size}.to_s)

