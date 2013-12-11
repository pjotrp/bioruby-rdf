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

Given /^a textual output from somaticsniper which contains$/ do |string|
  @rec2 = BioRdf::Parsers::SomaticSniper.parse("id1",string)
  p @rec2
  @rec2[:id].should == "somaticsniper_id1_ch17_63533065"
  
end

require 'bio-rdf/parsers/variant_calling/somaticsniper'

Then /^using the description in http:\/\/gmt\.genome\.wustl\.edu\/somatic\-sniper\/(\d+)\.(\d+)\.(\d+)\/documentation\.html I should get RDF containing$/ do |arg1, arg2, arg3, string|
  rdf = BioRdf::Writers::Turtle::hash_to_rdf(@rec2)
  print rdf
  rdf.strip.should == string.strip
end

