# Agent environment

This document is the daily operational reference for selecting, invoking, and collecting
results from agents and models across research, design discussion, implementation,
debugging, and code review. [The workflow](../guide/workflow.md) names a role and a tier;
this document maps them to a family, runner, model ID, and reasoning effort.

## Available agents and runners

- **Claude Code:** primary interactive agent and native runner for the Claude family.
- **Codex:** primary interactive agent and native runner for the OpenAI GPT family.
- **`agy` (Antigravity):** primary interactive agent and native runner for the Gemini
  family.
- **Cursor CLI (`agent` / `cursor-agent`):** supplementary interactive and review runner
  exposing limited Claude (`opus` / `sonnet`) and Gemini 4 (`carbon` / `neon`) models
  plus `grok-4.7`.
- **`pi`:** interactive agent and CLI runner for additional model families and for
  restricted backup endpoints (such as Claude when Claude Code is unavailable).
- **Herdr:** terminal multiplexer. When `HERDR_ENV=1`, cross-family agents run in their
  own Herdr tab so the owner can inspect their sessions directly.

A change's **model family** is the family of the model it runs on (Claude, OpenAI, or
Gemini), not the harness. In `pi` and Cursor CLI, the selected model determines the
family. Review rules compare model families.

## Runner availability and project policy

Configure this section per repository to match the current environment and project rules:

- **Primary families:** Claude (Claude Code), OpenAI (Codex), and Gemini (`agy`). Keep
  the repository ready to operate cleanly when any single primary harness (such as Claude
  Code) is temporarily unavailable.
- **Restricted or limited channels:** when a primary harness is unavailable, `pi` or
  Cursor CLI may provide limited-quota or higher-latency endpoints for that family (for
  example `<provider>/claude-opus-5.5` in `pi`, or `claude-opus-5-5` in Cursor CLI).
  Restricted channels are not used for routine interactive planning, implementation, or
  coordinators; reserve them for owner-selected reviews or targeted tasks.
- **Disabled families:** if a project forbids a family by policy (for example a no-Claude
  project), state that restriction here; review candidates then exclude that family across
  every runner (`claude`, `cursor`, and `pi`).

## Model tiers by family

The workflow names a tier, not a model version. Only Claude has an XL tier (`Fable`); all
other families start at Large.

| Family | XL | Large | Medium | Small | Native Agent / Runner |
| --- | --- | --- | --- | --- | --- |
| Claude | Fable | Opus | Sonnet | Haiku | Claude Code (also limited in Cursor CLI; backup in `pi`) |
| OpenAI | N/A | Astra | Sol | Terra | Codex |
| Gemini | N/A | Carbon, Neon | Carbon, Neon | Hydrogen | `agy` (Carbon / Neon also limited in Cursor CLI) |
| Grok | N/A | N/A | N/A | Grok-4.7 | Cursor CLI |
| Kimi | N/A | N/A | Kimi-K3.1-Pro | N/A | `pi` |
| DeepSeek | N/A | N/A | N/A | DeepSeek-Flash | `pi` |
| GLM | N/A | N/A | N/A | GLM | `pi` |

`Carbon` and `Neon` both cover Gemini's Large and Medium slots while their relative
strength is being evaluated. In Cursor CLI, only `claude-opus-5-5`, `claude-sonnet-5-5`,
`gemini-4-carbon`, `gemini-4-neon`, and `grok-4.7` are used; other Cursor models are
excluded. Add any additional project-configured `pi` families to this table when used.

## Current model versions and identifiers

Update this table when model versions change; the rest of the workflow names tiers only.
Replace `<provider>` with your configured `pi` provider name.

| Tier model | Current version | Runner / provider model ID |
| --- | --- | --- |
| Fable / Opus / Sonnet / Haiku | Claude Fable 5.2 / Opus 5.5 / Sonnet 5.5 / Haiku 5.5 | Claude Code: `fable` / `opus` / `sonnet` / `haiku`; Cursor CLI: `claude-opus-5-5-<effort>` / `claude-sonnet-5-5-<effort>`; `pi` backup: `<provider>/claude-opus-5.5` / `<provider>/claude-sonnet-5.5` |
| Astra / Sol / Terra | GPT-6.2 Astra / GPT-6.2 Sol / GPT-6.1 Terra | Codex: `gpt-6.2-astra` / `gpt-6.2-sol` / `gpt-6.1-terra` |
| Carbon / Neon / Hydrogen | Gemini 4 Carbon / Gemini 4 Neon / Gemini 4 Hydrogen | `agy` / Cursor CLI: `gemini-4-carbon` / `gemini-4-neon` / `gemini-4-hydrogen` (Cursor CLI uses `<id>-<effort>`, Carbon / Neon only) |
| Grok-4.7 | Grok 4.7 | Cursor CLI: `grok-4.7-<effort>` |
| Kimi-K3.1-Pro | Kimi K3.1 Pro | `pi`: `<provider>/kimi-k3.1-pro` |
| DeepSeek-Flash | DeepSeek-V4.1-Flash | `pi`: `<provider>/deepseek-v4.1-flash` |
| GLM | GLM-5.3 | `pi`: `<provider>/glm-5.3` |

In `agy`, `gemini-4-neon` and `gemini-4-hydrogen` support `low`, `medium`, `high`, and
`xhigh`, while `gemini-4-carbon` supports `low`, `medium`, and `high`. In `pi`, pass
`<provider>/<id>` with `--thinking <level>` or the `<provider>/<id>:<level>` suffix. In
Cursor CLI, model IDs encode effort (for example `claude-opus-5-5-xhigh`,
`gemini-4-neon-xhigh`, `grok-4.7-high`).

## Selecting an agent, model, and thinking effort

### Roles

- **Eligibility for implementation and code review:** only the **Large** and **XL** tiers
  of the primary families (Claude, OpenAI, Gemini) implement, merge `implement-spec` work,
  or run regular, design, or expert reviews. Restricted channels (`pi` backup or limited
  Cursor CLI models) do not replace primary interactive development; use them only when
  the owner selects them.
- **Review selection (always owner-confirmed):** never start a review stage or pick a
  reviewer model automatically. Before each of the three review stages — **spec design
  review**, **regular code review**, and **expert review** — stop and ask the owner
  whether to run it and which eligible runner, model, and effort to use:
  - Present the available Large/XL candidates permitted by project policy (respecting any
    disabled family), with a recommendation and brief reason.
  - For design review and expert review, prefer a family other than the implementer's when
    making a recommendation; the implementer never acts as its own expert reviewer.
  - Note practical reviewer tradeoffs when recommending (for example avoiding models that
    tend to over-engineer extreme edge cases at the cost of architectural simplicity
    unless the owner explicitly wants that check).
  - Once the owner confirms a stage and its reviewer, follow-up rounds within that stage
    use the confirmed model up to the workflow's round limit. If the owner skips a stage,
    record `Skipped by owner` in `review.md`.
- **Lightweight tasks:** the Medium or Small tier may locate code and documents, look up
  facts in reference checkouts or upstream documentation, read a long build log and point
  to the failing step, or summarize reference source with file and line citations. A
  lightweight task reads and reports only: it does not edit the repository, commit, or
  run a review or gate, and it does not replace the main agent's diagnosis. Its output is
  a lead; the main agent checks the cited files and lines before relying on it.

### Task routing

- **Main session choice:** the owner chooses which primary agent runs each work session at
  start; do not hardcode a single work-session agent in project documentation.
- **Same-family subtasks** (codebase exploration, parallel implementation slices, and
  same-family regular code reviews when the owner picks the main family): use the active
  harness's built-in **subagent** mechanism with a fresh context.
- **Cross-family tasks** (reviews where the owner picks another family, architecture
  second opinions, and cross-checking hard bugs): invoke the target family's native agent
  (Claude Code for Claude, Codex for OpenAI, `agy` for Gemini), or Cursor CLI / `pi` when
  chosen by the owner or when a native harness is unavailable.

### Thinking effort reference

Use these levels as defaults unless the task or owner specifies otherwise:

- **Architecture design, hard debugging, and all reviews (design, regular, expert):** `XL`
  with `high` effort, or `Large` with `xhigh` effort (use the model's highest supported
  level when `xhigh` is unavailable, such as `high` for `gemini-4-carbon`, or `high`/`max`
  on a `pi` endpoint).
- **Codebase exploration and straightforward implementation:** `Large` with `high` or
  `medium` effort (or `Medium`/`Small` for read-only lightweight lookups).
- **When uncertain:** inherit the main agent's current model and effort, or ask the owner.

### Permission for `pi` runs

When the owner explicitly selects a `pi` model during review confirmation, that choice
authorizes the `pi` run without a second permission prompt.

For ad-hoc lightweight tasks or unexpected harness fallbacks from Claude Code, Codex,
`agy`, or Cursor CLI, ask the owner before the first `pi` run; the permission covers the
scope the owner states (one task, the session, or the change). When the main agent runs in
`pi`, it uses `pi` without asking.

When a stage's native harness is unavailable and `pi` stands in as a fallback on the same
tier and family, the task, its boundaries, its round limits, and its pass conditions stay
the same. Record the unavailable harness, the reason, and the `pi` model and effort that
ran (for a review, in `review.md`).

### Unavailable models

Before dispatch, confirm that the runner accepts the requested model and effort; after the
run, confirm the model the run reports. When a confirmed model is unavailable, report it
and let the owner decide the substitute. Do not substitute silently, and do not count the
missing step as passed.

## Dispatching tasks and collecting results

### Execution and Herdr integration

- **Inside Herdr (`HERDR_ENV=1`):** for every cross-family dispatch (for example Codex
  dispatching `agy`, `agy` dispatching Codex, or any harness dispatching `claude`,
  `cursor`, or `pi`), open a new **Herdr tab** (`--no-focus`, not a split pane) so the
  owner can inspect the external agent's session directly. Do not fall back to print mode
  (such as `agy -p`) when Herdr is available.
- **Explicit launch arguments:** always specify the working directory (`--cwd`), model,
  and reasoning effort or thinking level explicitly rather than relying on user defaults.
- **Outside Herdr (or in a desktop app):** invoke the external agent CLI non-interactively
  with the same explicit model, effort, and directory arguments.
- **File-based result handoff (always, never screen-scraping):** export pinned inputs
  (diff, commit list) to a temporary directory outside the repository (`<dir>`, such as
  from `mktemp -d`), and instruct **every** Herdr-launched reviewer to write its complete
  report to `<dir>/<report>.md`. Use Herdr (`herdr agent wait` / `read`) only to monitor
  session state (`working`, `idle`, `blocked`, `done`), and always read the complete
  review report from `<dir>/<report>.md` rather than scraping Herdr terminal scrollback.

### Unified reviewer permissions and Herdr launch table

All review stages (spec design, regular, and expert) share one simple permission model
across every harness:

- Reviewers may read repository files and run shell commands (such as read-only `git`
  queries, binary inspection, or targeted builds and tests) when useful to verify a
  concern.
- **Repository boundary:** reviewers must **not** modify tracked repository files or leave
  non-ignored untracked files; the complete report goes to `<dir>/<report>.md`. Temporary
  build artifacts and gitignored files are acceptable.
- **Verification:** repository `.agents/hooks/` guards block destructive git commands;
  after the review finishes, the main agent verifies `git status --porcelain` is unchanged
  (which automatically ignores gitignored build artifacts) and reads `<dir>/<report>.md`.

Open the tab first:

```sh
herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd <repo-dir> --label <label> --no-focus
```

Then start the chosen reviewer in `<root-pane>`:

| Runner (`--kind`) | Arguments after `herdr agent start <name> --kind <kind> --pane <root-pane> --` |
| --- | --- |
| `claude` | `--model <model> --effort <level> --add-dir <dir> --permission-mode auto` |
| `codex` | `-C <repo-dir> -m <model> -c model_reasoning_effort="<level>" -s workspace-write --add-dir <dir>` |
| `agy` | `--model <model> --effort <level> --add-dir <dir> --dangerously-skip-permissions` |
| `cursor` | `--workspace <repo-dir> --add-dir <dir> --model <model> --trust --force` |
| `pi` | `--model <provider>/<id> --thinking <level> --no-mcp` |

Confirm the exact model ID and effort syntax accepted by each installed CLI (`agy models`,
`agent models`, `pi --list-models`).

### Context and result checks

- Pass a self-contained prompt naming the task objective, exact files to read (relevant
  plan/spec, code paths, pinned diff, or prior findings), the repository non-modification
  boundary, and the target report path `<dir>/<report>.md`.
- After execution, verify the session completed without model/API errors, confirm
  `git status --porcelain` is unchanged, and confirm `<dir>/<report>.md` is complete.
  Missing, truncated, or errored runs do not count as completed tasks or passing reviews.
