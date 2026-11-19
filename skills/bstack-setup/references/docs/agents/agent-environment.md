# Agent environment

This document is the daily operational reference for selecting, invoking, and collecting
results from agents and models across research, design discussion, implementation,
debugging, and code review. [The workflow](../guide/workflow.md) names a role and a tier;
this document maps them to a family, runner, model ID, and reasoning effort.

## Available agents and runners

- **Codex:** primary interactive agent and native runner for the OpenAI GPT family.
- **`agy` (Antigravity):** primary interactive agent and native runner for the Gemini
  family.
- **Claude Code:** primary interactive agent and native runner for the Claude family (when
  natively available).
- **`pi`:** interactive agent and CLI runner for additional model families and for
  restricted backup endpoints (such as Claude when Claude Code is unavailable).
- **Herdr:** terminal multiplexer. When `HERDR_ENV=1`, cross-family agents run in their
  own Herdr tab so the owner can inspect their sessions directly.

A change's **model family** is the family of the model it runs on (Claude, OpenAI, or
Gemini), not the harness. In `pi`, the selected model determines the family. Review rules
compare model families.

## Runner availability and project policy

Configure this section per repository to match the current environment and project rules:

- **Primary available families:** OpenAI (Codex) and Gemini (`agy`); add Claude (Claude
  Code) when natively available.
- **Restricted backup channels:** when a primary family's native harness is unavailable,
  `pi` may provide a backup endpoint with lower quota and higher latency (for example
  `<provider>/claude-opus-5.5`). A restricted backup channel is never used for interactive
  planning, implementation, regular reviews, or coordinators; reserve it for low-frequency
  read-only reviews.
- **Disabled families:** if a project forbids a family by policy (for example a no-Claude
  project), state that restriction here; review routing then uses only the permitted
  families.

## Model tiers by family

The workflow names a tier, not a model version. Only Claude has an XL tier (`Fable`); all
other families start at Large.

| Family | XL | Large | Medium | Small | Native Agent / Runner |
| --- | --- | --- | --- | --- | --- |
| Claude | Fable | Opus | Sonnet | Haiku | Claude Code (restricted backup: `pi`) |
| OpenAI | N/A | Astra | Sol | Terra | Codex |
| Gemini | N/A | Carbon, Neon | Carbon, Neon | Hydrogen | `agy` |
| Kimi | N/A | N/A | Kimi-K3.1-Pro | N/A | `pi` |
| DeepSeek | N/A | N/A | N/A | DeepSeek-Flash | `pi` |
| GLM | N/A | N/A | N/A | GLM | `pi` |

`Carbon` and `Neon` both cover Gemini's Large and Medium slots while their relative
strength is being evaluated. Add any additional project-configured `pi` families to this
table when used.

## Current model versions and identifiers

Update this table when model versions change; the rest of the workflow names tiers only.
Replace `<provider>` with your configured `pi` provider name.

| Tier model | Current version | Runner / provider model ID |
| --- | --- | --- |
| Fable / Opus / Sonnet / Haiku | Claude Fable 5.2 / Opus 5.5 / Sonnet 5.5 / Haiku 5.5 | Native tiers in Claude Code (backup via `pi`: `<provider>/claude-opus-5.5`, `<provider>/claude-sonnet-5.5`) |
| Astra / Sol / Terra | GPT-6.2 Astra / GPT-6.2 Sol / GPT-6.1 Terra | `gpt-6.2-astra` / `gpt-6.2-sol` / `gpt-6.1-terra` |
| Carbon / Neon / Hydrogen | Gemini 4 Carbon / Gemini 4 Neon / Gemini 4 Hydrogen | `gemini-4-carbon` / `gemini-4-neon` / `gemini-4-hydrogen` |
| Kimi-K3.1-Pro | Kimi K3.1 Pro | `<provider>/kimi-k3.1-pro` |
| DeepSeek-Flash | DeepSeek-V4.1-Flash | `<provider>/deepseek-v4.1-flash` |
| GLM | GLM-5.3 | `<provider>/glm-5.3` |

In `agy`, `gemini-4-neon` and `gemini-4-hydrogen` support `low`, `medium`, `high`, and
`xhigh`, while `gemini-4-carbon` supports `low`, `medium`, and `high`. In `pi`, pass
`<provider>/<id>` with `--thinking <level>` or the `<provider>/<id>:<level>` suffix.

## Selecting an agent, model, and thinking effort

### Roles

- **Implementation and code review:** only the **Large** and **XL** tiers of the primary
  families (Claude, OpenAI, Gemini) implement, merge `implement-spec` work, or run
  regular, design, or expert reviews. A family on a restricted backup runner does not
  implement or run regular reviews.
- **Regular code review:** Large tier of the implementer's own family at its highest
  supported effort (`xhigh`, or `high` for `gemini-4-carbon`).
- **Expert review (post-implementation):** Large or XL tier of another available primary
  family at its highest supported effort:
  - When Claude Code and Codex are both natively available: Claude and OpenAI review each
    other.
  - When Claude Code is unavailable (OpenAI + Gemini primary mode): OpenAI (Codex) and
    Gemini (`agy`) review each other.
  - **Optional extra round:** when OpenAI or Gemini is the main session and the project
    permits a restricted third family (such as Claude `Opus` via `pi`), the owner may
    request one extra post-implementation review round on that third family. It never runs
    automatically.
- **Design review of a spec (pre-implementation):** prefer a third family that neither
  implements nor runs the expert review, at Large tier and its highest supported effort:
  - Claude main session: Gemini (`agy`).
  - OpenAI or Gemini main session: restricted Claude (`Opus` via `pi`), unless project
    policy disables Claude.
  - Projects limited to two families (for example no-Claude projects): the opposite
    primary family runs the design review in its own fresh-context session.
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
  same-family regular code reviews): use the active harness's built-in **subagent**
  mechanism with a fresh context.
- **Cross-family tasks** (design reviews, expert reviews, architecture second opinions,
  and cross-checking hard bugs): invoke the target family's native agent (Codex for
  OpenAI, `agy` for Gemini, Claude Code for Claude), or `pi` when that family is only
  available through a restricted backup provider.

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

When a workflow-authorized stage assigns a `pi` model in this document (such as a spec
design review on a restricted backup channel), authorizing that stage authorizes the `pi`
run.

For ad-hoc lightweight tasks or unexpected harness fallbacks from Codex, `agy`, or Claude
Code, ask the owner before the first `pi` run; the permission covers the scope the owner
states (one task, the session, or the change). When the main agent runs in `pi`, it uses
`pi` without asking.

When a stage's native harness is unavailable and `pi` stands in as a fallback on the same
tier and family, the task, its read-only or writing mode, its round limits, and its pass
conditions stay the same. Record the unavailable harness, the reason, and the `pi` model
and effort that ran (for a review, in `review.md`).

### Unavailable models

Before dispatch, confirm that the runner accepts the requested model and effort; after the
run, confirm the model the run reports. When a required model is unavailable, report it
and record any substitution. Do not substitute silently, and do not count the missing
step as passed. For the design review, the owner decides the substitute.

## Dispatching tasks and collecting results

### Execution and Herdr integration

- **Inside Herdr (`HERDR_ENV=1`):** for every cross-family dispatch (for example Codex
  dispatching `agy`, `agy` dispatching Codex, or either dispatching `pi`), open a new
  **Herdr tab** (`--no-focus`, not a split pane) so the owner can inspect the external
  agent's session directly. Do not fall back to print mode (`agy -p`) when Herdr is
  available.
- **Explicit launch arguments:** always specify the working directory (`--cwd`), model,
  and reasoning effort or thinking level explicitly rather than relying on user defaults.
- **Outside Herdr (or in a desktop app):** invoke the external agent CLI non-interactively
  with the same explicit model, effort, and directory arguments.
- **File-based result handoff:** export pinned inputs (diff, commit list) to a temporary
  directory outside the repository (`<dir>`, such as from `mktemp -d`), instruct the
  reviewer to write its complete report to an explicit file in `<dir>`, and read that file
  from the main agent. Do not rely on terminal scrollback alone when a report file can be
  written.

### Harness-specific read-only review notes

- **Codex (`--kind codex`):** launch via Herdr with explicit working directory, model,
  reasoning effort, and read-only sandbox:

  ```sh
  herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd <repo-dir> --label <label> --no-focus
  herdr agent start <name> --kind codex --pane <root-pane> -- \
    -C <repo-dir> -m <model> -c model_reasoning_effort="<level>" -s read-only
  ```

  Because `-s read-only` blocks writes, collect the complete report from the session
  output into `<dir>/<report>.md` (or write `<dir>/<report>.md` with a non-interactive
  `codex exec -o <dir>/<report>.md` fallback outside Herdr).
- **`agy` (`--kind agy`):** `agy` has no strict read-only tool mode (its plan mode keeps
  edit and shell tools). Launch via Herdr with explicit working directory, model, effort,
  and `--add-dir <dir>`:

  ```sh
  herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd <repo-dir> --label <label> --no-focus
  herdr agent start <name> --kind agy --pane <root-pane> -- \
    --model <model> --effort <level> --add-dir <dir>
  ```

  Confirm the exact model ID and `--effort` combination accepted by `agy models`.
  `--add-dir <dir>` lets `agy` read pinned inputs and write its report file inside `<dir>`
  without triggering non-workspace file-access prompts. The brief must forbid editing
  repository files and running shell commands, and the main agent verifies afterward
  (`git status`) that the worktree is unchanged.
- **`pi` (`--kind pi`):** launch via Herdr with explicit working directory, model,
  thinking level, and read-only tools:

  ```sh
  herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd <repo-dir> --label <label> --no-focus
  herdr agent start <name> --kind pi --pane <root-pane> -- \
    --model <provider>/<id> --thinking <level> --tools read,grep,find,ls --no-mcp
  ```

  This guarantees strict read-only execution (no shell, no file edits). Pass pinned diff
  and commit-list file paths in the brief, and save the complete answer into
  `<dir>/<report>.md` from the captured output (verify completeness before accepting).

### Context and result checks

- Pass a self-contained prompt naming the task objective, exact files to read (relevant
  plan/spec, code paths, pinned diff, or prior findings), read/write boundaries, and the
  target output file path.
- Match tool permissions to the task — read-only access for reviews and investigations,
  and scoped write access for implementation slices.
- After execution, verify the process exit status, check for model/API errors, confirm the
  worktree is unchanged after read-only runs, and confirm the report is complete. Missing,
  truncated, or errored runs do not count as completed tasks or passing reviews.
