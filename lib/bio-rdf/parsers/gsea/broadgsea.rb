module BioRdf
  module Parsers
    module BroadGSEA
      class ParseClsRecord
        attr_reader :classnames, :classes
        def initialize buf
          lines = buf.split("\n")
          raise "CLS record should be 3 lines" if lines.size != 3
          classline = lines[1]
          raise "Second line should start with #" if classline[0] != "#"
          @classnames = classline.split(/\s+/)[1..2]
          @classes = lines[2].split(/\s+/)
        end
      end
    end
  end
end
