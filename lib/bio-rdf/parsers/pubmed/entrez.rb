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
          end
          opts.parse!(ARGV)
          $stderr.print options

          pubmed_opts = {
            'maxdate' => '2015/01/01',
            'retmax' => 1000,
          }
          pubmed_default = %w{pubmed authors title journal year volume issue pages doi url}

          Bio::NCBI.default_email = "bioruby@bioruby.org"
          entries = Bio::PubMed.esearch(options.search, pubmed_opts)

          print '"',pubmed_default.join('","'),"\"\n"
          Bio::PubMed.efetch(entries).each do |entry|
            medline = Bio::MEDLINE.new(entry)
            reference = medline.reference
       
            content =  pubmed_default.map { | section | 
              if section == 'authors'
                formatted_authors = reference.authors.map do | author |
                  surname,first = author.split(/,\s+/,2)
                  initials = first.split(/\.\s*/)
                  # p [surname,initials,options.author_layout]
                  # res = eval("surname+', '+initials.join(\". \")+'.'")
                  # p res
                  # res
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
            print '"',content.join('","'),"\"\n"
          end
          
        end

      end
    end
  end
end
