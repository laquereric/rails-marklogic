module Mcp
  module Doctor
    module Views
      class AuthorityEvidence
        def initialize(finding_id:, artifact:, outcome:, reason: nil, recorded_at:)
          @finding_id = finding_id
          @artifact = artifact
          @outcome = outcome
          @reason = reason
          @recorded_at = recorded_at
        end

        def to_ui_resource
          {
            id: @finding_id,
            kind: "doctor.authority.evidence",
            payload: {
              artifact: @artifact,
              outcome: @outcome,
              reason: @reason,
              recorded_at: @recorded_at
            }
          }
        end
      end
    end
  end
end
