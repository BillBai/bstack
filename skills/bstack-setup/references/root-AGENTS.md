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

- **Always:** read `AGENTS.local.md` at the repository root when it exists. It is
  gitignored and holds each member's personal rules on any topic, such as conversation
  language and how to explain and report. It cannot relax the working rules below.
- **Current work:** start with **Current Focus** above and read the linked milestone
  documents.
- **Any non-trivial work:** read [workflow](docs/guide/workflow.md) and the active
  change's records under `work-docs/` when present.
- **Architecture, design, or invariants:** read
  [the architecture](docs/arch/architecture.md).
- **Design discussions or naming:** read [GLOSSARY.md](GLOSSARY.md) and
  [domain documentation](docs/agents/domain.md).
- **Prior art or upstream references:** read
  [prior art and references](docs/guide/prior-art-and-refs.md).
- **Task delegation or model selection:** read
  [agent environment](docs/agents/agent-environment.md).
- **Agent hooks or hook wiring:** read `.agents/hooks/README.md` when the repository
  has hooks.

## Working rules

- **Workflow and stopping points.** Follow [workflow](docs/guide/workflow.md) from stage
  planning through reviews and acceptance. After implementation is approved, continue
  until a workflow stopping condition applies. Once the current change's implementation
  is approved, the next change may plan in its own session; its code waits until the
  current change lands unless the owner approves parallel implementation. Pushing a
  working branch (normal push, never force) to trigger CI needs no confirmation. Integrating into or pushing `main`,
  force-pushing, deleting remote refs, and other destructive or hard-to-reverse actions
  require explicit owner instruction.
- **Work records.** Record planning and design decisions in their owning document under
  `docs/plans/` or in the change's `spec.md`, execution evidence in ticket `Comments`, and
  review findings in `review.md`. Preserve verbatim owner decisions and corrections in
  their original language. A change's stage lives only in its spec's Status and Stage
  lines; Current Focus routes and carries no stage text.
- **Ownership.** Work as the engineer who owns this codebase and will maintain it for
  years. Understand the surrounding code and the reasons behind it before changing it.
  Prefer the design that stays clear and easy to change over the one that is quickest to
  write. Leave what you touch at least as readable as you found it, and remove what your
  change makes dead or stale. This is judgment, not a checklist: match the depth of
  design to the size of the change, and treat abstraction beyond what the change needs as
  unneeded code.
- **Diagnosis.** Read the actual failure and establish its root cause before changing code.
- **Scratchpad.** Put temporary logs and throwaway experiments in session scratch space,
  never in tracked files. Retain reproducible programs that back a recorded decision as
  regression tests or under `work-docs/<change>/probes/`.
- **Reference checkouts.** Keep `../ref/` checkouts in the parent workspace read-only. New
  implementation lives in this repository.
- **Agent guidance.** Edit `AGENTS.md` and `.agents/` (including the hook scripts in
  `.agents/hooks/`) as the canonical sources. Keep `CLAUDE.md` and per-tool directories
  (`.claude/`, `.codex/`, `.pi/`) as thin wiring that points at them, and preserve
  user-global settings.

## Writing

These rules apply to repository documents, code comments, commit messages, and owner
reports:

- Lead with the conclusion or recommendation, followed by necessary background and
  numbered points. Do not announce structure ("In short", "下面详细展开").
- Answer the question asked, without an unrequested proposal or an offer to start work.
  Do not comment on how large or hard the work is.
- Use ordinary technical terms without metaphors, idioms, or coined shorthand. Keep
  verbatim owner quotes in their original language. Language and other personal
  preferences live in `AGENTS.local.md`.
- Keep one idea per sentence and keep paragraphs short.
- Define a name, abbreviation, or number on first use, and add recurring project terms to
  `GLOSSARY.md`. State what each cited number refers to.
- Live documents describe the current design. Historical reasoning belongs in the relevant
  decision section, `spec.md`, or ADR.
- Contrast only options that were actually raised or weighed.
- Report verification with the command or suite and passed, failed, and skipped counts.
  Write passed and failed, not red and green. Durable prose and commit messages omit the
  counts.
- Ask one to three questions at a time, and ask heavy decisions alone. Give a recommended
  answer and brief reason for each question. Use a selection form only when the options
  are real, few, and mutually exclusive.
