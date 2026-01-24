module VectorMCP
  module Server
    def self.start(*args)
      Runner.run("serve", *args)
    end

    def self.start_async(*args)
      Thread.new { start(*args) }
    end
  end
end
