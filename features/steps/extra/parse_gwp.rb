require 'bio-rdf/extra/gwp'

Given /^I have a digest file with name 'Ce_CDS' and contains$/ do |string|
  @recs = BioRdf::Extra::Parsers::GWP::Digest::parse('Ce_CDS',string)
  p @recs
end

Then /^I should fetch the cluster names 'cluster(\d+)' and 'cluster(\d+)'$/ do |arg1, arg2|
  @recs['cluster00399'].should_not == nil
  @recs['cluster00400'].should_not == nil
end

Then /^for cluster (\d+)$/ do |arg1|
end

Then /^I should be able to fetch the model 'M(\d+)\-(\d+)'$/ do |arg1, arg2|
  @recs['cluster00400'][:model].should == 'M78'
end

Then /^I should be able to fetch the lnL '(\d+)\.(\d+)'$/ do |arg1, arg2|
  @recs['cluster00400'][:lnL].should == 12.4
end

Then /^I should be able to fetch sequence size as (\d+)$/ do |arg1|
  @recs['cluster00400'][:seq_size].should == 206
end

Then /^I should be able to assert it is positively selected for (\d+) sites$/ do |arg1|
  @recs['cluster00400'][:is_pos_sel].should == true
  @recs['cluster00400'][:sites].should == 6
end

Then /^I should be able to output RDF$/ do |string|
  BioRdf::Writers::Turtle::Digest::to_rdf(@recs['cluster00400']).should == string
end

Given /^I have a textual BLAST result with name 'Ce_CDS' in 'cluster(\d+)'  which contains$/ do |arg1, string|
  @recs = BioRdf::Parsers::Extra::GWP::Blast::parse('Ce_CDS',string)
  p @recs
end

Then /^I should be able fetch the Species name 'Caenorhabditis elegans'$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able fetch the gene name 'NP_(\d+)'$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able fetch the description 'Protein CDC\-(\d+)'$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able fetch the E\-value (\d+)\.(\d+)e\-(\d+)$/ do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

