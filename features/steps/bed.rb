
require 'bio-rdf/parsers/genome/bed'

Given /^a textual BED file containing$/ do |string|
  lines = string.strip.split("\n")
  @bed_rec = BioRdf::Parsers::Bed.parse("id1",lines[1].gsub(" ","\t"))
  # p @rec2
  @bed_rec[:id].should == "bed_ch22_1000_5000"
end

Then /^using the description I should get RDF containing$/ do |string|
  rdf = BioRdf::Writers::Turtle::hash_to_rdf(@bed_rec)
  # print rdf
  rdf.strip.should == string.strip

end

