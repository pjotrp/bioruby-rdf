module BioRdf
  module Parsers
    module Extra
      module GWP
        def GWP::parse_digest(buf)
          lines = string.split(/\n/).map { |s| s.split(/\s+/) }
          lines
        end
      end
    end
  end
end
