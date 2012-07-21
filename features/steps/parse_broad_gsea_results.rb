Given /^I have a Broad GSEA results file which contains the line$/ do |string|
  @rec = BioRdf::Parsers::BroadGSEA::ParseResultRecord.new(string.gsub(/\s+/,"\t"))
end

Then /^I should be able to fetch all values as a list$/ do
  @rec.to_list.should == ["BIOCARTA_RACCYCD_PATHWAY", "25", "http://www.broadinstitute.org/gsea/msigdb/cards/BIOCARTA_RACCYCD_PATHWAY.html", "0.55588", "1.7947", "0.004149", "1", "0.647", "0.44", "0.198", "0.354", "1", "0.633"]
end

Then /^I should be able to fetch all other values \(lazily\), where$/ do
end

Then /^I should be able to the name of the geneset BIOCARTA_RACCYCD_PATHWAY$/ do
  @rec.geneset_name.should == "BIOCARTA_RACCYCD_PATHWAY"
end

Then /^I should be able to fetch the source$/ do
  @rec.source.should == "http://www.broadinstitute.org/gsea/msigdb/cards/BIOCARTA_RACCYCD_PATHWAY.html"
end

Then /^ES is (\d+)\.(\d+)$/ do |arg1, arg2|
  @rec.es.should == (arg1+'.'+arg2).to_f
end

Then /^NES is (\d+)\.(\d+)$/ do |arg1, arg2|
  @rec.nes.should == (arg1+'.'+arg2).to_f
end

Then /^p\-value is (\d+)\.(\d+)$/ do |arg1, arg2|
  @rec.nominal_p_value.should == (arg1+'.'+arg2).to_f
end

Then /^FDR is (\d+)$/ do |arg1|
  @rec.fdr.should == (arg1).to_f
end

Then /^q\-value is (\d+)\.(\d+)$/ do |arg1, arg2|
  @rec.fdr_q_value.should == (arg1+'.'+arg2).to_f
end

Then /^global p\-value is (\d+)\.(\d+)$/ do |arg1, arg2|
  @rec.global_p_value.should == (arg1+'.'+arg2).to_f
end

Then /^Median FDR is (\d+)$/ do |arg1|
  @rec.median_fdr.should == (arg1).to_f
end

# --- multi line parsing

Given /^I have a Broad GSEA results file with multiple lines$/ do
  @gsea_results = BioRdf::Parsers::BroadGSEA::ParseResultFile.new("./test/data/parsers/gsea/Run1_C2.SUMMARY.RESULTS.REPORT.0.txt")
end

Then /^I should be able to return all records with an FDR of less than (\d+)\.(\d+)$/ do |arg1, arg2|
  recs = @gsea_results.find_all { | rec | rec.fdr_q_value < 0.85 }
  recs.size.should == 70
end


