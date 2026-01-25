# Agent Operations Manual

## Mission
Provide deterministic, auditable automation by running a single task per agent, scoped to approved directories, with clean handoffs back to human owners.

## Roles & Responsibilities
- **Task Author** — Defines the problem, completion criteria, and target directories.
- **Agent Runner** — Executes the task in an isolated worktree using the tooling below.
- **MCP Owner** — Reviews agent outputs, integrates results, and maintains lease hygiene.

## Workflow Overview
1. Draft a task brief (`docs/agents/templates/task_brief.md`) capturing objective, constraints, allowed directories, and handoff expectations.
2. Start an agent worktree via `bin/agent-start --task "<title>" --owner you@domain --dirs app/services,mcp`.
3. Execute the task inside the generated worktree; keep scope within declared directories.
4. Track lease metadata in `config/agent_leases.yml`; record progress and blockers in `AGENT_NOTES.md` inside the worktree.
5. When ready, open a pull request from the `agent/<slug>` branch using the agent PR template.
6. MCP owner reviews, merges, and runs `script/agent-cleanup <slug>` to retire the lease.

## Scope & Directory Rules
- Agents may only touch directories explicitly listed in the task brief and lease record.
- Vendored code (`vendor/**`) is read-only unless the brief grants an exception.
- Tests and docs adjacent to approved directories are in scope by default.

## Branch & Worktree Naming
- Branches follow `agent/<slug>` where `<slug>` is a kebab-case version of the task title.
- Worktrees live under `worktrees/<slug>` and are disposable after merge.

## Check-in Cadence
- Agents must update `AGENT_NOTES.md` at the end of each session with status and next steps.
- Long-running tasks (>1 day) require a daily async summary to the MCP owner.

## Handoff Requirements
- Clean `git status` inside the worktree.
- Updated lease entry in `config/agent_leases.yml` with `status: review`.
- Pull request description filled with the agent PR checklist.

## Incident Protocol
- If an agent touches unauthorized directories, immediately mark the lease `status: quarantined`, notify the MCP owner, and reset the worktree.
- Kill switch: set `MCP_LLM_DISABLED=true` to halt all agent LLM usage if a systemic issue is detected.

## Lease Status Lifecycle
- `active` — Agent currently executing the task.
- `review` — Work ready for MCP owner review; PR opened.
- `merged` — PR merged, awaiting cleanup.
- `retired` — Lease closed; worktree removed.
- `quarantined` — Task halted due to incident; requires owner intervention.

## References
- `bin/agent-start` — bootstraps worktrees, branches, and leases.
- `script/agent-cleanup` — retires leases and removes worktrees.
- `docs/agents/templates/task_brief.md` — canonical template for task design.
