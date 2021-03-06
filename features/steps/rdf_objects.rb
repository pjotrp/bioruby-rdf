When /^I create a string literal$/ do
end

Then /^I should escape quotes as in$/ do |table|
  # table is a Cucumber::Ast::Table
  table.raw.each do | row |
    BioRdf::Turtle::stringify_literal(row[0]).should == row[1]  
  end
end

Then /^I should escape single slashes as in 'a \\ slash'$/ do
  # puts 'a \ slash'
  # puts 'a \\ slash'
  # puts 'a \\\\ slash'
  BioRdf::Turtle::stringify_literal('a \\ slash').should == 'a \\\\ slash'
  BioRdf::Turtle::stringify_literal('a \\\\ slash').should == 'a \\\\ slash'
end

Then /^I should escape special characters as defined in http:/ do 
  pending # express the regexp above with the code you wish you had
end

Given /^an RDF container$/ do
end

When /^I create a Turtle shorthand URI reference object in the default name space$/ do
end

Then /^it should allow identifiers$/ do |string|
  string.split("\n").each do |id|
    BioRdf::Turtle::identifier(id)  # throws no exception
  end
end

Then /^it should not allow identifiers$/ do |string|
  string.split("\n").each do |id|
    expect { BioRdf::Turtle::identifier(id) }.to raise_error
  end
end

When /^a Turtle identifiers contains invalid letters$/ do
end

Then /^I have the option to mangle them\. First begets second:$/ do |table|
  table.raw.each do | row |
    BioRdf::Turtle::mangle_identifier(row[0]).should == row[1]  
  end
end

