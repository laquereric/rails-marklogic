module VectorMCP
  module Docs
    def self.yard_for(tool)
      <<~YARD
        # @!method #{tool.name.gsub('-', '_')}(**args)
        #   #{tool.description}
        #   @param args [Hash]
        #   @return [Object]
      YARD
    end
  end
end
