module Mcp
  module Doctor
    module Views
      class Conflict
        def initialize(conflict_id:, answer_id:, artifacts:, reason:)
          @conflict_id = conflict_id
          @answer_id = answer_id
          @artifacts = artifacts
          @reason = reason
        end

        def to_ui_resource
          {
            id: @conflict_id,
            kind: "doctor.conflict",
            payload: {
              answer_id: @answer_id,
              artifacts: @artifacts,
              reason: @reason
            }
          }
        end
      end
    end
  end
end
