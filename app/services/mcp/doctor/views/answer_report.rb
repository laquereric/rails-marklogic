module Mcp
  module Doctor
    module Views
      class AnswerReport
        def initialize(answer_id:, findings:)
          @answer_id = answer_id
          @findings = findings
        end

        def to_ui_resource
          {
            id: @answer_id,
            kind: "doctor.answer.report",
            payload: {
              answer_id: @answer_id,
              confidence: confidence_score,
              summary: summary_text
            },
            relationships: {
              accepted_evidence: accepted_ids,
              rejected_evidence: rejected_ids
            }
          }
        end

        private

        def accepted_ids
          @findings.select { |f| f[:outcome] == :accepted }.map { |f| f[:id] }.compact
        end

        def rejected_ids
          @findings.select { |f| f[:outcome] == :rejected }.map { |f| f[:id] }.compact
        end

        def confidence_score
          base = 1.0
          base -= rejected_ids.count * 0.2
          base = 0.0 if base < 0.0
          base.round(2)
        end

        def summary_text
          "Answer #{@answer_id} diagnosed with #{accepted_ids.count} accepted and #{rejected_ids.count} rejected artifacts"
        end
      end
    end
  end
end
