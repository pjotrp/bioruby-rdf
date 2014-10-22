#! /bin/bash

# Bm_DNA  Cb_DNA  Ce_DNA  Gp_DNA  Mh_DNA  Mi_DNA  Pi_DNA  Pp_DNA  Ts_CDS
# Bx_DNA  Ce_CDS  Gp_CDS  Mh_CDS  Mi_CDS  Pi_CDS  Pp_CDS  Sr_DNA  Ts_DNA

./gen_table3.rb species=Mi source=CDS|grep newvar > vars.tex

exit 0

alias bio-table=~/izip/git/opensource/ruby/bioruby-table/bin/bio-table

for species in Bm Bx Ce Cb Gp Mi Mh Pi Pp Sr Ts ; do
# for species in Mi ; do
  for source in CDS DNA ; do
    full=${species}_$source
    fn=tmp/$full.tsv
    echo -e "type\t$full" > $fn
    ./gen_table2.rb species=$species source=$source |egrep ^cat >> $fn
  done
done
bio-table --merge tmp/*.tsv > table2.tsv
