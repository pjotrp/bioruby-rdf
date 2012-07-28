require 'bio-table/rdf'

Given /^a comma separated table$/ do |string|
  @lines = string.split(/\n/)
  @table = []
  BioTable::TableLoader.emit(@lines,in_format: :csv).each do |row|
    @table << row
  end
  @table.should == 
[["Id", "Chromosome", "Pos", "AXB1", "AXB2", "AXB4", "AXB5", "AXB6", "AXB10", "AXB12", "AXB13", "AXB15", "AXB19", "AXB23", "AXB24", "BXA1", "BXA2", "BXA4", "BXA7", "BXA8", "BXA11", "BXA12", "BXA13", "BXA14", "BXA16", "BXA24", "BXA25", "BXA26"], ["rs13475701", "1", "0", "AA", "BB", "AA", "BB", "BB", "AA", "BB", "BB", "BB", "AA", "AA", "AA", "AA", "AA", "AA", "AA", "AA", "BB", "AA", "AA", "AA", "AA", "AA", "BB", "AA"], ["rs3654377", "1", "1.46", "AA", "BB", "AA", "BB", "BB", "AA", "BB", "BB", "BB", "AA", "AA", "AA", "AA", "AA", "AA", "BB", "AA", "BB", "AA", "AA", "AA", "AA", "AA", "BB", "AA"], ["rs8237062", "1", "87.334", "AA", "AA", "BB", "BB", "BB", "BB", "BB", "BB", "AA", "H", "BB", "AA", "AA", "AA", "AA", "BB", "BB", "BB", "BB", "AA", "BB", "BB", "AA", "AA", "BB"], ["rs3669485", "1", "2.19", "AA", "BB", "AA", "BB", "BB", "AA", "BB", "BB", "BB", "AA", "AA", "AA", "AA", "AA", "BB", "BB", "AA", "BB", "AA", "AA", "AA", "AA", "AA", "BB", "AA"]]
end

When /^I load the genotype table$/ do
end

Then /^I should turn it into RDF so it contains for the table header$/ do |string|
  BioTable::TableLoader.emit(@lines,in_format: :csv).each_with_index do |row, i|
    if i==0
      rdf = BioTable::RDF.header(row)
      string.split(/\n/).each do |s|
        print s if rdf.index(s) == nil
        rdf.index(s).should_not be_nil
      end
    end
    break
  end
end

Then /^and it contains for the rows$/ do |string|
  header = nil
  rdf = []
  BioTable::TableLoader.emit(@lines,in_format: :csv).each_with_index do |row, i|
    if i==0
      header = row
    else
      rdf << BioTable::RDF.row(row,header)
    end
  end
  # rdf.each do |l|
  #   print l
  # end
  string.split(/\n/).each do |s|
    print s if rdf.index(s) == nil
    rdf.index(s).should_not be_nil
  end
end


When /^I store the RDF in a triple store$/ do
  pending # express the regexp above with the code you wish you had
end

When /^query the genotype of strain AXB(\d+) at marker rs(\d+) to be BB with$/ do |arg1, arg2, string|
  pending # express the regexp above with the code you wish you had
end

When /^query the genotype of strain AXB(\d+) to be "([^"]*)" with$/ do |arg1, arg2, string|
  pending # express the regexp above with the code you wish you had
end

When /^query marker rs(\d+) to be at location (\d+)\.(\d+) of chromosome (\d+) with$/ do |arg1, arg2, arg3, arg4, string|
  pending # express the regexp above with the code you wish you had
end


When /^I add that AXB(\d+) is a genotype with$/ do |arg1, string|
  pending # express the regexp above with the code you wish you had
end

Then /^I can directly query for the genotypes$/ do
  pending # express the regexp above with the code you wish you had
end

