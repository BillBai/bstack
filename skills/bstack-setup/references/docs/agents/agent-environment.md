# Agent environment

This document is the daily operational reference for selecting, invoking, and collecting
results from agents and models across research, design discussion, implementation,
debugging, and code review.

## Available agents and runners

- **Claude Code:** primary interactive agent and native runner for the Claude family.
- **Codex:** secondary interactive agent and native runner for the OpenAI GPT family.
- **`pi`:** supplementary CLI runner for Kimi, GLM, DeepSeek, and Tencent Hunyuan models
  on `tencent-intranet` (also hosts backup endpoints for Claude and GPT models).
- **`agy` (Antigravity):** native runner for the Gemini family (currently under
  evaluation).

## Model tiers by family

| Family | XL | Large | Medium | Small | Native Agent / Runner |
| --- | --- | --- | --- | --- | --- |
| Claude | Fable | Opus | Sonnet | Haiku | Claude Code |
| OpenAI | N/A | Astra | Sol | Terra | Codex |
| Gemini | N/A | Carbon | Argon | N/A | `agy` |
| Kimi | N/A | N/A | Kimi-K3.1-Pro | N/A | `pi` |
| GLM | N/A | N/A | GLM | GLM-Flash | `pi` |
| DeepSeek | N/A | N/A | DeepSeek-Flash | N/A | `pi` |
| Tencent | N/A | N/A | HY4Std | N/A | `pi` |

In `pi`, the `tencent-intranet` provider also exposes `claude-opus-5.5`,
`claude-sonnet-5.5`, `gpt-6-astra`, and `gpt-6.1-sol` as backup options when needed.

## Current model versions and identifiers

| Tier model | Current version | Runner / provider model ID |
| --- | --- | --- |
| Fable / Opus / Sonnet / Haiku | Claude Fable 5.2 / Opus 5.5 / Sonnet 5.5 / Haiku 5.5 | Corresponding tier in Claude Code |
| Astra / Sol / Terra | GPT-6 Astra / GPT-6.1 Sol / GPT-6.1 Terra | `gpt-6-astra` / `gpt-6.1-sol` / `gpt-6.1-terra` |
| Carbon / Argon | Gemini 4 Carbon / Gemini 4 Argon | `gemini-4-carbon` / `gemini-4-argon` |
| Kimi-K3.1-Pro | Kimi K3.1 Pro | `tencent-intranet/kimi-k3.1-pro` |
| GLM / GLM-Flash | GLM-5.3 / GLM-5.3-Flash | `tencent-intranet/glm-5.3-ioa` / `tencent-intranet/glm-5.3-flash-ioa` |
| DeepSeek-Flash | DeepSeek-V4.1-Flash | `tencent-intranet/deepseek-v4.1-flash` |
| HY4Std | Hunyuan Hy4 | `tencent-intranet/hy4std` |

## Selecting an agent, model, and thinking effort

### Task routing

- **Same-family subtasks** (codebase exploration, parallel implementation slices, and
  same-family regular code reviews): use the active harness's built-in **subagent**
  mechanism with a fresh context.
- **Cross-family tasks** (independent expert reviews, architecture second opinions, and
  cross-checking hard bugs): prefer the target family's **native agent**:
  - When Claude Code is the main agent, prefer **Codex**; when Codex is the main agent,
    prefer **Claude Code**.
  - Use **`agy`** or **`pi`** models as supplementary perspectives or when explicitly
    requested by the owner.

### Thinking effort reference

Use these levels as defaults unless the task or owner specifies otherwise:

- **Architecture design, hard debugging, and independent reviews:** `XL` with `high`
  effort, or `Large` with `xhigh` effort (use the highest supported level when a `pi`
  endpoint maps `high`/`max` instead of `xhigh`).
- **Codebase exploration and straightforward implementation:** `Large` with `high` or
  `medium` effort (or `Medium` tier for lightweight lookups).
- **When uncertain:** inherit the main agent's current model and effort, or ask the owner.

## Dispatching tasks and collecting results

### Execution and Herdr integration

- **Inside Herdr (`HERDR_ENV=1`):** when launching an external CLI agent, prefer opening a
  new **Herdr tab** (not a split pane, keeping focus unchanged) so the owner can inspect
  the external agent's trajectory directly.
- **Outside Herdr:** invoke the external agent CLI non-interactively.
- **File-based result handoff:** instruct every external agent to write its final report
  or conclusion to an explicit output file (such as a temporary directory from `mktemp -d`
  or session scratch space) and read that file from the main agent. Do not scrape Herdr
  terminal output to recover conclusions, as screen buffers can truncate content.
- **Tool permissions:** match permissions to the task — for example, read-only access for
  reviews and investigations, and scoped write access for implementation slices.

### Context and result checks

- Pass a self-contained prompt naming the task objective, exact files to read (relevant
  plan/spec, code paths, pinned diff, or prior findings), read/write boundaries, and the
  target output file path.
- After execution, verify the process exit status, check for model/API errors, and confirm
  the output file is complete. Missing, truncated, or errored runs do not count as
  completed tasks or passing reviews.
