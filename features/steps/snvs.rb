require 'bio-rdf/parsers/variant_calling/varscan2'

Given /^a textual output from somatic\.hc which contains$/ do |string|
  @rec = BioRdf::Parsers::Varscan2::ProcessSomatic.parse("id1",string)
  p @rec
  @rec[:id].should == "id1"
end

Then /^using the description in http:\/\/varscan\.sourceforge\.net\/somatic\-calling\.html I should get RDF containing$/ do |string|
  pending # express the regexp above with the code you wish you had
end


