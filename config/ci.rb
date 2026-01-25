# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Governance: Vendor immutability", "bin/check-vendor-mutations"
  step "Governance: Vendor lock", "bin/vendor-verify"
  step "Compliance: Shadow AI guard", "bin/rails test test/integration/shadow_ai_guard_test.rb"
  step "Compliance: MCP API contract", "bin/rails test test/services/mcp_api_contract_test.rb"

  step "Style: Ruby", "bin/rubocop"

  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: Importmap vulnerability audit", "bin/importmap audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  step "Tests: Rails", "bin/rails test"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"

  # Optional: Run system tests
  # step "Tests: System", "bin/rails test:system"

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  # if success?
  #   step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
  # else
  #   failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
  # end
end
