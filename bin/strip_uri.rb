#! /usr/bin/env ruby
#
# Strip URI information from SPARQL result sets
#
# Example:
#
#   env HASH="by_gene=1,species1=Mi,source1=CDS,species2=Mi,source2=CDS" erb sparql/extra/gwp/within_set_matches.rq |~/opt/bin/sparql-query "http://localhost:8000/sparql/?soft-limit=-1" -p |./bin/strip_uri.rb

ARGF.each_line do | line |
  print line.gsub(/<http:\S+?[#]([^>]+)>/,'\1')
end
