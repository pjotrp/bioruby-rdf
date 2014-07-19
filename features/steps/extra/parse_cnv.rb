require 'bio-rdf/parsers/copy_number/codecz'

Given /^a textual output from CoDeCZ which contains$/ do |string|
  @rec = BioRdf::Parsers::CoDeCZ.parse(string.gsub(/\s+/,"\t"))
  # p @rec
end

Then /^I should get CoDeCZ RDF containing$/ do |string|
  rdf = BioRdf::Writers::Turtle::hash_to_rdf(@rec)
  print rdf
  rdf.strip.should == string.strip
end


