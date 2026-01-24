module VectorMCP
  class IndexJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      VectorMCP.run("index", *args)
    end
  end

  class QueryJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      VectorMCP.run("query", *args)
    end
  end
end
