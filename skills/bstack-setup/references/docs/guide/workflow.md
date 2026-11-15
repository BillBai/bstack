# Project workflow

This document defines how `<project-name>` plans, implements, verifies, reviews, and lands
work across milestones, iterations, and changes. Matt Pocock's engineering skills provide
templates and methods; this workflow defines stage boundaries, record ownership, and
review rules.

## 1. Planning levels and records

Work is organized across five levels. Time and change counts below are planning guides
rather than rigid quotas.

| Level | Typical scale | Purpose | Primary records |
| --- | --- | --- | --- |
| Project | Multi-quarter | Stage sequence, goals, and cross-milestone boundaries | `docs/plans/roadmap.md` |
| Milestone | ~2–3 months | Goals, scope, non-goals, acceptance criteria, overall design, iteration breakdown | `docs/plans/m<n>-<slug>/` |
| Iteration | ~2 weeks (~10 changes) | Detailed scope, acceptance criteria, technical design, ordered change breakdown | `docs/plans/m<n>-<slug>/i<n>-<slug>/` |
| Change | ~1 day | Grill, spec, tickets, implementation, verification, and reviews | `work-docs/m<x>-i<y>-<slug>/` |
| Retro | End of iteration or milestone | Whole-codebase review, architecture audit, bug check, and refactoring triage | `retro.md` at the iteration or milestone level |

### Plans directory layout

```text
docs/plans/
├── roadmap.md
└── m<n>-<slug>/
    ├── milestone.md
    ├── iteration-plan.md
    ├── progress.md
    ├── design/
    ├── research/
    ├── retro.md
    └── i<n>-<slug>/
        ├── iteration.md
        ├── change-plan.md
        ├── design/
        ├── research/
        └── retro.md
```

Create subdirectories and optional files (`design/`, `research/`, `retro.md`, `progress.md`)
when needed rather than pre-creating empty templates:

- **`roadmap.md`:** milestone goals, sequence, and repository boundaries.
- **`milestone.md`:** milestone goals, in-scope and out-of-scope items, acceptance
  criteria, and overall technical approach, linking to `design/` and `research/`.
- **`iteration-plan.md`:** how the milestone splits into iterations, what each iteration
  delivers, ordering, dependencies, and links to each `iteration.md`.
- **`progress.md`:** actual execution progress within a milestone, grouped by iteration.
  Record start date, end date, calendar duration, status, and record links for each
  iteration and change. Do not track person-hours, and do not sum parallel change
  durations to compute an iteration's calendar duration.
- **`iteration.md`:** iteration goals, scope, acceptance criteria, and design summary,
  linking to `design/` and `research/`.
- **`change-plan.md`:** each planned change's problem, main tasks, expected outcome,
  dependencies, and link to its `spec.md` once created.
- **`design/`:** cross-iteration design at the milestone level; iteration-specific design
  at the iteration level.
- **`research/`:** investigations, comparisons, experiments, and prototype conclusions
  supporting that milestone or iteration. Standalone topic notes belong in `docs/topics/`.
- **`retro.md`:** review scope, baseline commit, findings, dispositions, and follow-up
  changes; if skipped, record that it was skipped and why.

### Where decisions live

Do not create a separate `decision-log.md` at every level by default. Record important
decisions and their rationale in the document that owns the topic:

- Scope, goals, and acceptance decisions go in `roadmap.md`, `milestone.md`, or
  `iteration.md`.
- Architecture choices, weighed alternatives, and tradeoffs go in the corresponding
  `design/` document (and in `docs/adr/` when all ADR criteria in
  [domain.md](../agents/domain.md) hold).
- Change-scoped design choices go in `work-docs/m<x>-i<y>-<slug>/spec.md`.
- Open questions stay in the owning plan or design document until resolved.

When the owner states a decision in their own words or corrects a proposal, preserve the
owner's statement verbatim in its original language alongside the recorded decision. Split
out a separate decision file only if a single document grows too long to read cleanly.

## 2. Starting and resuming work

Start every session by reading `AGENTS.md` **Current Focus**, the linked milestone and
iteration documents, and the active change's records under `work-docs/` when present.
Resume from repository files rather than assuming prior chat history.

Inspect `git status` and the current branch before editing. Start each implementation
change on its own branch (`feat/m<x>-i<y>-<slug>`) from the agreed base, and resume an
existing change on its working branch unless the owner instructs otherwise. Preserve
unrelated uncommitted edits. Use separate Git worktrees when parallel agents edit code at
the same time.

Read project skill configurations before running Matt Pocock workflow stages:

- [issue-tracker.md](../agents/issue-tracker.md) for `work-docs/` layout and status fields.
- [triage-labels.md](../agents/triage-labels.md) for canonical triage labels.
- [domain.md](../agents/domain.md) for `GLOSSARY.md` and ADR conventions.
- [agent-environment.md](../agents/agent-environment.md) for runner, model, and effort
  selection when delegating tasks or reviews.

## 3. Milestone and iteration planning

Plan a milestone across one or more discussion sessions with the owner: clarify goals,
non-goals, acceptance criteria, overall technical direction, and needed research or
prototypes, then split the milestone into candidate iterations in `iteration-plan.md`.

Before starting an iteration, refine its scope, technical design, acceptance criteria, and
experiments in `iteration.md` (plus `design/` or `research/` when needed), then break the
work into concrete changes in `change-plan.md` with clear expected outcomes and
dependencies.

Designs evolve when measurements or implementation reveal new facts. If a discovery changes
an approved milestone goal, iteration scope, core technical choice, or acceptance
criterion, bring that decision back to the owner at the owning level before continuing
dependent work.

## 4. Change execution

Every change uses a `work-docs/m<x>-i<y>-<slug>/` directory (`m0-i0-<slug>` before M1, or
`m<x>-i0-<slug>` for milestone-level work outside a numbered iteration).

### Grill, spec, and tickets

Pause at the end of each planning stage below to present results, discuss with the owner,
and wait for explicit instruction before starting the next stage:

1. **Grill (`grill-with-docs`).** Check codebase and reference facts first. Ask one to
   three focused questions at a time (heavy decisions alone), each with context, options,
   and a recommended answer with its reason. While a change is still in grill and `spec.md`
   has not been created, record resolved points, verbatim owner quotes, and open questions
   in `work-docs/m<x>-i<y>-<slug>/grill.md`. Consolidate those decisions into `spec.md`
   once spec writing begins.
2. **Spec (`to-spec`).** Begin `spec.md` with `Status`, `Stage`, and `Triage` lines,
   followed by a **Plain-language walkthrough** before the template sections. Keep the
   walkthrough clear, concrete, and sized so the owner can read it in **within 15 minutes**
   — covering background, problem, proposed behavior, design tradeoffs, boundaries, and
   verification examples. Present the spec in conversation with a full briefing (below).
3. **Tickets (`to-tickets`).** Write one independently verifiable task per file under
   `tickets/<NN>-<slug>.md`, numbered in dependency order with explicit blockers and
   acceptance criteria. Present the breakdown in conversation with a briefing.

### Conversation briefing for specs and tickets

Give the owner enough concrete detail in Chinese to decide without opening every file:

1. **What the change does and why:** the problem and observable result after the change.
2. **Every decision:** what was chosen, what alternative was weighed, and why.
3. **Verification:** which tests and checks demonstrate the behavior.
4. **Boundaries:** what is out of scope or deferred.
5. **Tickets (for ticket briefings):** each ticket in order, its blockers, and what it
   delivers, without repeating already-settled spec decisions.
6. **Open questions and next step:** any remaining questions with recommended answers.

### Implementation and verification

Once the owner approves implementation, execute unblocked tickets using `implement`
(sequential work or shared files) or `implement-spec` (parallel subagents in separate
worktrees followed by integration and full test verification on the change branch). Commit
verified tickets or coherent groups and continue without asking at each routine step.

Follow these verification and record rules during implementation:

- **Test observable behavior.** For new features or bug fixes, observe the test fail first
  and pass after the change (`tdd`). For refactors, verify preserved behavior. For
  compiler, bytecode, or binary transformations, verify both **preserved program behavior**
  and the **intended transformation effect**, individually and in supported combinations.
- **Documentation and config changes.** Run checks suited to the change, such as local
  link validation and config loading, without requiring unrelated product suites.
- **Execution notes and probes.** Update ticket `Status` and checkboxes as work finishes,
  and record key test outputs or intentionally untested paths in ticket `Comments`. Keep
  raw logs in scratch space. Commit reproducible programs that back a design decision as
  tests or under `work-docs/m<x>-i<y>-<slug>/probes/` with purpose, command, toolchain, and output.
- **Open implementation details.** If implementation or review repair settles a minor
  detail left open by `spec.md`, write the choice into `spec.md` marked
  `pending owner confirmation` (for example, `(Decided in ticket 03; pending owner
  confirmation.)`) and list all such items at final acceptance.
- **Deferred issues.** Record out-of-scope issues discovered along the way in
  `work-docs/backlog.md` with context and evidence, or in the relevant iteration plan when
  already assigned to a specific iteration.
- **Stopping points.** Stop and consult the owner for unresolved scope or architecture
  conflicts, weaker acceptance criteria, required verification that cannot run, exhausted
  review rounds, or destructive actions. Diagnose ordinary test failures before escalating.

## 5. Change review, acceptance, and landing

Review the complete change after its implementation tickets and local checks pass, rather
than running a full change review per ticket. Pin the comparison base commit and candidate
commit, export the diff and commit list to a temporary directory outside the repository,
and have each reviewer write its report to a file there. Record all findings, dispositions,
and verifications in `work-docs/m<x>-i<y>-<slug>/review.md`, preserving rejected findings and
their reasons.

Select runners, models, thinking levels, and Herdr tabs according to
[agent-environment.md](../agents/agent-environment.md). Reviewers run with fresh context
and read-only access to repository files:

1. **Regular review (`code-review`, up to 3 rounds).** Dispatch separate Standards and
   Spec subagents using the Large tier of the main agent's family with `xhigh` effort. The
   Spec reviewer also checks that formal decisions and code match recorded owner quotes
   without narrowing or widening them.
2. **Expert review (up to 2 rounds).** After regular review converges, dispatch an
   independent read-only reviewer from a different model family (Claude Code and Codex
   review each other by default, or use an owner-specified family). Review assumptions,
   architecture, edge cases, performance/size costs, and test gaps.

Convergence means no unresolved material defect, verification gap, or design dispute;
purely stylistic nitpicks do not require extra rounds. Repairs from expert review receive
targeted verification without automatically restarting all regular review rounds.

### CI, final acceptance, and landing

Changes to product code, tests, build files, or CI scripts must pass the applicable remote
CI pipeline on the reviewed candidate commit before landing (once remote CI is
established). Documentation-only changes use documentation checks and are exempt from
product CI; before remote CI exists, state that explicitly in verification notes. Pushing
a working branch solely to trigger remote CI requires owner permission if not already
granted, and does not authorize landing.

Present a final acceptance summary covering delivered behavior, test/CI and review results,
all `pending owner confirmation` decisions for the owner to confirm, and any deferred
items. Once confirmed, remove the `pending owner confirmation` markers.

Landing on `main` and pushing to the remote require explicit owner instruction:

1. Record acceptance in `spec.md`, update `progress.md` and `AGENTS.md` **Current Focus**
   as appropriate, and commit on the working branch.
2. Verify branch cleanliness and applicable CI status, then integrate onto `main`
   without rewriting shared history.
3. Push requested refs when instructed and verify remote commit SHAs. Do not delete
   branches or worktrees unless asked.

## 6. Retro

Run a retro at the end of each iteration and each milestone, or whenever requested by the
owner. Scale depth to what changed. If the owner decides to skip a retro, record the skip
and reason in the corresponding `retro.md`.

A retro covers both plan reflection and technical health across accumulated changes:

- **Whole-codebase review and bug audit:** inspect cross-change interactions, module
  boundaries, duplicated abstractions, dead code, error handling, and missing test
  coverage across the codebase at a pinned commit (dispatching read-only reviewers as
  needed without repeating narrow single-change checks).
- **Finding classification:** record baseline commit and classify observations in
  `retro.md` as **reproduced defects**, **design risks**, or **fragile practices /
  technical debt**.
- **Disposition and refactoring:** decide how each item is handled rather than making
  ad-hoc edits during the read-only review:
  1. Defects blocking current iteration or milestone acceptance are fixed immediately in a
     scoped change.
  2. Non-trivial refactorings or improvements become standalone changes in `work-docs/`
     that follow the normal spec, test, and review workflow.
  3. Items assigned to an upcoming iteration are added to `iteration-plan.md` or the next
     `change-plan.md`.
  4. Unscheduled items are recorded in `work-docs/backlog.md`.
