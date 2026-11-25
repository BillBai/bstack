# Agent setup

This guide covers setting up a new machine or environment to work on `<project-name>`.
Daily model tiers, provider IDs, and task-routing rules are maintained in
[agent-environment.md](agent-environment.md).

## 1. Agent CLIs

Set up the primary interactive agents you use — **Claude Code**, **Codex**, and **`agy`
(Antigravity)** — along with **Cursor CLI (`agent` / `cursor-agent`)** and **`pi`** for
supplementary and backup model providers, and **`herdr`** (recommended) for launching and
observing delegated cross-family sessions in separate tabs.

Keep API credentials and authentication tokens in user-global configuration rather than
committing them to this repository. Put personal agent preferences for this repository,
such as conversation and document language, in a root `AGENTS.local.md`. Git ignores it;
start from the team's suggested defaults if the owner shares them.

## 2. Skills and helper tools

- **Required skills:** Matt Pocock's engineering skills (`grill-with-docs`, `grilling`,
  `domain-modeling`, `to-spec`, `to-tickets`, `implement`, `implement-spec`,
  `code-review`, and `tdd`), made available to every active agent harness (`codex`, `agy`,
  `claude`, and `pi`).
- **Optional helpers (not required):** **`herdr`** (terminal multiplexer for watching
  delegated agent sessions in separate tabs), `bstack`, `pstack`, and `i-have-adhd`. Keep
  shared user-level skills aligned across harnesses; note that `agy` scans
  `~/.gemini/config/skills/` globally rather than `~/.agents/skills/`, so symlink shared
  skills such as `herdr` into `~/.gemini/config/skills/` (or register `~/.agents/skills`
  in `~/.gemini/config/skills.json`).

Project-specific skill settings live in [domain.md](domain.md),
[issue-tracker.md](issue-tracker.md), and [triage-labels.md](triage-labels.md).

## 3. Agent hooks

Hook scripts live in `.agents/hooks/` as the canonical implementations. Each agent tool
keeps only a thin adapter or configuration that points at them (for example
`.claude/settings.json`, `.codex/hooks.json`, `.agents/hooks.json` for `agy`,
`.cursor/hooks.json` for Cursor CLI, and `.pi/extensions/` for `pi`), and
`.agents/hooks/README.md` lists the scripts and the adapters. A git hook in the same
directory is enabled once per clone with
`git config core.hooksPath "$(git rev-parse --show-toplevel)/.agents/hooks"`.

A recommended guard runs before each shell command and blocks git commands that discard
work or rewrite a branch: `reset --hard`, `clean` with `-f`, `checkout .` and `restore .`,
`stash drop` and `stash clear`, `branch -D`, and `push` with `--force`, `-f`,
`--force-with-lease`, or a `+refspec`. It reads only real git invocations, not git text
inside quotes, messages, or heredocs. Claude Code, Codex, and `pi` treat exit code 2 as a
denial; `agy`'s `PreToolUse` hook matches `run_command`, reads `toolCall.args.CommandLine`
from camelCase JSON input, and denies with `{"decision":"deny","reason":"..."}` on stdout,
so shared hook helpers should handle both schemas.

## 4. Reference checkouts

Clone read-only prior-art and upstream reference repositories into `../ref/` in the parent
workspace as needed; see [prior-art-and-refs.md](../guide/prior-art-and-refs.md).

## 5. Environment check

Before starting a change on a new setup, verify that:

1. Your primary agent CLIs run cleanly and can access the models listed in
   [agent-environment.md](agent-environment.md).
2. The required Matt Pocock `SKILL.md` files and templates are readable from your active
   harness.
3. Git author identity is configured for this repository.
