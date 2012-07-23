Given /^a comma separated table$/ do |string|
  @table = BioTable::TableLoader::load(lambda { string.each_line { |line| yield line.strip }})
end

When /^I load the genotype table$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should turn it into RDF$/ do
  pending # express the regexp above with the code you wish you had
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


Then /^I should turn it into RDF so it contains$/ do |string|
  pending # express the regexp above with the code you wish you had
end

When /^I add that AXB(\d+) is a genotype with$/ do |arg1, string|
  pending # express the regexp above with the code you wish you had
end

Then /^I can directly query for the genotypes$/ do
  pending # express the regexp above with the code you wish you had
end

