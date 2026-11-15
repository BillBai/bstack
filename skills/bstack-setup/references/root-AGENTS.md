# <project-name>

`<project-name>` is <one-sentence statement of what the project is and accomplishes>. It
contains <core components owned by this repository>:

- **`<component-1>`:** <concise responsibility and output>.
- **`<component-2>`:** <concise responsibility and output>.

See the [roadmap](docs/plans/roadmap.md) for scope and repository boundaries.

## Current Focus

**<M1 — milestone title>** is the active milestone. Read its
[milestone plan](docs/plans/m1-skeleton/milestone.md) and
[iteration plan](docs/plans/m1-skeleton/iteration-plan.md). Its iterations have not been
planned yet.

No change is currently active; the next step is M1 iteration planning with the owner.

## Required reading

Read every item that matches your task:

- **Current work:** start with **Current Focus** above and read the linked milestone
  documents.
- **Any non-trivial work:** read [workflow](docs/guide/workflow.md) and the active
  change's records under `work-docs/` when present.
- **Design discussions or naming:** read [GLOSSARY.md](GLOSSARY.md) and
  [domain documentation](docs/agents/domain.md).
- **Prior art or upstream references:** read
  [prior art and references](docs/guide/prior-art-and-refs.md).
- **Task delegation or model selection:** read
  [agent environment](docs/agents/agent-environment.md).

## Working rules

- **Workflow and stopping points.** Follow [workflow](docs/guide/workflow.md) from stage
  planning through reviews and acceptance. After implementation is approved, continue
  until a workflow stopping condition applies. Landing on `main`, pushing to a
  remote, and destructive or hard-to-reverse actions require explicit owner instruction.
- **Work records.** Record planning and design decisions in their owning document under
  `docs/plans/` or in the change's `spec.md`, execution evidence in ticket `Comments`, and
  review findings in `review.md`. Preserve verbatim owner decisions and corrections in
  their original language.
- **Ownership.** Work as the long-term maintainer of this codebase. Understand surrounding
  code and its rationale before editing it. Match design depth to the size of the change,
  avoid unneeded abstraction, and remove dead or stale material created by your edit.
- **Diagnosis.** Read the actual failure and establish its root cause before changing code.
- **Scratchpad.** Put temporary logs and throwaway experiments in session scratch space,
  never in tracked files. Retain reproducible programs that back a recorded decision as
  regression tests or under `work-docs/m<x>-i<y>-<slug>/probes/`.
- **Reference checkouts.** Keep `../ref/` checkouts in the parent workspace read-only. New
  implementation lives in this repository.
- **Agent guidance.** Edit `AGENTS.md` and `.agents/` as the canonical sources. Keep
  `CLAUDE.md` and per-tool directories (`.claude/`, `.codex/`, `.pi/`) as thin wiring, and
  preserve user-global settings.

## Writing

These rules apply to repository documents, code comments, commit messages, and owner
reports:

- Lead with the conclusion or recommendation, followed by necessary background and
  numbered points. Do not announce structure ("In short", "下面详细展开").
- Use ordinary technical terms without metaphors, idioms, or coined shorthand. Repository
  prose, code comments, and commit messages are in English; discuss work with the owner in
  Chinese. Keep verbatim owner quotes in their original language. Write natural Chinese
  without jargon such as 落地, 对齐, or 闭环, and without single-character slang verbs such
  as 崩, 挂, or 抛.
- Keep one idea per sentence and keep paragraphs short.
- Define project-specific terms in `GLOSSARY.md`. State what each cited number refers to.
- Live documents describe the current design. Historical reasoning belongs in the relevant
  decision section, `spec.md`, or ADR.
- Contrast only options that were actually raised or weighed.
- Report verification with the command or suite and passed, failed, and skipped counts.
- Ask one to three questions at a time, and ask heavy decisions alone. Give a recommended
  answer and brief reason for each question.
