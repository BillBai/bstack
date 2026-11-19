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
- **Claude:** XL `Fable`, Large `Opus`, Medium `Sonnet`, Small `Haiku` (native Claude Code; limited `Opus` / `Sonnet` also available in Cursor CLI; backup in `pi`).
- **OpenAI:** Large `Astra` (`gpt-6.2-astra`), Medium `Sol` (`gpt-6.2-sol`), Small `Terra` (`gpt-6.1-terra`).
- **Gemini:** Large and Medium both list `Carbon` (`gemini-4-carbon`) and `Neon` (`gemini-4-neon`) while their relative strength remains under evaluation (`Carbon` / `Neon` also available in Cursor CLI); Small `Hydrogen` (`gemini-4-hydrogen`). `gemini-4-argon` and `gemini-3.8-flash` are retired.
- **Grok (via Cursor CLI):** Small `Grok-4.7` (`grok-4.7`). Other Cursor CLI models are unused.
- **Additional families via `pi`:** Medium `Kimi-K3.1-Pro`; Small `DeepSeek-V4.1-Flash`, `GLM-5.3`, and any project-configured supplementary models.

Internal provider names and internal deployment suffixes are removed from `bstack` templates and replaced with `<provider>` placeholders (consistent with D6 of [`bstack-control.md`](./bstack-control.md)). Consumer repositories fill in their own provider identifiers.

### D3. Tier permissions stay unchanged

Only the **Large** and **XL** tiers of the primary families implement, merge `implement-spec` work, or run regular, design, or expert reviews. Medium and Small tiers serve only read-only lightweight lookups and summaries (and coordinators impose no tier rule, see D7).

### D4. Owner-confirmed review gates and proportionality (revised 2026-11-19)

In practice, GPT-family models proved poor as automatic reviewers: they frequently raised
extreme or contrived edge cases that drove over-complicated changes and damaged
architectural clarity. Owner, 2026-11-19: "实际测试体验中，发现目前 gpt 系列的模型，作为
review 角色不是特别好，经常会找一些特别极端的场景，导致代码修改的比较复杂，破坏了架构。
因此，我想把 bstack 的工作流中的 review 模型，改为手动确认选择，是否 review，选哪个模型
review，都停下来问我和我确认。"

This replaces the earlier automatic cross-family routing table with two simpler rules:

1. **Stop before every review stage.** Before starting each of the three review stages —
   spec design review (after writing `spec.md`, before briefing), regular code review
   (after implementation tickets and local checks pass), and expert review (after regular
   review converges or is skipped) — the agent stops and asks the owner whether to run
   that review and which runner, model, and effort to use, presenting eligible Large/XL
   candidates and a recommendation. Once the owner confirms a stage and its reviewer,
   repairs and follow-up rounds within that stage proceed automatically up to its round
   limit (design: 2, regular: 3, expert: 2). If the owner skips a review, record
   `Skipped by owner` (and any stated reason) in `review.md`.
2. **Proportionality over contrived edge cases.** Reviewers must not demand complex
   defenses or workarounds for extreme, low-probability, or contrived scenarios that
   degrade architectural simplicity. When repairing a finding would noticeably complicate
   the architecture, the implementing agent must not apply it blindly; it either rejects
   the finding with clear reasoning in `review.md` or escalates the tradeoff to the owner.

### D5. Cross-family dispatch through Herdr with explicit arguments

When running inside Herdr (`HERDR_ENV=1`), every cross-family dispatch (for example Codex dispatching `agy`, `agy` dispatching Codex, or either dispatching `pi`) opens a new Herdr tab (`--no-focus`) rather than invoking non-interactive print mode (`agy -p`), so the owner can observe the session directly. Non-interactive invocation is the fallback outside Herdr or in a desktop app.

Every cross-family dispatch passes explicit model, reasoning effort or thinking level, and working directory (`--cwd`).

All review stages (spec design, regular, and expert) share one simple permission model across all five Herdr runners (`claude`, `codex`, `agy`, `cursor`, and `pi`):

- Reviewers may read repository files and run verification commands (such as read-only `git` queries or targeted builds/tests) when useful.
- The brief forbids modifying tracked repository files or leaving non-ignored untracked files (temporary build outputs and gitignored files are acceptable), and requires writing the complete report to `<report-dir>/<report>.md`.
- Herdr is used only to observe session state; the main agent always reads the full report from `<report-dir>/<report>.md` (never scraping Herdr scrollback) and verifies `git status --porcelain` is unchanged afterward.
- `agy` launches through Herdr with `--dangerously-skip-permissions` and `--add-dir <report-dir>`; `claude` remains a full first-class runner (`--model <model> --effort <level> --add-dir <report-dir> --permission-mode auto`) while the config stays ready for periods when Claude Code is unavailable; `codex` uses `-s workspace-write --add-dir <report-dir>`; `cursor` uses `--workspace <repo-dir> --add-dir <report-dir> --model <model> --trust --force`; `pi` uses `--model <provider>/<id> --thinking <level> --no-mcp`.

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
