Given /^I have a CLS file which contains$/ do |buf|
  @rec = BioRdf::Parsers::BroadGSEA::ParseClsRecord.new(buf)
end

Then /^I should fetch the phenotype names RS(\d+) and RS(\d+)_(\d+)$/ do |arg1, arg2, arg3|
  @rec.classnames.should == ['RS13482013','RS13482013_1']
end

Then /^I should be able to fetch the classes into an array$/ do
  @rec.classes.should == ['0','0']
end

