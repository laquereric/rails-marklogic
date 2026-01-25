module Mcp
  module Doctor
    module Views
      class JustificationChain
        def initialize(answer_id:, findings:)
          @answer_id = answer_id
          @findings = findings
        end

        def to_ui_resource
          {
            id: "#{@answer_id}-chain",
            kind: "doctor.justification.chain",
            payload: {
              answer_id: @answer_id,
              steps: steps
            }
          }
        end

        private

        def steps
          @findings.sort_by { |f| f[:recorded_at] || Time.at(0) }.map do |f|
            {
              evidence_id: f[:id],
              artifact: f[:artifact],
              outcome: f[:outcome],
              reason: f[:reason]
            }
          end
        end
      end
    end
  end
end
