require 'bio-rdf/parsers/variant_calling/varscan2'

Given /^a textual output from somatic\.hc which contains$/ do |string|
  @rec = BioRdf::Parsers::Varscan2::ProcessSomatic.parse("id1",string)
  # p @rec
  @rec[:id].should == "varscan2_id1_ch17_3655022"
  
end

Then /^using the description in http:\/\/varscan\.sourceforge\.net\/somatic\-calling\.html I should get RDF containing$/ do |string|
  rdf = BioRdf::Writers::Turtle::hash_to_rdf(@rec)
  # print rdf
  rdf.strip.should == string.strip
end


