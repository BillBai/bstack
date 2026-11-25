# Project workflow

This document defines how `<project-name>` routes, plans, implements, verifies, reviews,
and lands work across milestones, iterations, and changes. Matt Pocock's engineering
skills and `pstack` (`/poteto-mode`) provide templates and execution playbooks; this
workflow defines track selection, human gates, record ownership, and review convergence.

## 1. Planning levels and records

Work is organized across five levels. Time and change counts below are planning guides
rather than rigid quotas.

| Level | Typical scale | Purpose | Primary records |
| --- | --- | --- | --- |
| Project | Multi-quarter | Stage sequence, goals, and cross-milestone boundaries | `docs/plans/roadmap.md` |
| Milestone | ~2–3 months | Goals, scope, non-goals, acceptance criteria, overall design, iteration breakdown | `docs/plans/m<n>-<slug>/` |
| Iteration | ~2 weeks (~10 changes) | Detailed scope, acceptance criteria, technical design, ordered change breakdown | `docs/plans/m<n>-<slug>/i<n>-<slug>/` |
| Change | ~1 hour to ~1 day | Prototypes/research, lightweight tasks, or full changes | `research/` or `docs/topics/` (prototypes/research); `work-docs/<change>/` (`task.md` or `spec.md` + `tickets/` + `review.md`) |
| Retro | End of iteration or milestone | Whole-codebase review, architecture audit, bug check, refactoring triage, and workflow review | `retro.md` at the iteration or milestone level |

The current system design, its parts, their boundaries, and its invariants live in
[`docs/arch/architecture.md`](../arch/architecture.md). Plans describe what changes and
when; the architecture describes what the system is. When a change alters the
architecture, it updates that document in the same change.

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

Create subdirectories and optional files (`design/`, `research/`, `retro.md`, `progress.md`,
`change-plan.md`) when needed rather than pre-creating empty templates:

- **`roadmap.md`:** milestone goals, sequence, and repository boundaries.
- **`milestone.md`:** milestone goals, in-scope and out-of-scope items, acceptance
  criteria, and overall technical approach, linking to `design/` and `research/`.
- **`iteration-plan.md`:** how the milestone splits into iterations, what each iteration
  delivers, ordering, dependencies, and links to each `iteration.md`.
- **`progress.md`:** actual execution progress within a milestone, grouped by iteration.
  Record each iteration's and change's start date, landing or end date, calendar
  duration, and record links. Do not record intermediate stages here; a change's stage
  lives only in its `spec.md` or `task.md` ([Current Focus](#current-focus)). Do not track
  person-hours, and do not sum parallel change durations to compute an iteration's
  calendar duration.
- **`iteration.md`:** iteration goals, scope, acceptance criteria, and design summary,
  linking to `design/` and `research/`.
- **`change-plan.md`:** each planned change's problem, main tasks, expected outcome,
  dependencies, and link to its `spec.md` or `task.md` once created.
- **`design/`:** cross-iteration design at the milestone level; iteration-specific design
  at the iteration level.
- **`research/`:** investigations, comparisons, experiments, and prototype conclusions
  supporting that milestone or iteration. Standalone topic notes belong in `docs/topics/`.
- **`retro.md`:** review scope, baseline commit, findings, dispositions, and follow-up
  changes; if skipped, record that it was skipped and why.

Superseded designs, plans, and records that are kept for provenance move to
`docs/archive/`. They are not the current source of truth and need no routine reading.

### Where decisions live

Do not create a separate `decision-log.md` at any level by default. Record important
decisions and their rationale in the document that owns the topic:

- Scope, goals, and acceptance decisions go in `roadmap.md`, `milestone.md`, or
  `iteration.md`.
- Architecture choices, weighed alternatives, and tradeoffs go in the corresponding
  `design/` document (and in `docs/adr/` when all ADR criteria in
  [domain.md](../agents/domain.md) hold). The resulting design is reflected in
  `docs/arch/architecture.md`.
- Change-scoped design choices go in `work-docs/<change>/spec.md` (or
  `work-docs/<change>/task.md` for a lightweight task).
- Open questions stay in the owning plan or design document until resolved.

When the owner states a decision in their own words, in a discussion or a grill, or
corrects a proposal, preserve the owner's statement verbatim in its original language
alongside the recorded decision. When the owner only accepts the recommendation, the
record says so and quotes nothing. Split out a separate decision file only if a single
document grows too long to read cleanly.

## 2. Starting and resuming work

Start every session by reading `AGENTS.md` **Current Focus**, the linked milestone and
iteration documents, and the active change's records under `work-docs/` when present.
Resume from repository files rather than assuming prior chat history.

Inspect `git status` and the current branch before editing. Start each code change on its
own branch from the agreed base before writing its records or editing code, and resume an
existing change on its working branch unless the owner instructs otherwise. Preserve
unrelated uncommitted edits. Use separate Git worktrees when parallel agents edit code at
the same time, and place them in `<project>_workspace/worktrees/<repo>/<name>/`, beside
the main checkout.

Read project skill configurations before running workflow stages:

- [issue-tracker.md](../agents/issue-tracker.md) for `work-docs/` layout and status fields.
- [triage-labels.md](../agents/triage-labels.md) for canonical triage labels.
- [domain.md](../agents/domain.md) for `GLOSSARY.md` and ADR conventions.
- [agent-environment.md](../agents/agent-environment.md) for runner, model, and effort
  selection when delegating tasks or reviews.

Use the installed original skills (`mattpocock-skills` and `pstack`); do not rewrite or
copy them into the repository. Several skills (`grill-with-docs`, `to-spec`, `to-tickets`,
`implement`, `implement-spec`, `poteto-mode`, `interrogate`) declare
`disable-model-invocation: true`, so their absence from an automatic tool list is
intentional. After the owner authorizes a stage or track, read its `SKILL.md` (and any
referenced playbook or adapter) directly and follow it. If a required skill's files are
unavailable, report that setup problem. Skill availability does not authorize advancing to
another stage.

## 3. Milestone and iteration planning

Plan a milestone across one or more sessions with the owner, starting with a discussion
and continuing with a grill as [Planning stages](#planning-stages) describes: clarify
goals, non-goals, acceptance criteria, overall technical direction, and needed research or
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

### Choosing the execution track

Match each piece of work to one of three tracks rather than forcing every task through a
full specification cycle:

1. **Prototype or research:** an empirical probe, design comparison, or primary-source
   investigation that settles an open question before production code is committed.
   - Run `/poteto-mode` (`Prototype` or `Investigation` playbook) or Matt Pocock's
     `prototype` / `research` skill.
   - Build throwaway experiments in session scratch space, keeping production code untouched
     (commit a reproducible probe under `probes/` only when a recorded decision rests on its
     output).
   - Capture the question, reproduction command, measured evidence, and recommendation in a
     single Markdown file under the owning plan's `research/<slug>.md` or
     `docs/topics/<slug>.md` (or in the throwaway branch commit when no durable note is
     needed). Create no `work-docs/` directory and run no review stage.
2. **Lightweight task:** a focused bug fix, small feature, tool/script improvement, or
   local refactoring with clear boundaries that changes no public API, package or wire
   format, or core architecture invariant.
   - Create a branch and write the top of `work-docs/<change>/task.md` (`Status`, `Stage`,
     and `## TL;DR` stating the problem, intended behavior, and `Out of scope`) before
     editing code.
   - Execute with `/poteto-mode` (which routes to its `Bug fix`, `Feature`, or
     `Refactoring` playbook), applying three project overrides:
     1. Skip Cursor-only steps (`/deslop`, `control-ui`, `Opening a PR`) and run this
        repository's own checks and CI instead.
     2. Select subagent models through `/setup-pstack` or
        [agent-environment.md](../agents/agent-environment.md).
     3. Keep human gates before code review and before landing.
   - Once local tests and checks pass, push the branch for CI and **stop to ask the owner**
     whether to run one correctness review round (or skip it, recording `Skipped by owner`
     in `task.md`).
   - Complete the same single file `work-docs/<change>/task.md` (adding `## Decisions` when
     tradeoffs or `pending owner confirmation` items exist, `## Verification`, and
     `## Review`, keeping the whole file under ~40 lines with no `spec.md`, `tickets/`, or
     separate `review.md`), pass the [CI gate](#ci-gate), and wait for the owner's
     instruction to [land](#landing).
3. **Full change (Matt Pocock workflow):** a cross-module vertical slice, core architecture
   change, or change to a public API, format, or ABI contract.
   - Uses `work-docs/<change>/` (`m<x>-i<y>-<slug>` inside an iteration, `m0-i0-<slug>`
     before M1, or a descriptive slug outside an iteration) and follows
     [Planning stages](#planning-stages) through
     [Change review, acceptance, and landing](#5-change-review-acceptance-and-landing).

### Planning stages

For a full change, the owner advances these stages. Finish the authorized stage, present
its result, and stop; do not prepare later stages' code in advance.

1. **Discussion.** Before any list of questions, the owner and the agent agree on the
   background and the direction. Either side opens: the owner states the background and
   their thinking, or the agent reads the code and documents and explains the background,
   the problem, the approach, and a rough design. The agent asks only what it needs to
   understand what the owner said; detailed decisions wait for the grill. The agent closes
   with a short summary of the background, the goal, and the rough design, and the owner
   corrects it. **The grill starts when the owner agrees with the summary.**
2. **Grill (`grill-with-docs`).** Resolve the open decisions in detail, starting from the
   discussion's summary without re-asking settled points. Check codebase and reference
   facts first. Follow [Grill questions](#grill-questions). Only create a temporary
   `work-docs/<change>/grill.md` when a grill spans sessions; delete `grill.md` once its
   decisions and verbatim owner quotes are consolidated into `spec.md`. **Stop after the
   grill and wait for the owner to invoke `to-spec`.**
3. **Spec and design review (`to-spec`).** Write `spec.md` as [The spec](#the-spec)
   describes (deleting any temporary `grill.md`), then **stop and ask the owner** whether
   to run the [design review](#design-review-of-a-spec) and which runner, model, and
   effort to use (recording `Skipped by owner` in `review.md` if skipped).
4. **Tickets and combined briefing (`to-tickets`).**
   - *Standard path (design review skipped or raises no core design dispute):* apply clear
     fixes to `spec.md`, generate `tickets/<NN>-<slug>.md` using `to-tickets`'s native
     local template, and present the spec, worthwhile design suggestions, and ticket
     breakdown together in a **single combined briefing**
     ([Briefing on a spec or tickets](#briefing-on-a-spec-or-tickets)).
   - *Dispute path (design review challenges an approved decision, goal, or module
     boundary):* hold off on generating tickets, brief the owner on the disputed decision
     first, revise `spec.md` once settled (running a targeted second design-review check on
     the changed design only if warranted), and then generate tickets and present the
     combined briefing.
   - **Stop and wait for the owner to approve implementation.**

Agreement with grill answers or an artifact does not authorize implementation; only the
grill follows from agreement with the discussion's summary. An instruction to create or
use a branch does not approve implementation. Record only the approval the owner actually
gave.

### Grill questions

- Ask one to three questions per message unless the owner says otherwise. A question with
  a heavy decision goes alone; small, independent questions may go two or three together.
  This overrides the grilling skill's single round of the whole question list.
- Each question gives its background: what the thing is, the facts, and what each option
  leads to, with a small example where it helps. Give a recommended answer and its
  reason. Show progress as "question N of about M".
- Respect decisions already approved. Update `GLOSSARY.md` and offer ADRs as
  `domain-modeling` calls for.
- **User-facing names.** When a change adds or renames something users or the owner read
  (command-line commands and options, public API names, file and directory names users
  see, user-facing messages), present the whole set as one list. Each entry gives the
  name, its meaning, and a plain-word alternative, checked against `GLOSSARY.md`. The spec
  records the list. A task that needs a new user-facing name asks the owner when it comes
  up.

### The spec

`spec.md` begins with `Status`, `Stage`, and `Triage` lines. **Status** says whether the
spec is written, approved, in progress, or complete, with the date; after landing it gives
the landed commit and date. **Stage** names the workflow stage and what is finished in it.
For a full change, these two lines are the only record of the change's stage; update them
whenever the change moves on (for a lightweight task, the same two lines live at the top
of `task.md`).

Follow the metadata lines with a concise **`## TL;DR`** (what the change does and why, the
key decisions, and what is out of scope, readable in a few minutes), and then `to-spec`'s
native template sections (`Problem Statement`, `Solution`, `User Stories`,
`Implementation Decisions`, `Testing Decisions`, `Out of Scope`, `Further Notes`). Do not
embed a long prose walkthrough in `spec.md`; generate a plain-language walkthrough in
conversation on demand when the owner asks. Follow `to-spec`'s rule against listing
exhaustive file paths in `Implementation Decisions`, do not copy the ticket list into
`Further Notes`, and keep `## Comments` limited to explicit owner approvals and verbatim
owner quotes rather than process diaries.

### Design review of a spec

When the owner approves running a design review, dispatch the confirmed Large/XL model
(recommending a family other than the spec author's) with fresh context and read-only
repository boundaries, writing its report to `<dir>/<report>.md` outside the repository
([agent-environment.md](../agents/agent-environment.md)). Pass `spec.md`, the cited plan
or design documents, `docs/arch/architecture.md`, and `GLOSSARY.md`.

The reviewer acts as an independent senior engineer judging soundness, simpler or cleaner
alternatives (module boundaries, ownership, long-term maintainability), architecture
invariants, and internal consistency across the spec. Apply the shared
[Review criteria and report structure](#review-criteria-and-report-structure) (`Blockers`
and `Suggestions & Alternatives`).

Default to **one round**, with a hard cap of **two rounds**. Correct clear `Blockers`
directly; put any finding that alters an approved decision or noticeably complicates the
architecture to the owner rather than applying it blindly. Run a second round only when
round one's findings materially changed the core design, scoping round two strictly to the
revised sections and round one's dispositions. Record a concise summary under
`## Design review — Round <N>` in `work-docs/<change>/review.md`.

### Briefing on a spec or tickets

The owner decides from a briefing, not from reading every file. Explain the plan in the
owner's conversation language with concrete names and decisions:

1. **What the change does and why:** the problem and observable result.
2. **Every decision:** what was chosen, what alternative was weighed, and why (including
   tools, formats, and placement).
3. **Verification and boundaries:** which tests and checks prove the behavior, and what is
   out of scope.
4. **Tickets:** each ticket in order, its blockers, and the end-to-end slice it delivers,
   without repeating settled spec text.
5. **What the owner must do:** any open decision (with a recommended answer), worthwhile
   items selected from the design review's `Suggestions & Alternatives`, and the approval
   needed to start implementation.

### Planning the next change beside the current one

Once the owner approves the current change's implementation, the owner may start the next
change's discussion and grill in its own session, on its own branch. Its stages advance on
the owner's instructions as above. By default its implementation waits until the current
change lands, so one change at a time changes code. The owner may approve two changes
implementing at once when `bstack-control`'s overlap check finds that they change no
shared area and the plan sets no dependency between them. Current Focus keeps naming the
current change until it lands.

When the current change has landed, and before the next change's implementation starts,
the next change's agent rebases its branch onto the new main branch. The branch is not
pushed before this rebase, so the rebase needs no force push. The agent then checks its
`spec.md` and `tickets/` (or `task.md`) against the landed code and updates stale
references; a difference that shakes the design goes to the owner before implementation.

### Implementation and test gate

Once the owner approves implementation of a full change, use `implement` or
`implement-spec` with `tdd`. Honor the owner's choice; otherwise choose by the work and
state the reason:

- **`implement`:** a single task, a mostly sequential ticket graph, or tickets whose
  shared files make parallel work unhelpful.
- **`implement-spec`:** tickets whose blockers allow independent work. Implementer
  subagents work in separate worktrees, and a merger subagent integrates their work on
  the change branch, followed by the full test verification there.

Each implementer and the merger start with fresh context. Their brief includes the rules
of [Decisions made in implementation](#decisions-made-in-implementation) and step 1 of
[Work through a ticket](#work-through-a-ticket). An implementer sets its ticket's Status
to in progress at the start and commits each completed ticket, so the worktree's log and
the ticket file show progress. Retain completed tickets, and get the owner's permission
before removing worktrees or branches.

The **test gate** verifies that every promised behavior works and relevant suites pass.
Run the complete change review after all implementation tickets finish, not after every
ticket. Commit verified tickets or coherent groups and continue without asking at each
routine step.

### Work through a ticket

Tickets use `to-tickets`'s native `<local-ticket-template>` (`# <NN>: <Title>`,
`What to build`, `Blocked by`, `Status`, and acceptance checkboxes, plus a link to
`../spec.md`). Do not add a `## Context` section copying the spec's file paths or
decisions, and do not create administrative gate-only tickets that build no behavior.

1. **Read its acceptance criteria.** Use the test approach agreed in the spec. If a
   criterion cannot be met as written, or where two parts of the spec or ticket
   contradict each other, stop and ask the owner rather than weakening acceptance or
   choosing silently. Record the owner's answer in `spec.md` and correct the overruled
   text.
2. **Test the behavior, then implement it.** For new behavior or a bug fix, observe the
   test fail before the change and pass after it. For a behavior-preserving refactor,
   existing or characterization tests may suffice; name them in the ticket. For compiler,
   bytecode, or binary transformations, verify both preserved program behavior and the
   intended transformation effect, individually and in supported combinations.
3. **Run the relevant checks.** Run the tests the ticket adds or changes and the tests of
   the code it touches; do the same after review repairs. Run the full local suite in the
   default configuration once per change, after the last ticket and before code review. Do
   not repeat locally the configurations CI runs (other build configurations, sanitizers,
   simulators); run one locally only to diagnose its CI failure. A check CI cannot run
   runs when the work changes what it tests, and once on the landing candidate. Diagnose
   any failure's root cause before editing code.
4. **Record the result concisely.** Update the ticket's `Status` and acceptance
   checkboxes. Keep `## Comments` to 1–5 lines covering final test counts, CI build
   reference, any `Untested paths: ... / why acceptable` note, and non-obvious pitfalls
   worth remembering; omit step-by-step trial logs.
5. **Commit and continue** with the next unblocked ticket.

A test must check observable behavior (a return value, specific error, state change, or
artifact output) and fail when that behavior is removed. Documentation and configuration
changes use checks suited to them, such as link validation and loading the configuration,
without unrelated product suites.

### CI during implementation

Once remote CI exists, push the branch after each group of related tickets (or after a
lightweight task's local checks pass) and continue without waiting synchronously when
other work remains. Diagnose any CI failure before fixing it. Stop to ask the owner about
code review once local checks pass without waiting for a trailing CI build; any CI failure
reported during review is fixed alongside review findings. Such branch pushes need no
approval and do not replace the [CI gate](#ci-gate).

### Execution notes and probes

Keep raw logs and temporary experiments in session scratch space. A reproducible program
whose output backs a recorded decision is committed with the change: as a test in the
suite that owns the fact when later changes rely on it, otherwise under `probes/` (`work-docs/<change>/probes/` or beside the research note) with a short header giving what it
shows, the command, the toolchain, and the output it printed.

Record out-of-scope problems in `work-docs/backlog.md` with context and evidence, or in
the relevant iteration plan when already assigned to an iteration.

### Decisions made in implementation

When implementation or a review repair settles a point not covered in `spec.md` (or
`task.md`), handle it by whether it affects the design, contracts, or goals:

1. **An internal implementation detail** that leaves the design, contracts, and goals as
   they are (where an internal helper lives, the shape of a private function, how a test
   is structured): implement it directly without writing it back into `spec.md` or asking
   the owner.
2. **A finding that shakes the approved design or goals** (the approach fails, an
   architecture invariant breaks, or an acceptance criterion cannot be met): stop and ask
   the owner at once ([Stopping points](#stopping-points)).
3. **An open point with real behavioral or external consequences** that does not overturn
   the design (such as behavior on a missing optional input): choose, record it in
   `spec.md` or `task.md` marked `(pending owner confirmation)`, and continue.
   [Final acceptance](#final-acceptance) presents these for the owner to confirm.

Ask the owner immediately when a new user-facing name arises ([Grill questions](#grill-questions)). When uncertain between categories, treat the decision as the heavier kind.

### Stopping points

After implementation starts, routine coding, testing, in-scope `Blocker` repairs within an
approved review stage, and working-branch commits continue without further prompts. Stop
and consult the owner for:

- before starting each review stage (spec design review and post-implementation code
  review), to confirm whether to run it and which runner(s), model(s), and effort(s) to
  use;
- a finding that shakes the approved design or goals, an architecture conflict, a review
  fix that would noticeably complicate the architecture, or scope expansion;
- contradictory requirements in `spec.md` or `tickets/`, a weaker acceptance criterion, or
  required verification that cannot run;
- a new user-facing name;
- exhausted review rounds (reaching the 2-round cap with unresolved blockers);
- landing on the main branch, force pushes, or any destructive or hard-to-reverse action.

## 5. Change review, acceptance, and landing

**Never start code review automatically.** After implementation and local checks pass,
stop and ask the owner whether to run code review and which eligible runner(s), model(s),
and effort(s) from [agent-environment.md](../agents/agent-environment.md) to use:

- **Lightweight task:** default to **one correctness review round** with a single
  fresh-context reviewer (or skip it when the owner instructs, recording
  `Skipped by owner` under `## Review` in `task.md`).
- **Full change:** default to **one concurrent review round** dispatching Matt Pocock's
  `code-review` (`Standards` and `Spec` axes in separate fresh contexts, under 400 words
  per axis) in parallel with an independent cross-family **Expert reviewer** (the
  implementer never acts as its own expert reviewer), then merging and fixing confirmed
  `Blockers` in a single repair pass. For unusually high-risk changes, the owner may
  select sequential Regular-then-Expert stages instead. If skipped, record
  `Skipped by owner` in `work-docs/<change>/review.md`.

Export the pinned base..candidate diff and commit list to a temporary directory `<dir>`
outside the repository, and instruct every reviewer to write its full report to
`<dir>/<report>.md` without modifying tracked files or leaving non-ignored untracked
files. Verify `git status --porcelain` and `git rev-parse HEAD` after each reviewer
finishes.

### Review criteria and report structure

All review stages (spec design, regular `Standards`/`Spec`, expert, and lightweight
correctness review) follow the same scope and two-bucket structure:

1. **Review scope:** evaluate behavioral correctness, architecture and module boundaries,
   ownership, concurrency and lifetime safety, resource cost, and code maintainability.
   Mechanical formatting, line wrapping, item numbering, wording preferences, license
   headers, and hand-counted file or test inventories belong to automated checks and stay
   out of review reports.
2. **`Blockers` (must meet all three conditions, stating exact file/line or section,
   trigger path, and consequence):**
   - **Realistic trigger:** reachable under the target platform's actual runtime behavior
     and the module's stated contracts (not assuming platform-managed resource exhaustion
     or compounded cascading faults unless the module carries an explicit no-allocation or
     real-time contract).
   - **Material harm:** causes wrong output, state corruption, concurrency hazards, leaks
     or unbounded growth, violations of the spec or architecture invariants, misleading
     comments that would induce bugs, or clear responsibility misplacement.
   - **Proportionate fix:** improves correctness or clarity without adding architectural
     complexity for negligible-value edge states (such as non-diagnostic state along a
     process-termination path).
3. **`Suggestions & Alternatives` (open divergent ideas, encouraged and non-blocking):**
   - Reviewers are encouraged to propose simpler overall designs, cleaner module
     boundaries, readability improvements, or future evolution risks.
   - **Execution guardrails:** implementing agents never modify code to address this
     bucket on their own, and items in this bucket never trigger a follow-up review round.
     The main agent selects worthwhile ideas (typically 1–3) and presents them to the
     owner at briefing or final acceptance to adopt, log in `work-docs/backlog.md`, or
     skip without writing a defensive rebuttal.

### Convergence and review records

- **Default 1 round, hard cap of 2 rounds:**
  - When Round 1 repairs fix localized defects with failing-then-passing tests and do not
    alter core control flow, concurrency, or memory ownership, **converge immediately
    after Round 1** without re-running reviewers.
  - Run **Round 2** only when Round 1 repairs modify core control flow, concurrency,
    memory safety, or high-risk contracts (or when the owner requests it). Scope Round 2
    strictly to verifying Round 1's dispositions and reviewing the **incremental diff of
    Round 1's repairs**; reviewers do not re-roam unchanged files for new stylistic
    points.
  - Never run a third round automatically; bring any remaining dispute after Round 2 to
    the owner.
- **Read-only routine reviews, runnable repros only for contested claims:** routine
  reviews stay fast and static/read-only (with optional targeted read-only commands).
  Invoke `pstack`'s `interrogate` skill (requiring a runnable minimal reproduction) only
  when a high-risk finding is contested.
- **Lean review records:** full reports stay in `<dir>/<report>.md`. For a full change,
  record ~10 lines per round in `work-docs/<change>/review.md` under
  `## Round <N> (<YYYY-MM-DD>)` (or `## Design review — Round <N>`):
  - **Scope & reviewers:** pinned `base..candidate` commits and each reviewer's runner,
    model, and effort;
  - **Fixed blockers:** one concise line per repaired blocker;
  - **Rejected / deferred:** one concise line per declined or backlogged blocker with its
    reason so later checks do not reopen it;
  - **Verification:** the test commands and checks passed after repairs.
  Omit non-blocking suggestions and minor cleanup from `review.md` (lightweight tasks put
  the same compact summary under `## Review` in `task.md`).

### CI gate

Changes to product code, tests, build files, or CI configuration must pass the applicable
remote CI pipeline on the reviewed candidate commit before landing (once remote CI is
established), plus any required check CI cannot run (such as physical-device verification
when applicable). A change whose files all match the pipeline's ignore list (records and
agent guidance, listed in the project's build guide) is exempt and uses document checks;
before remote CI exists, state that explicitly in verification notes. Push the working
branch to trigger CI without asking (normal push only, never force-push). A branch push
does not authorize landing. Use the project's CI skill or script, when it has one, to find
the build of a commit, wait for it in the background, and read a failing job's logs.
Record the build, tested commit, and result in `task.md`, the relevant ticket, or
`review.md`. A missing, running, canceled, or failed build leaves the gate open.

### Final acceptance

Verify that acceptance criteria, tests, CI, and records agree with the implementation.
Present a final acceptance summary covering delivered behavior, verification and CI
results, review outcome, selected `Suggestions & Alternatives` worth the owner's decision,
deferred items, and every decision marked `pending owner confirmation` for the owner to
confirm one by one. A confirmed decision loses its marker. Landing waits until every
pending decision is confirmed, unless the owner says otherwise.

### Landing

Landing requires explicit owner instruction. On that instruction:

1. Record the owner's acceptance in `spec.md` (Status and Comments) or `task.md` (Status)
   on the change branch, and commit.
2. Check that the commits after the CI gate's tested commit change only paths the pipeline
   ignores; otherwise rerun the gate first.
3. Fast-forward the main branch to the change branch. If it cannot fast-forward, stop and
   ask the owner.
4. Record the landing: `spec.md` or `task.md` Status gives the landed commit and date,
   `progress.md` gives the landing date when tracked, and Current Focus moves on if the
   current change ended. Commit on the change branch and fast-forward the main branch
   again.
5. Push the change branch and the main branch.
6. Check each pushed ref separately: `git rev-parse <ref>` equals
   `git ls-remote origin refs/heads/<ref>`. Run one ref per call.

Do not delete branches or worktrees unless asked.

### Current Focus

`AGENTS.md` **Current Focus** is the single routing entry for active work. It names the
active milestone and its documents, the iteration plan, the current iteration in one
sentence, and the current change with its `work-docs/` directory, noting that the change's
records live on its branch until it lands. It carries no stage text such as
"implementation is in progress"; the `Status` and `Stage` lines of `spec.md` (or
`task.md`) are the only record of a change's stage. Current Focus changes only when the
current iteration or change changes. If the next change has not been selected, it says so.
A next-change hint does not approve implementation.

## 6. Retro

Run a retro at the end of each iteration and each milestone, or whenever requested by the
owner. Scale depth to what changed. If the owner decides to skip a retro, record the skip
and reason in the corresponding `retro.md`.

A retro covers both plan reflection and technical health across accumulated changes:

- **Whole-codebase review and bug audit:** inspect cross-change interactions, module
  boundaries, duplicated abstractions, dead code, error handling, and missing test
  coverage across the codebase at a pinned commit (dispatching read-only reviewers as
  needed without repeating narrow single-change checks).
- **Workflow review (when useful):** where each stage's time went, measured from session
  transcripts, and where the owner corrected the agent or a decision went wrong.
- **Finding classification:** record baseline commit and classify observations in
  `retro.md` as **reproduced defects**, **design risks**, or **fragile practices /
  technical debt**.
- **Disposition and refactoring:** decide how each item is handled rather than making
  ad-hoc edits during the read-only review:
  1. Defects blocking current iteration or milestone acceptance are fixed immediately as a
     lightweight task or scoped full change.
  2. Non-trivial refactorings or improvements become standalone changes in `work-docs/`
     routed to the matching track in [Choosing the execution track](#choosing-the-execution-track).
  3. Items assigned to an upcoming iteration are added to `iteration-plan.md` or the next
     `change-plan.md`.
  4. Unscheduled items are recorded in `work-docs/backlog.md`.
