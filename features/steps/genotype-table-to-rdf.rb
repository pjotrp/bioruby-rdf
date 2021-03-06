require 'bio-table/rdf'
require 'four_store/store'

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
  BioTable::TableLoader.emit(@lines,in_format: :csv).each do |row, type|
    if type == :header
      rdf = BioTable::RDF.header(row)
      string.split(/\n/).each do |s|
        s = s.strip

        print s," in ",rdf.join(' ') if rdf.index(s) == nil
        rdf.index(s).should_not be_nil
      end
      @rdf_header = rdf
    end
    break
  end
end

Then /^and it contains for the rows$/ do |string|
  header = nil
  rdf = []
  BioTable::TableLoader.emit(@lines,in_format: :csv).each do |row, type|
    if type == :header
      header = row
    else
      rdf << BioTable::RDF.row(row,header)
    end
  end
  # rdf.each do |l|
  #   print l
  # end
  string.split(/\n/).each do |s|
    s = s.strip
    if rdf.index(s) == nil
      print "EXPECTED: <",s,">\n"
      print "FOUND:    <",rdf.join("\n"),">\n"
    end
    rdf.index(s).should_not be_nil
  end
  @rdf_table = rdf
end


When /^I store the RDF in a triple store$/ do
  # db = BioRdf::RestAPI("http://localhost:8000/")
  # dp.put(@rdf_header)
  f = File.new("file.rdf","w")

  f.print "
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix : <http://biobeat.org/rdf/biotable/#ns>  .
"  
  f.print(@rdf_header.join("\n"))
  f.print(@rdf_table.join("\n"))
  f.close
  # rapper -i turtle file.rdf (raptor-utils)
  print `curl -T file.rdf -H 'Content-Type: application/x-turtle'  http://localhost:8000/data/genotype.rdf`
  # sparql-query http://localhost:8000/sparql/ 'SELECT * WHERE { ?s ?p ?o } LIMIT 10'
  # https://github.com/moustaki/4store-ruby/blob/master/lib/four_store/store.rb
end

When /^query marker "([^"]*)" to be at location "([^"]*)" of chromosome "([^"]*)" with$/ do |arg1, arg2, arg3, string|
  @store = FourStore::Store.new 'http://localhost:8000/sparql/'
  @prefix = """
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX : <http://biobeat.org/rdf/biotable/#ns> 
"""

  response = @store.select(@prefix+string)
  response.size.should == 1
end

When /^query the genotype of strain "([^"]*)" at marker "([^"]*)" to be "([^"]*)" with$/ do |arg1, arg2, arg3, string|
  response = @store.select(@prefix+string)
  response[0]["genotype"].should == "BB"
end

When /^query the genotype of strain "([^"]*)" to be "([^"]*)" with$/ do |arg1, arg2, string|
  response = @store.select(@prefix+string)
  p response
  response.map { |e| e["genotype"] }.should == ['AA','AA','AA','AA']
end

When /^I add to the store that 'AXB(\d+)' is a genotype with$/ do |arg1, string|
  # response = @store.delete('data/genotype.rdf')
  # puts response
  response = @store.add('data/genotype.rdf', "
<http://biobeat.org/rdf/biotable/#nsAXB1> rdf:type <http://biobeat.org/rdf/biotable/#nsgenotype>.
")
  puts response
end

Then /^I can directly query for the genotypes with$/ do |string|
  response = @store.select(@prefix+string)
  p response
  response.size.should > 0
end


