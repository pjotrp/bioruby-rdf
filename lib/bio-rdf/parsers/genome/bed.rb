module BioRdf
  module Parsers
    module Bed
      # Support for the BED format as described http://genome.ucsc.edu/FAQ/FAQformat.html#format1
      #
      # 
      # chrom - The name of the chromosome (e.g. chr3, chrY, chr2_random) or scaffold (e.g. scaffold10671).
      # chromStart - The starting position of the feature in the chromosome or scaffold. The first base in a chromosome is numbered 0.
      # chromEnd - The ending position of the feature in the chromosome or scaffold. The chromEnd base is not included in the display of the feature. For example, the first 100 bases of a chromosome are defined as chromStart=0, chromEnd=100, and span the bases numbered 0-99. 
      
      #  The 9 additional optional BED fields are:

      # name - Defines the name of the BED line. This label is displayed to the left of the BED line in the Genome Browser window when the track is open to full display mode or directly to the left of the item in pack mode.
      # score - A score between 0 and 1000. If the track line useScore attribute is set to 1 for this annotation data set, the score value will determine the level of gray in which this feature is displayed (higher numbers = darker gray). This table shows the Genome Browser's translation of BED score values into shades of gray:
      # shade 	  	  	  	  	  	  	  	  	 
      # score in range   	¿ 166 	167-277 	278-388 	389-499 	500-611 	612-722 	723-833 	834-944 	¿ 945
      # strand - Defines the strand - either '+' or '-'.
      # thickStart - The starting position at which the feature is drawn thickly (for example, the start codon in gene displays).
      # thickEnd - The ending position at which the feature is drawn thickly (for example, the stop codon in gene displays).
      # itemRgb - An RGB value of the form R,G,B (e.g. 255,0,0). If the track line itemRgb attribute is set to "On", this RBG value will determine the display color of the data contained in this BED line. NOTE: It is recommended that a simple color scheme (eight colors or less) be used with this attribute to avoid overwhelming the color resources of the Genome Browser and your Internet browser.
      # blockCount - The number of blocks (exons) in the BED line.
      # blockSizes - A comma-separated list of the block sizes. The number of items in this list should correspond to blockCount.
      # blockStarts - A comma-separated list of block starts. All of the blockStart positions should be calculated relative to chromStart. The number of items in this list should correspond to blockCount.
      # 
      FIELDS = { chr: :upcase, pos_start: :to_i, pos_end: :to_i, name: :to_s, score: :to_i, 
                 strand: :to_s, thick_start: :to_i, thick_end: :to_i, rgb: :to_s, count: :to_i, block_sizes: :to_s,
                 block_starts: :to_s }
      def Bed::parse(id,string)
        rec = {}
        values = string.strip.split(/\s/)
        if values.size < 3 or values.size > 12
          raise "Size problem (was #{values.size}, expected between 3 and 12 fields)"
        end
        FIELDS.keys.zip(values) do |a,b| 
          rec[a] = b.send(FIELDS[a]) if FIELDS[a]
        end
        rec[:chr] = rec[:chr].sub(/^CHR/,"")
        rec_id = 'bed_' + 'ch' + rec[:chr] + '_' + rec[:pos_start].to_s + '_' + rec[:pos_end].to_s
        rec[:id] = rec_id
        rec[:identifier] = id
        rec[:type] = :bed
        rec
      end
    end
  end
end

