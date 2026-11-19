# Multi-family agents and simplified control (2026-11): design decisions

Status: decisions settled with the owner (2026-11-18 to 2026-11-19); skill and reference edits applied (2026-11-19).

## The task

Update `bstack-setup` and `bstack-control` to support OpenAI GPT (`codex`) and Gemini (`agy`) as primary interactive agents alongside Claude Code, treat a restricted `pi` backup channel as a low-frequency third review perspective when a native primary harness is unavailable, align `agy` hooks and Herdr dispatch mechanics, remove internal provider identifiers from this public repository, and simplify coordinator (`chief` / `control`) operation.

## Decisions

### D1. Three primary model families and runner availability

The workflow and agent references treat **OpenAI GPT (Codex)**, **Gemini (`agy`)**, and **Claude (Claude Code)** as the three primary model families. Workflow rules refer to families and tiers rather than assuming Claude Code is the primary interactive agent.

Runner availability is tracked separately from model family: when a primary family's native harness is unavailable (for example Claude Code temporarily unavailable), a restricted backup runner (`pi`) may still expose that family's models under lower quota and higher latency. A restricted backup channel is never used for interactive planning, implementation, or coordinators; it is reserved for low-frequency read-only reviews.

### D2. Model tiers and current versions (sanitized for public repository)

- **XL tier** holds only Claude `Fable`; other families start at Large.
- **Claude:** XL `Fable`, Large `Opus`, Medium `Sonnet`, Small `Haiku`.
- **OpenAI:** Large `Astra` (`gpt-6.2-astra`), Medium `Sol` (`gpt-6.2-sol`), Small `Terra` (`gpt-6.1-terra`).
- **Gemini:** Large and Medium both list `Carbon` (`gemini-4-carbon`) and `Neon` (`gemini-4-neon`) while their relative strength remains under evaluation; Small `Hydrogen` (`gemini-4-hydrogen`). `gemini-4-argon` and `gemini-3.8-flash` are retired.
- **Additional families via `pi`:** Medium `Kimi-K3.1-Pro`; Small `DeepSeek-V4.1-Flash`, `GLM-5.3`, and any project-configured supplementary models.

Internal provider names and internal deployment suffixes are removed from `bstack` templates and replaced with `<provider>` placeholders (consistent with D6 of [`bstack-control.md`](./bstack-control.md)). Consumer repositories fill in their own provider identifiers.

### D3. Tier permissions stay unchanged

Only the **Large** and **XL** tiers of the primary families implement, merge `implement-spec` work, or run regular, design, or expert reviews. Medium and Small tiers serve only read-only lightweight lookups and summaries (and coordinators impose no tier rule, see D7).

### D4. Cross-family review routing

All four operating cases (Claude main, Codex main, Gemini main, and single-family-disabled projects) reduce to two invariants and one optional switch:

1. **Expert review (post-implementation):** Large or XL tier of another available primary family at its highest supported effort (`xhigh`, or `high` for models without `xhigh`). When Claude Code and Codex are both natively available, Claude and OpenAI review each other; when Claude is restricted, OpenAI and Gemini review each other.
2. **Design review of a spec (pre-implementation):** prefer a third family that neither implements nor runs the expert review, at Large tier and its highest supported effort (Gemini when Claude is main; restricted Claude via `pi` when OpenAI or Gemini is main). When a project disables a family so only two primary families are allowed, the opposite primary family runs the design review in its own fresh-context session.
3. **Optional extra post-implementation round:** when OpenAI or Gemini is the main session and the project permits a restricted third family (such as Claude `Opus` via `pi`), the owner may request one extra review round on that third family. It never runs automatically.

Regular code review stays on the Large tier of the implementer's own family at its highest supported effort.

### D5. Cross-family dispatch through Herdr with explicit arguments

When running inside Herdr (`HERDR_ENV=1`), every cross-family dispatch (for example Codex dispatching `agy`, `agy` dispatching Codex, or either dispatching `pi`) opens a new Herdr tab (`--no-focus`) rather than invoking non-interactive print mode (`agy -p`), so the owner can observe the session directly. Non-interactive invocation is the fallback outside Herdr or in a desktop app.

Every cross-family dispatch passes explicit model, reasoning effort or thinking level, and working directory (`--cwd`).

For `agy` read-only reviews, pass `--add-dir <report-dir>` so `agy` can read pinned diff inputs and write its complete report file inside `<report-dir>` without non-workspace file-access prompts. The brief forbids editing repository files and running shell commands, and the main agent verifies afterward (`git status`) that the worktree is unchanged.

### D6. `agy` promoted to a primary harness with hook wiring

`agent-setup.md` lists `agy` alongside Codex and Claude Code as a primary interactive agent rather than optional/under evaluation. `.agents/hooks.json` is documented alongside `.claude/settings.json`, `.codex/hooks.json`, and `.pi/` as a thin hook adapter pointing at `.agents/hooks/`, noting `agy`'s `PreToolUse` schema (`run_command`, `toolCall.args.CommandLine`, and JSON deny output).

### D7. `bstack-control` simplifications

1. **No coordinator model or tier rule:** `bstack-control` no longer prescribes a Medium tier or a specific harness for coordinators. The owner picks whichever harness and model they prefer when starting a coordinator (for example `pi` on an inexpensive model to conserve primary quotas).
2. **Work-session agent choice stays with the owner:** repository configs do not hardcode the default work-session agent kind, and work sessions do not inherit the coordinator's own kind. On start (or before the first dispatch), the coordinator asks the owner which agent to use by default for that session, honors updates during the session, and still confirms the kind before each dispatch.
3. **Active mode vs. pull mode:**
   - **Active mode** (harnesses with a built-in recurring scheduler and background completion notifications, such as Claude Code or `agy`): run the Herdr wait loop and schedule periodic refreshes.
   - **Pull mode** (harnesses without them, such as `pi` or Codex): skip the wait loop and scheduled refreshes; refresh on every owner message before replying.
4. **Herdr only for now:** support for alternative terminal multiplexers is deferred.

## Files touched

- `docs/design/multi-family-agents-2026-11.md` (new)
- `skills/bstack-setup/references/docs/agents/agent-environment.md`
- `skills/bstack-setup/references/docs/agents/agent-setup.md`
- `skills/bstack-setup/references/docs/guide/workflow.md`
- `skills/bstack-setup/references/root-AGENTS.md`
- `skills/bstack-setup/SKILL.md`
- `skills/bstack-setup/workflows/migrate.md`
- `skills/bstack-control/SKILL.md`
- `skills/bstack-control/roles/chief.md`
- `skills/bstack-control/roles/control.md`
- `skills/bstack-control/references/herdr.md`
- `skills/bstack-control/references/sessions.md`
