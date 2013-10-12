require 'bio-rdf/extra/gwp'

Given /^I have a digest file with name 'Ce_CDS' and contains$/ do |string|
  @recs = BioRdf::Extra::Parsers::GWP::Digest::parse('Ce_CDS',string)
  # p @recs
end

Then /^I should fetch the cluster names 'cluster(\d+)' and 'cluster(\d+)'$/ do |arg1, arg2|
  @recs['cluster00399'].should_not == nil
  @recs['cluster00400'].should_not == nil
end

Then /^for cluster (\d+)$/ do |arg1|
end

Then /^I should be able fetch the cluster :Ce_CDS_cluster(\d+)$/ do |arg1|
  @recs['cluster00400'][:cluster].should == :Ce_CDS_cluster00400
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
  string.gsub!(/\\t/,"\t")
  @recs = BioRdf::Extra::Parsers::GWP::Blast::parse('Ce_CDS','cluster00400',string)
end

Then /^I should be able fetch the BLAST cluster :Ce_CDS_cluster(\d+)$/ do |arg1|
  @recs[0][:cluster].should == :Ce_CDS_cluster00400
end

Then /^I should be able fetch the Species name 'Caenorhabditis elegans'$/ do
  @recs[0][:homolog_species].should == 'Caenorhabditis elegans'
end

Then /^I should be able fetch the gene name 'NP_(\d+)'$/ do |arg1|
  @recs[0][:homolog_gene].should == 'NP_'+arg1.to_s 
end

Then /^I should be able fetch the description 'Protein CDC\-(\d+)'$/ do |arg1|
  @recs[0][:descr].should == 'Protein CDC-26, isoform c  > Protein CDC-26, isoform c' 
end

Then /^I should be able fetch the E\-value (\d+)\.(\d+)e\-(\d+)$/ do |arg1, arg2, arg3|
  @recs[0][:e_value].should == 1.76535e-89
end

Then /^I should be able to output BLAST RDF$/ do |string|
  BioRdf::Writers::Turtle::Blast::to_rdf(@recs[0]).should == string
end


