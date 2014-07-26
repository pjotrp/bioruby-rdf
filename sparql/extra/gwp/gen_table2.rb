#! /usr/bin/env ruby
#
# Display relative contribution to Mi PSC.
#
# catA: list PSC-PSC
# catB: list PSC-conserved
# catC: list PSC-unique
# all:  All PSC (catA+catB+catC)
# catH: All clusters that have BLAST homologs
# ann:  All BLST annotated for :matches, :(plant_)pathogen, :refseq, 
#                              :cds and :dna in catH 
#
require 'csv'
require 'solid_assert'

SolidAssert.enable_assertions
h=ARGV.map{ |s| s.split('=') }.to_h
p h
# inputs
species     = h['species']
source      = h['source']

TYPE = source
do_assert = (TYPE=='CDS' and species == 'Mi')

# Bm_DNA  Cb_DNA  Ce_DNA  Gp_DNA  Mh_DNA  Mi_DNA  Pi_DNA  Pp_DNA  Ts_CDS
# Bx_DNA  Ce_CDS  Gp_CDS  Mh_CDS  Mi_CDS  Pi_CDS  Pp_CDS  Sr_DNA  Ts_DNA

PLANT_PATHOGENS=['Mi','Mh','Gp','Bx','Pi']
ANIMAL_PATHOGENS=['Bm','Ts','Sr']
FREE_LIVING=['Ce','Cb','Pp']

ALL_PATHOGENS  = PLANT_PATHOGENS + ANIMAL_PATHOGENS + FREE_LIVING

csv_parse = lambda { |cmd|
  $stderr.print "===> Calling: #{cmd}\n"
  CSV::parse(`#{cmd}`)
}

minc_cluster_prop = {} # cluster properties
# ---- 1. Get the full list of Minc PSC in all (&)
all1 = csv_parse.call("env species=#{species} source=#{TYPE} ../../../scripts/sparql-csv.sh count_pos_sel.rq")
all = all1.drop(1).map { |l| c = l[2] ; minc_cluster_prop[c] = {} ; c }
p [:num_PSC, all.size]
# ==== all
assert(all.size == 43) if do_assert   

# ---- 2. Annotate for homologs
# ---- 2a. Get all PSC that have homologs *catH* (&)
# Note that catH overlaps with catA and that catH is larger than all PSC(!)
catH = csv_parse.call("env HASH=\"by_cluster=1,species=#{species},source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq").drop(1).flatten
# ==== catH
assert(catH.size == 29,"Expect 29 was #{catH.size}") if do_assert

# ---- 2b. Annotate plantP only (&)
#      catH contains all ann PSC. So we can select those that
#      contain only-plant matches
list1 = csv_parse.call("env HASH=\"by_gene=1,species=#{species},source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq").drop(1)
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
    assert(s != species)  # Make sure there is no accidental self reference
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
p [:annotated, ann.sort]

minc_cluster_plantp = ann.keys.select { |k| ann[k].include?(:plant_pathogen) }
p [:plantP, minc_cluster_plantp.size ]
assert(minc_cluster_plantp.size == 13) if do_assert 

# ---- 2c and 2d. Annotated in ann! (&)

# ---- 3. Fetch matching PSC (catA) &
#      Cat. A - create pairs of cluster + species, the list may contain
#      references to other Mi EST clusters, but not to self
catA = csv_parse.call("env HASH=\"by_cluster=1,species1=#{species},is_pos_sel=1,source1=#{TYPE},species2=Other,is_pos_sel2=1\" ../../../scripts/sparql-csv.sh match_clusters.rq").drop(1).flatten
# ==== we have catA
assert(catA.size == 8,catA.size) if do_assert 

# ---- 3a catA plant only
plant_pathogenA = catA.select { |c| ann[c] and ann[c].include?(:plant_pathogen) }
p [:red, plant_pathogenA.size]
# ==== we have catA orange and red!
otherA = catA - plant_pathogenA
p [:orange, otherA.size]
assert(otherA.size == 4,otherA.size.to_s) if do_assert 

# ---- Now we can have the unique PSC (catC green) (&)
catC = all - catA - catH
p [:unique_PSC, catC.size]
assert(catC.size == 14,"Was #{catC.size}") if do_assert

assert(catA & catC == [],"There should be no overlap between catA and catC")
catB = all - catA - catC 
assert(catB.size == 21,catB.size) if do_assert

# ---- Fetch conserved (catB)
p '** all **********************'
p all
p '** catA **********************'
p catA
p '** catB **********************'
p catB
p '** catC **********************'
p catC
p '** overlap **********************'
p catA & catB
p catA & catC
p catB & catC
p catA & all
p [(catA & all).size,catA.size]
assert(all & catB == catB)
assert(all & catC == catC)
assert(catA & all == catA)
assert(all.size == catA.size + catB.size + catC.size, [catA,catB,catC,all].map {|i| i.size}.to_s)

# plant_pathogenB are those in catB that map to :plant_pathogen
plant_pathogenB = catB.select { |c| a = ann[c] ; a.include?(:plant_pathogen) }
p orfB = (catB - plant_pathogenB).select { |c| a = ann[c] ; a.include?(:dna) and !a.include?(:cds) and !a.include?(:refseq) }
conservedB = catB - orfB - plant_pathogenB
assert(plant_pathogenB & orfB == [])
assert(plant_pathogenB & conservedB == [])
assert(orfB & conservedB == [])

print "cat A. plant pathogen only\t",plant_pathogenA.size,"\n"
print "cat A. other\t",otherA.size,"\n"
print "cat B. plant pathogen only \t",plant_pathogenB.size,"\n"
print "cat B. conserved \t",conservedB.size,"\n"
print "cat B. ORFs \t",orfB.size,"\n"
print "cat C. unique\t",catC.size,"\n"
