module Mcp
  module Doctor
    class Report
      def initialize(answer_id:, findings: nil)
        @answer_id = answer_id
        @findings = findings || fetch_findings
      end

      def to_ui_resources
        evidence = authority_evidence_resources

        {
          answer_report: Views::AnswerReport.new(answer_id: @answer_id, findings: @findings).to_ui_resource,
          justification_chain: Views::JustificationChain.new(answer_id: @answer_id, findings: @findings).to_ui_resource,
          evidence: evidence,
          conflicts: conflict_resources,
          policy_suggestions: policy_suggestion_resources
        }
      end

      private

      def fetch_findings
        return [] unless defined?(MarkLogic)

        MarkLogic::Client.default.search(
          { type: :doctor_finding, answer_id: @answer_id },
          collection: "mcp-doctor-findings"
        ).map do |doc|
          # Normalize keys to symbols for downstream views
          doc.transform_keys { |k| k.to_sym rescue k }
        end
      end

      def authority_evidence_resources
        @findings.map do |finding|
          Views::AuthorityEvidence.new(
            finding_id: finding[:id],
            artifact: finding[:artifact],
            outcome: finding[:outcome],
            reason: finding[:reason],
            recorded_at: finding[:recorded_at]
          ).to_ui_resource
        end
      end

      def conflict_resources
        # Minimal conflict detection: multiple accepted artifacts across different domains (basic heuristic)
        accepted = @findings.select { |f| f[:outcome] == :accepted }
        return [] if accepted.size <= 1

        # If domains differ, flag a conflict. Domain extraction is placeholder-friendly (splits path segments).
        domains = accepted.map { |f| extract_domain(f[:artifact]) }.compact.uniq
        return [] if domains.size <= 1

        [
          Views::Conflict.new(
            conflict_id: "conflict-#{@answer_id}",
            answer_id: @answer_id,
            artifacts: accepted.map { |f| f[:artifact] },
            reason: "Multiple accepted artifacts from different domains"
          ).to_ui_resource
        ]
      end

      def policy_suggestion_resources
        # Simple heuristic: if an artifact is always rejected for this answer, suggest deprecation consideration.
        rejected = @findings.select { |f| f[:outcome] == :rejected }
        return [] if rejected.empty?

        observations = rejected.map { |f| f[:artifact] }.uniq

        observations.map do |artifact|
          evidence_ids = rejected.select { |f| f[:artifact] == artifact }.map { |f| f[:id] }.compact

          Views::PolicySuggestion.new(
            suggestion_id: "policy-#{@answer_id}-#{artifact}",
            observation: "Artifact #{artifact} is consistently rejected",
            confidence: "medium",
            supporting_evidence_ids: evidence_ids
          ).to_ui_resource
        end
      end

      def extract_domain(path)
        return nil unless path

        segments = path.split("/")
        idx = segments.index("domains")
        return nil unless idx && segments[idx + 1]

        segments[idx + 1]
      end
    end
  end
end
