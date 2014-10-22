#! /usr/bin/env ruby
#
# ./gen_table3.rb species=Mi source=CDS (default)
# ./gen_table3.rb species=Mi source=DNA
#
# catA: Mi conserved Plant Pathogen only
#   catA1: PSC-PSC (light green)
#   catA2: PSC     (dark green)
# catB: Mi conserved Non-plant-pathogen (incl. Refseq)
#   catB1: CDS     (light red)
#   catB2: ORF     (dark red)
# catC: Mi unique  (light blue)
#
# Not plotted are
#
# catH: All Refseq matches
#
# ann:  All BLST annotated for :matches, :(plant_)pathogen, :refseq, 
#                              :cds and :dna in catH 
require 'csv'
require 'solid_assert'

SolidAssert.enable_assertions
h=ARGV.map{ |s| s.split('=') }.to_h
p [:options,h]
# inputs
species     = h['species']
source      = h['source']
species = 'Mi' if not species
source  = 'CDS' if not source

TYPE = source
is_cds    = (TYPE=='CDS')
is_orf    = (TYPE=='DNA')
do_assert = (species == 'Mi')
do_cassert = (is_cds and species == 'Mi')
short = ( is_cds ? species+'_c' : species+'_o' )
      

# Bm_DNA  Cb_DNA  Ce_DNA  Gp_DNA  Mh_DNA  Mi_DNA  Pi_DNA  Pp_DNA  Ts_CDS
# Bx_DNA  Ce_CDS  Gp_CDS  Mh_CDS  Mi_CDS  Pi_CDS  Pp_CDS  Sr_DNA  Ts_DNA

PLANT_PATHOGENS=['Mi','Mh','Gp','Bx','Pi']
ANIMAL_PATHOGENS=['Bm','Ts','Sr']
FREE_LIVING=['Ce','Cb','Pp']

ALL_PATHOGENS  = PLANT_PATHOGENS + ANIMAL_PATHOGENS + FREE_LIVING

csv_parse = lambda { |cmd|
  $stderr.print "===> Calling: #{cmd}\n"
  CSV::parse(`#{cmd}`).drop(1)
}

newvar = lambda { |type, value, tot = nil|
  print "\\newvar{#{short}#{type}}{#{value}}\n"
  if tot
    print "\\newvar{#{short}#{type}_perc}{#{value} (#{(value*100.0/tot).round(0)}\\%)}\n"
  end
}

minc_cluster_prop = {} # cluster properties
# ---- 1. Get the full list of Minc PSC in all (&)
clusters1 = csv_parse.call("env HASH=is_pos_sel1=h,count=1 ../../../scripts/sparql-csv.sh count.rq")
total_clusters = -1
clusters1.each { |c| total_clusters = c[2].to_i if c[0]==species and c[1]==source }
all1 = csv_parse.call("env species=#{species} source=#{TYPE} ../../../scripts/sparql-csv.sh count_pos_sel.rq")
all = all1.map { |l| c = l[2] ; minc_cluster_prop[c] = {} ; c }
p [:num_PSC, species, source, all.size,total_clusters]
newvar.call('',all.size,total_clusters)
# ==== all
assert((is_cds && all.size == 43) || all.size == 325) if do_assert   

# ---- 2. Annotate for Refseq homologs
catH = csv_parse.call("env HASH=\"by_cluster=1,species=#{species},source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq").flatten
# ==== catH
newvar.call('blast',catH.size,all.size)
assert(catH.size == 36,"Expect 36 was #{catH.size}") if do_cassert

newvar.call('blast_refseq',csv_parse.call("env HASH=\"by_cluster=1,species=#{species},blast=refseq,source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq").flatten.size,all.size)
newvar.call('blast_species',csv_parse.call("env HASH=\"by_cluster=1,species=#{species},blast=species,source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq").flatten.size,all.size)

# ---- 2b. Annotate plantP only (&)
#      catH contains all ann PSC. So we can select those that
#      contain only-plant matches
list1 = csv_parse.call("env HASH=\"by_gene=1,species=#{species},source1=#{TYPE}\" ../../../scripts/sparql-csv.sh blast2.rq")
# Create a hash of clusters that contain species and num
matches = list1.inject(Hash.new) { |h,a| 
  cluster = a[0]
  h[cluster] ||= {}
  match = a[1]
  h[cluster][match] = a[2]
  h
}
# p [:matches, matches]

# ---- Start annotation
ann = {}
matches.each { |cluster,ms| 
  plantp  = false
  animalp = false
  free    = false
  other   = false

  ms.keys.each { | s |
    assert(s != species)  # Make sure there is no self reference
    assert(s != 'Nema')  # Make sure there is no self reference
    if PLANT_PATHOGENS.include?(s)
      plantp = true 
    elsif ANIMAL_PATHOGENS.include?(s)
      animalp = true 
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
  elsif animalp
    ann[cluster] << :pathogen
    ann[cluster] << :animal_pathogen
  elsif plantp
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
# p [:annotated, ann.sort]

minc_cluster_plantp = ann.keys.select { |k| ann[k].include?(:plant_pathogen) }
minc_cluster_animalp = ann.keys.select { |k| ann[k].include?(:animal_pathogen) }
p [:plantP, minc_cluster_plantp.size ]
assert(minc_cluster_plantp.size == 9) if is_cds and do_assert 

newvar.call('plantp',minc_cluster_plantp.size,all.size)
newvar.call('animalp',minc_cluster_animalp.size,all.size)

minc_cluster_plantp.each { |c|
  p [c,ann[c]]
}
# ---- 2c and 2d. Annotated in ann! (&)

# ---- 3. Fetch matching PSC (catA) &
#      Cat. A - create pairs of cluster + species, the list may contain
#      references to other Mi EST clusters, but not to self
catA = csv_parse.call("env HASH=\"by_cluster=1,species1=#{species},is_pos_sel=1,source1=#{TYPE},species2=Other,is_pos_sel2=1\" ../../../scripts/sparql-csv.sh match_clusters.rq").flatten
# ==== we have catA
assert(catA.size == 10,catA.size) if is_cds and do_assert 
newvar.call('psps',catA.size,all.size)

catA_plantp = catA.map { |c|
  if ann[c]
    res = ann[c].include?(:plant_pathogen) and not ann[c].include?(:refseq)
    # p ann[c] if res
    res
  else
    false
  end
}.delete_if { |r| !r }

p catA_plantp

newvar.call('psps_plantp',catA_plantp.size,all.size)

exit

# ---- 3a catA plant only
plant_pathogenA = catA.select { |c| ann[c] and ann[c].include?(:plant_pathogen) }
p [:red, plant_pathogenA.size]
# ==== we have catA orange and red!
otherA = catA - plant_pathogenA
p [:orange, otherA.size]
assert(otherA.size == 8,otherA.size.to_s) if do_assert 

# ---- Now we can have the unique PSC (catC green) (&)
catC = all - catA - catH
p [:unique_PSC, catC.size]
assert(catC.size == 6,"Was #{catC.size}") if do_assert

assert(catA & catC == [],"There should be no overlap between catA and catC")
catB = all - catA - catC 
assert(catB.size == 27,catB.size) if do_assert

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
