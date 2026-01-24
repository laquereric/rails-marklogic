module VectorMCP
  module API
    def self.run(*args)
      Runner.run(*args)
    end

    def self.index(*args)
      Runner.run("index", *args)
    end

    def self.query(*args)
      Runner.run("query", *args)
    end
  end
end
