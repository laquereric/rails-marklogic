module VectorMCP
  module Audit
    def self.log(tool:, args:, result: nil)
      Rails.logger.info(
        "[VectorMCP] tool=#{tool} args=#{args.inspect} result=#{result&.class}"
      ) if defined?(Rails)
    end
  end
end
