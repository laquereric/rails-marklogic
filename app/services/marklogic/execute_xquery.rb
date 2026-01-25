module Marklogic
  class ExecuteXquery
    def self.call(xquery)
      Marklogic::Core.execute_xquery(xquery)
    end
  end
end
