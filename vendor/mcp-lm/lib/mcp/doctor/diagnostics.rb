module Mcp
  class Doctor
    module Diagnostics
      # Stub interface for MarkLogic-backed diagnostic queries

      def self.rag_justification(answer_id)
        {
          type: :rag_justification,
          answer_id: answer_id,
          documents_used: [],
          constraints_satisfied: [],
          constraints_violated: []
        }
      end

      def self.schema_drift(tool_name)
        {
          type: :schema_drift,
          tool: tool_name,
          issues: []
        }
      end
    end
  end
end
