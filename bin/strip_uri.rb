#! /usr/bin/env ruby
#
# Strip URI information from SPARQL result sets
#

ARGF.each_line do | line |
  print line.gsub(/<http:\S+?[#]([^>]+)>/,'\1')
end
