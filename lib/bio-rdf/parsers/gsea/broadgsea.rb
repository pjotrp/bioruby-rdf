module BioRdf
  module Parsers
    module BroadGSEA
      class ParseClsRecord
        attr_reader :classnames, :classes
        def initialize buf
          lines = buf.split("\n")
          p lines
        end
      end
    end
  end
end
