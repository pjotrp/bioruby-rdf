# encoding: utf-8
#
require 'bio'

module BioRdf
  module Parsers
    module PubMed

      module Parser

        require 'bio-logger'
        include Bio::Log

        def Parser::handle_options 
          log = LoggerPlus.new 'gsea'
          options = OpenStruct.new()
          options.author_layout = "surname+', '+initials.join('. ')+'.'"
          options.authors_join = ", "
          
          example = """
  Examples:

    bio-rdf pubmed --tabulate --search 'Prins [au] Biogem'
    bio-rdf pubmed --tabulate --search 'Pjotr Prins [au] Bio' --format-author \"surname+' '+initials.join('')\" --format-authors-join ', '
          """
          opts = OptionParser.new() do |o|
            o.banner = "Usage: #{File.basename($0)} pubmed [options] --search string"

            o.on_tail("-h", "--help", "Show help and examples") {
              print(o)
              print(example)
              exit()
            }
            o.on("--tabulate","Output tab delimited table (default)") do
              options.output = :tabulate
            end
            o.on("--search query",String,"Search query") do |query|
              options.search = query
            end
            o.on("--format-author layout",String,"Format the author field (default \"#{options.author_layout}\"") do | layout |
              options.author_layout = layout
            end
            o.on("--format-authors-join layout",String,"Format the author field (default \"#{options.authors_join}\"") do | layout |
              options.authors_join = layout
            end
            o.on("--pubmed-citations","Fetch the number of Pubmed citations for each entry") do
              options.pubmed_citations = true
            end
            o.on("--scholar-citations","Fetch the number of Google Scholar citations for each entry") do
              options.scholar_citations = true
            end
          end
          opts.parse!(ARGV)
          $stderr.print options

          pubmed_opts = {
            'maxdate' => '2022/01/01',
            'retmax' => 1000,
          }
          pubmed_default = %w{pubmed authors title journal year volume issue pages doi url medline}
          header = pubmed_default.dup
          header << 'pubmed cited' if options.pubmed_citations
          header << 'scholar cited' if options.scholar_citations

          Bio::NCBI.default_email = "bioruby@bioruby.org"
          entries = Bio::PubMed.esearch(options.search, pubmed_opts)

          print '"',header.join('","'),"\"\n"
          Bio::PubMed.efetch(entries).each do |entry|
            medline = Bio::MEDLINE.new(entry)
            reference = medline.reference
       
            content =  pubmed_default.map { | section | 
              if section == 'authors'
                formatted_authors = reference.authors.map do | author |
                  surname,first = author.split(/,\s+/,2)
                  initials = first.split(/\.\s*/)
                  eval(options.author_layout)
                end
                formatted_authors.join(options.authors_join)
              elsif section == 'url'
                if reference.url and reference.url != ''
                  reference.url
                else
                  "http://www.ncbi.nlm.nih.gov/pubmed/#{reference.pubmed}" if reference.pubmed
                end
              else
                eval("reference.#{section}") 
              end
            }
            if options.pubmed_citations
              $stderr.print "Fetching citations for ",reference.pubmed,' ',reference.title,"\n"
              Encoding.default_external = Encoding::UTF_8

              res = `lynx --dump "http://www.ncbi.nlm.nih.gov/pubmed/#{reference.pubmed}"`
              res =~ /Cited by( over)? (\d+)/
              content << $2
            end
            if options.scholar_citations
              searchfor = reference.doi
              searchfor = reference.authors[0] + ' ' + reference.title.chop if searchfor==nil or searchfor == ''
              scholar="lynx --dump \"http://scholar.google.com/scholar?q=#{searchfor}\""
              res = `#{scholar}`
              inpaper=false
              cited = nil
              title = reference.title.chop[0..30]
              res.each_line do | s |
                if !inpaper
                  begin
                    inpaper = true if s =~ /#{title}/
                  rescue RegexpError
                    $stderr.print "WARNING: regex problem with '#{title}'"
                    break
                  end
                end
                if inpaper and s =~ /Cited by (\d+)/
                  cited = $1
                  break
                end
              end
              content << cited
            end
            print '"',content.join('","'),"\"\n"
          end
        end
      end
    end
  end
end
