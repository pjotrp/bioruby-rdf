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

