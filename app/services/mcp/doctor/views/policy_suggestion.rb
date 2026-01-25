module Mcp
  module Doctor
    module Views
      class PolicySuggestion
        def initialize(suggestion_id:, observation:, confidence:, supporting_evidence_ids: [])
          @suggestion_id = suggestion_id
          @observation = observation
          @confidence = confidence
          @supporting_evidence_ids = supporting_evidence_ids
        end

        def to_ui_resource
          {
            id: @suggestion_id,
            kind: "doctor.policy.suggestion",
            payload: {
              observation: @observation,
              confidence: @confidence
            },
            relationships: {
              supporting_evidence: @supporting_evidence_ids
            }
          }
        end
      end
    end
  end
end
