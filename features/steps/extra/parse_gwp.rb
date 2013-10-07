require 'bio-rdf/extra/gwp'

Given /^I have a digest file with name 'Ce_CDS' and contains$/ do |string|
  @recs = BioRdf::Parsers::Extra::GWP::parse_digest(string)
  p @recs
end

Then /^I should fetch the cluster names 'cluster(\d+)' and 'cluster(\d+)'$/ do |arg1, arg2|
  assert_not_nil(@recs['cluster00399'])
  assert_not_nil(@recs['cluster00400'])
end

Then /^for cluster (\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to fetch the model 'M(\d+)\-(\d+)'$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to fetch the lnL '(\d+)\.(\d+)'$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to fetch sequence size as (\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to assert it is positively selected for (\d+) sites$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to output RDF$/ do |string|
  pending # express the regexp above with the code you wish you had
end

Given /^I have a textual BLAST result with name 'Ce_CDS' in 'cluster(\d+)'  which contains$/ do |arg1, string|
  pending # express the regexp above with the code you wish you had
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

