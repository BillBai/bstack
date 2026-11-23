# T3 Code as a peer host alongside Herdr (2026-11): design decisions

Status: decisions settled with the owner (2026-11-22); skill and reference edits applied (2026-11-22).

## The task

Add **T3 Code** as a first-class host alongside **Herdr** across both `bstack-setup` and `bstack-control`. Inside T3 Code, `HERDR_ENV` is unset so the `herdr` CLI and skill cannot run, while T3 Code natively exposes orchestration and thread-management tools covering all five runners (`claudeAgent`, `codex`, `antigravity`, `cursor`, and `pi`).

## Decisions

### D1. Three-path cross-family dispatch in `bstack-setup`

`skills/bstack-setup/references/docs/agents/agent-environment.md` and `agent-setup.md` treat **T3 Code** and **Herdr** as peer hosts, giving cross-family dispatch three explicit paths:

1. **Inside T3 Code** (T3 Code MCP tools available, or `T3_ACP_MCP_NODE` ACP fallback): call `orchestrator_capabilities` once per thread before the first dispatch to read live `providerInstanceId`, model IDs, and option keys; dispatch cross-family subtasks and reviews with `delegate_task` (`target: { providerInstanceId, model, options }`). Never fall back to raw non-interactive CLIs, Herdr, or native same-provider tools when dispatching another provider/model; report unavailability and stop for the owner. Start each new review round or re-check as a fresh `delegate_task` (never `t3_thread_send` into a child thread), follow the returned `next` instruction without polling, and cancel unneeded delegates with `task_cancel`.
2. **Inside Herdr (`HERDR_ENV=1`)**: open a new Herdr tab (`--no-focus`) with the existing five-runner explicit-argument launch table (`claude`, `codex`, `agy`, `cursor`, `pi`).
3. **Outside both**: invoke the target external CLI non-interactively with explicit model, effort, and working directory arguments.

All three paths share the same reviewer permission boundary (no modifications to tracked files and no non-ignored untracked files; gitignored build outputs are acceptable), `<dir>/<report>.md` file-based handoff, and post-run `git status --porcelain` verification.

### D2. Host detection and peer host references in `bstack-control`

Replace the hard `HERDR_ENV=1` gate in `skills/bstack-control/SKILL.md` with host detection:

- **T3 Code** (checked first, since the user interacts inside T3 Code when its tools or `T3_ACP_MCP_NODE` are present): load `skills/bstack-control/references/t3.md`.
- **Herdr** (`HERDR_ENV=1`): load the `herdr` skill and `skills/bstack-control/references/herdr.md`.
- **Neither**: inform the owner and stop.

Shared files (`SKILL.md`, `roles/control.md`, `roles/chief.md`, `references/{sessions,status,work-brief}.md`, `agents/openai.yaml`, and `README.md`) become host-neutral where behavior is shared, delegating host mechanics to `references/t3.md` or `references/herdr.md`.

### D3. Keep `<project>_workspace/worktrees/<name>` and bind via `existing_worktree`

In T3 Code `control` sessions, the coordinator still creates `<project>_workspace/worktrees/<name>` with `git worktree add`, symlinks gitignored `AGENTS.local.md` from the main checkout, and binds the worktree to the new top-level thread via `t3_thread_launch` with `workspaceStrategy: { type: "existing_worktree", worktreePath }`.

Reason: preserves one consistent worktree layout across T3 Code, Herdr, and `bstack-setup`'s `workflow.md` (`D7` and `D10` of [`bstack-control.md`](./bstack-control.md)), lets the owner switch between hosts on the same project without split worktree directories, and guarantees `AGENTS.local.md` visibility without requiring per-project T3 `runOnWorktreeCreate` scripts. The owner accepted this recommendation (2026-11-22).

For `chief-of-staff` outside work in T3 Code, `chief-workspace/` is registered as a T3 Code project (`t3_project_create`) and outside work sessions launch as top-level threads under that project with `workspaceStrategy: { type: "root" }`, while the brief directs notes and outputs to `work/<name>/`.

### D4. Pull-mode default in T3 Code; `schedule_task` only on owner request

T3 Code has no multi-thread background wait loop for top-level threads (`t3_thread_wait` waits synchronously on a single thread), and T3 Code's `schedule_task` jobs persist across restarts and overnight until paused or deleted.

Therefore, in T3 Code, coordinators run in **pull mode by default** across all five runners: skip wait loops and refresh immediately on every owner message or recap using `t3_thread_list`, `t3_pending_request`, `t3_thread_read`, and repository checks. Create a recurring `schedule_task` (`bindToCurrentThread: true`, deduplicated via `list_scheduled_tasks`) only when the owner explicitly asks for background periodic polling, and pause (`enabled: false`) or delete (`delete_scheduled_task`) it when no longer needed.

Reason: avoids persistent scheduled jobs consuming quota while idle or overnight, while T3 Code's sidebar already surfaces live running and waiting thread states. The owner accepted this recommendation after clarifying how `schedule_task` differs from Herdr's wait loop (2026-11-22).

### D5. Closing a work session in T3 Code archives the thread

On owner-approved cleanup of a work session created by the coordinator in T3 Code (for example after landing a change), interrupt any running turn (`t3_thread_interrupt` with `stop: true`) and archive the thread via `t3_thread_organize(action: "archive")`, paired with removing the worktree when confirmed. Reserve `t3_thread_organize(action: "settle")` for marking a thread finished without hiding it from the sidebar when the owner requests it.

Reason: matches `herdr tab close` by keeping the active sidebar focused on in-progress sessions while keeping thread history reversible via `unarchive`. The owner accepted this recommendation (2026-11-22).

## Files touched

- `docs/design/t3-code-host-2026-11.md` (new)
- `skills/bstack-setup/references/docs/agents/agent-environment.md`
- `skills/bstack-setup/references/docs/agents/agent-setup.md`
- `skills/bstack-control/references/t3.md` (new)
- `skills/bstack-control/SKILL.md`
- `skills/bstack-control/roles/control.md`
- `skills/bstack-control/roles/chief.md`
- `skills/bstack-control/references/sessions.md`
- `skills/bstack-control/references/status.md`
- `skills/bstack-control/references/work-brief.md`
- `skills/bstack-control/agents/openai.yaml`
- `README.md`
