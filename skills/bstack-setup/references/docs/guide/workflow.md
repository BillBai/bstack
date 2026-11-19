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
| Change | ~1 day | Discussion, grill, spec, tickets, implementation, verification, and reviews | `work-docs/<change>/` |
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

Create subdirectories and optional files (`design/`, `research/`, `retro.md`, `progress.md`)
when needed rather than pre-creating empty templates:

- **`roadmap.md`:** milestone goals, sequence, and repository boundaries.
- **`milestone.md`:** milestone goals, in-scope and out-of-scope items, acceptance
  criteria, and overall technical approach, linking to `design/` and `research/`.
- **`iteration-plan.md`:** how the milestone splits into iterations, what each iteration
  delivers, ordering, dependencies, and links to each `iteration.md`.
- **`progress.md`:** actual execution progress within a milestone, grouped by iteration.
  Record each iteration's and change's start date, landing or end date, calendar
  duration, and record links. Do not record intermediate stages here; a change's stage
  lives only in its spec ([Current Focus](#current-focus)). Do not track person-hours,
  and do not sum parallel change durations to compute an iteration's calendar duration.
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
- Change-scoped design choices go in `work-docs/<change>/spec.md`.
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

Inspect `git status` and the current branch before editing. Start each change on its own
branch from the agreed base before writing its planning records, and resume an existing
change on its working branch unless the owner instructs otherwise. Preserve unrelated
uncommitted edits. Use separate Git worktrees when parallel agents edit code at the same
time, and place them in `<project>_workspace/worktrees/<name>/`, beside the main checkout.

Read project skill configurations before running Matt Pocock workflow stages:

- [issue-tracker.md](../agents/issue-tracker.md) for `work-docs/` layout and status fields.
- [triage-labels.md](../agents/triage-labels.md) for canonical triage labels.
- [domain.md](../agents/domain.md) for `GLOSSARY.md` and ADR conventions.
- [agent-environment.md](../agents/agent-environment.md) for runner, model, and effort
  selection when delegating tasks or reviews.

Use the installed original skills; do not rewrite them. Several of them (`grill-with-docs`,
`to-spec`, `to-tickets`, `implement`, `implement-spec`) declare
`disable-model-invocation: true`, so their absence from an automatic tool list is
intentional. After the owner authorizes a stage, read its `SKILL.md` directly and follow
it. If a required skill's files are unavailable, report that setup problem. Skill
availability does not authorize advancing to another stage.

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

Every change uses a `work-docs/<change>/` directory. A change inside an iteration names it
`m<x>-i<y>-<slug>` (`m0-i0-<slug>` before M1). Work outside an iteration, such as a retro,
a series of refactoring changes, or a workflow change, uses a descriptive slug with no
required pattern.

### Planning stages

The owner advances these stages. Finish the authorized stage, present its result, and
stop; do not prepare the next stage's artifacts in advance.

1. **Discussion.** Before any list of questions, the owner and the agent agree on the
   background and the direction. Either side opens: the owner states the background and
   their thinking, or the agent reads the code and documents the change concerns and
   explains the background, the problem, the approach, and a rough design. The agent asks
   only what it needs to understand what the owner said; detailed decisions wait for the
   grill. The agent closes with a short summary of the background, the goal, and the
   rough design, and the owner corrects it. The summary is where the grill starts, not a
   record: the grill may change the rough design, and the spec records what the grill
   settles. **The grill starts when the owner agrees with the summary.**
2. **Grill (`grill-with-docs`).** Resolve the open decisions in detail, starting from the
   discussion's summary without asking again what it settled. Check codebase and
   reference facts first. Follow [Grill questions](#grill-questions). While `spec.md` does
   not exist yet, record resolved points, verbatim owner quotes, and open questions in
   `work-docs/<change>/grill.md`; consolidate them into `spec.md` once spec writing
   begins. **Stop after the grill and wait for the owner to invoke `to-spec`.**
3. **Spec (`to-spec`).** Write `spec.md` as [The spec](#the-spec) describes, run the
   [design review](#design-review-of-a-spec), then present the spec with a
   [briefing](#briefing-on-a-spec-or-tickets). **Stop and wait for the owner to invoke
   `to-tickets`.**
4. **Tickets (`to-tickets`).** Write one independently verifiable task per file under
   `tickets/<NN>-<slug>.md`, numbered in dependency order with explicit blockers and
   acceptance criteria. Present them with a briefing. **Stop and wait for the owner to
   approve implementation of the spec, testing decisions, and tickets.**

Agreement with grill answers or an artifact does not authorize the next stage; only the
grill follows from agreement, with the discussion's summary. An instruction to create or
use a branch does not approve the spec or implementation. Record only the approval the
owner actually gave.

### Grill questions

- Ask one to three questions per message unless the owner says otherwise. A question with
  a heavy decision goes alone; small, independent questions may go two or three together.
  This overrides the grilling skill's single round of the whole question list.
- Each question gives its background: what the thing is, the facts, and what each option
  leads to, with a small example where it helps. Give a recommended answer and its
  reason. Show progress as "question N of about M".
- Respect decisions already approved. Update the glossary and offer ADRs as the skill
  calls for.
- **User-facing names.** When a change adds or renames something users or the owner read
  (command-line commands and options, public API names, file and directory names users
  see, user-facing messages), present the whole set as one list. Each entry gives the
  name, its meaning, and a plain-word alternative, checked against `GLOSSARY.md`. The spec
  records the list. A ticket that needs a new user-facing name asks the owner when it
  comes up.

### The spec

`spec.md` begins with `Status`, `Stage`, and `Triage` lines. **Status** says whether the
spec is written, approved, in progress, or complete, with the date; after landing it gives
the landed commit and date. **Stage** names the workflow stage and what is finished in it,
such as the tickets completed and the reviews passed. These two lines are the only record
of the change's stage; update them whenever the change moves on.

Two plain-language parts follow, before the `to-spec` template sections:

1. **TL;DR**, readable within 10 minutes: what the change does and why, the key
   decisions, and what is out of scope.
2. **Plain-language walkthrough**: the background, problem, proposed behavior, design,
   the tradeoffs actually weighed, boundaries, and verification, through concrete
   examples. This is the owner's main design discussion surface, not a short summary.
   Keep it consistent with the template sections.

### Design review of a spec

After the spec is written and before its briefing, a reviewer model checks the design
with fresh context and read-only access, so that a design problem is found before any code
is written. Use the design reviewer named in
[agent-environment.md](../agents/agent-environment.md): a family other than the
implementer's, preferably a third family that neither implements nor runs the expert
review (or the opposite primary family in a fresh-context session when the project uses
only two families). The brief names the files to read (the spec, the source design and
decisions it cites, the architecture, and the glossary) and the output file for the report.

The reviewer acts as an independent senior engineer. The following are prompts for
judgment, not a complete list:

1. Whether the design is sound for the problem the spec states.
2. Whether a better design exists: a simpler one that gives the same result, or a more
   reasonable one. This covers the architecture and module boundaries; which module owns
   each responsibility, object, and piece of state; and how well the design serves the
   code's evolution and maintenance over years.
3. Whether it breaks an architecture invariant.
4. Whether the spec agrees with itself and with the source design it cites: a user story,
   a decision, and an acceptance statement that disagree, in what they ask for or in how
   much, are a finding.

The agent corrects the spec where a finding is plainly right. A finding that would change
a decision is not applied; it goes to the owner in the briefing, written as
[Decisions made in implementation](#decisions-made-in-implementation) describes for a
decision put to the owner. Record each round, its model and effort, and each finding's
disposition in the change's `review.md`.

Allow at most **two rounds**. The second runs when the first round's material findings
changed the spec, after every one of them is settled (the agent's corrections are made and
the owner has decided the rest), and before the revision's briefing. It reads `review.md`,
checks the dispositions, and reviews the changed text in the context of the whole spec.
Material findings that remain after round two go to the owner. If the design reviewer's
model is unavailable, report it and let the owner decide the substitute; do not
substitute on your own or count the step as passed.

### Briefing on a spec or tickets

The owner decides from a briefing, not from reading every file. When presenting a new
spec, a ticket breakdown, or a material revision of either, explain it in the owner's
conversation language with enough concrete detail to approve or object without opening
the documents:

1. **What the change does and why:** the problem and the observable result after the
   change.
2. **Every decision:** what was chosen, what alternative was weighed, and why. Technology
   choices (tools, languages, file formats, libraries, where files live) are decisions
   too.
3. **Verification:** which tests and checks demonstrate the behavior.
4. **Boundaries:** what is out of scope or deferred.
5. **Tickets (for ticket briefings):** each ticket in order, its blockers, what it
   delivers, and which decisions it carries out, without repeating settled spec
   decisions.
6. **What the owner must do:** open questions with recommended answers, and the approval
   the next stage needs. A spec's briefing puts the design review's findings that would
   change a decision here and asks for those answers first.

Each decision, ticket, or question takes one to three sentences, with its number and
title. Use the documents' concrete names and numbers rather than general statements.

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
pushed before this rebase, so the rebase needs no force push. The agent then checks the
spec and tickets against the code the current change landed, since reviews and final
acceptance can change a design after the next change's grill. It corrects the records
where they differ. A difference that shakes the next change's design goes to the owner
before implementation, as the second kind in
[Decisions made in implementation](#decisions-made-in-implementation).

### Implementation

Once the owner approves implementation, use `implement` or `implement-spec` with `tdd`.
Honor the owner's choice; otherwise choose by the work and state the reason:

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

Run the complete change review after the implementation tickets finish, not after every
ticket. Commit verified tickets or coherent groups and continue without asking at each
routine step.

### Work through a ticket

1. **Read its acceptance criteria.** Use the test approach agreed in the spec. If a
   criterion cannot be met as written, stop and ask the owner then; weaker acceptance
   needs the owner's decision first. Do not implement less than the spec asks. Where two
   texts of the spec disagree, in what they ask for or in how much, or this ticket's
   criteria contradict the spec, stop and ask the owner; do not choose between them. The
   spec passed its discussion and design review, so a disagreement left in it is a defect
   of the spec. Record the owner's answer in the spec and correct the text it overrules.
2. **Test the behavior, then implement it.** For new behavior or a bug fix, observe the
   test fail before the change and pass after it. For a refactor that preserves
   behavior, existing tests may be enough; name them in the ticket. For compiler,
   bytecode, or binary transformations, verify both preserved program behavior and the
   intended transformation effect, individually and in supported combinations.
3. **Run the relevant checks.** Run the tests the ticket adds or changes and the tests of
   the code it changes; do the same after each review round's repairs. Run the full local
   suite in the default configuration once per change, after the last ticket and before
   regular review. Do not repeat locally the configurations CI runs (other build
   configurations, sanitizers, simulators); run one of them locally only to diagnose its
   CI failure. A check CI cannot run runs when the work changes what it tests, and once on
   the landing candidate. If a test fails, establish the cause before trying a fix.
4. **Record the result.** Update the ticket's Status and acceptance checkboxes. Put
   significant test results, evidence links, and deliberately untested paths
   (`Untested paths: ... / why acceptable`) in Comments.
5. **Commit and continue** with the next unblocked ticket.

A test must check what the implementation produces: a return value, a specific error, a
state change, or another observable effect. A test that would still pass if the
implementation did nothing is not enough. Documentation and configuration changes use
checks suited to them, such as link validation and a command that loads the
configuration, without unrelated product suites.

### CI during implementation

Once remote CI exists, push the branch after each group of related tickets passes its
local checks, and continue with the next unblocked ticket rather than waiting for the
build. Handle the result when the build ends; diagnose a failure before fixing it. After
the last group, regular review starts without waiting for the build; a failure found
during review is repaired as a review finding is. Record each build, its tested commit,
and its result in the Comments of the ticket whose commit it tested, and commit that
record with the next commit rather than in a commit of its own. Such a push needs no
approval and does not replace the [remote CI gate](#ci-gate).

### Execution notes and probes

Ticket Comments explain failed attempts worth remembering and why they failed; they need
not list every command. Keep raw logs and temporary experiments in scratch space. A
program whose result backs a recorded decision is committed with the change: as a test in
the suite that owns the fact when later changes rely on it, otherwise under
`work-docs/<change>/probes/` with a header giving what it shows, the command, the
toolchain, and the output it printed. The decision cites the program.

Record out-of-scope problems in `work-docs/backlog.md` with context and evidence, or in
the relevant iteration plan when already assigned to an iteration.

### Decisions made in implementation

An implementer, the merger, or a review repair sometimes settles something the spec leaves
open or departs from it. What matters is whether the decision affects the design and the
change's goals:

1. **An implementation detail** that leaves the design and goals as they are, such as how
   a test is written, where a helper lives, the shape of an internal function, or two
   internal types merged into one. Write it into the spec with its source, for example
   `(Decided in ticket 05.)`. The reviews check it; the owner does not confirm it.
2. **A finding that shakes the approved design or goals:** the implementation approach
   does not work, the architecture or technical plan is wrong, an acceptance criterion
   cannot be met, or the change would do less than the spec asks. Stop and ask the owner
   at once ([Stopping points](#stopping-points)); the approved design may have a defect.
3. **An open point with real consequences** that does not overturn the design, such as
   what happens when a configuration file is missing. Choose, write it into the spec with
   the marker, for example `(Decided in ticket 05; pending owner confirmation.)`, and
   continue. [Final acceptance](#final-acceptance) lists these for the owner.

A new user-facing name is asked when it comes up ([Grill questions](#grill-questions)).
When the agent cannot tell which kind a decision is, it treats it as the heavier kind.

A decision put to the owner is written in the owner's language: what it is, what it
changes, and the recommended answer with its reason. It has no fixed form. A function or
file name may appear, with a few words on what it is. A design review finding and a
difference found by the rebase check before implementation are written the same way.

### Stopping points

After the owner approves implementation, routine implementation, testing, in-scope review
repairs, and commits continue without further approval. A test that fails at first calls
for diagnosis, not escalation. Stop and consult the owner for:

- a finding that shakes the approved design or goals (the second kind above), an
  architecture conflict, or scope expansion;
- a spec whose texts disagree, or a ticket that contradicts it;
- a weaker acceptance criterion, or required verification that cannot run;
- a new user-facing name;
- exhausted review rounds;
- a destructive or hard-to-reverse action.

## 5. Change review, acceptance, and landing

Review the complete change after its implementation tickets and local checks pass. Pin the
comparison base commit and candidate commit, export the diff and commit list to a
temporary directory outside the repository, and have each reviewer write its report to a
file there, such as `<dir>/r2-spec.md`. Before repairs start, record the round's findings
in `work-docs/<change>/review.md`. For each finding, record a stable ID, reviewer and review
type, round, reviewed commit, evidence, disposition, and verification; preserve rejected
findings and their reasons so they are not reopened without new evidence. Record each
round's model and effort.

Select runners, models, thinking levels, and Herdr tabs according to
[agent-environment.md](../agents/agent-environment.md). Reviewers run with fresh context
and read-only access to repository files:

1. **Regular review (`code-review`, up to 3 rounds).** Dispatch separate Standards and
   Spec subagents using the Large tier of the main agent's family at its highest supported
   effort (`xhigh`, or the model's highest effort). The
   brief includes the architecture invariants. The Spec reviewer also checks that formal
   decisions and code match recorded owner quotes without narrowing or widening them, and
   that each implementation detail recorded in the spec leaves the design and goals as
   they are.
2. **Expert review (up to 2 rounds).** After regular review converges, dispatch an
   independent read-only reviewer from another available primary model family (per
   [agent-environment.md](../agents/agent-environment.md), or an owner-specified family).
   The implementer never acts as its own expert reviewer. When a restricted third family
   is permitted by the project, the owner may request one optional extra review round on
   that family after expert review. Prompts for judgment, not a checklist: architecture,
   responsibilities, and simpler alternatives; concurrency and lifetime; resource and
   performance costs; error propagation and edge cases; realistic test gaps. Findings
   state concrete triggers, consequences, and evidence, and distinguish reproduced
   behavior from static evidence and unverified concerns.

Convergence means no unresolved material defect, verification gap, or design dispute;
naming preferences and other nitpicks do not require extra rounds. Later rounds read
`review.md` to verify earlier dispositions and review the repairs in the context of the
whole change. Repairs from expert review receive targeted verification without restarting
all regular review rounds. A change to approved scope, key design, or acceptance needs the
owner's decision first.

### CI gate

Changes to product code, tests, build files, or CI configuration must pass the applicable
remote CI pipeline on the reviewed candidate commit before landing (once remote CI is
established). A change whose files all match the pipeline's ignore list (records and agent
guidance, listed in the project's build guide) is exempt and uses document checks; before
remote CI exists, state that explicitly in verification notes. Push the working branch to
trigger CI without asking (normal push only, never force-push). A branch push does not
authorize landing. Use the project's CI skill or script, when it has one, to find the
build of a commit, wait for it in the background, and read a failing job's logs. Record
the build, tested commit, and result. A missing, running, canceled, or failed build leaves
the gate open.

### Final acceptance

Check the tickets, verification evidence, remaining issues, and agreement between design
and implementation. Present a final acceptance summary covering delivered behavior, test,
CI, and review results, deferred items, and every decision marked `pending owner
confirmation`, written as
[Decisions made in implementation](#decisions-made-in-implementation) describes, for the
owner to confirm one by one. A confirmed decision loses its marker. Landing waits until
every pending decision is confirmed, unless the owner says otherwise.

### Landing

Landing requires explicit owner instruction. On that instruction:

1. Record the owner's acceptance in the spec's Status and Comments on the change branch,
   and commit.
2. Check that the commits after the CI gate's tested commit change only paths the pipeline
   ignores; otherwise rerun the gate first.
3. Fast-forward the main branch to the change branch. If it cannot fast-forward, stop and
   ask the owner.
4. Record the landing: the spec's Status gives the landed commit and date, `progress.md`
   gives the landing date, and Current Focus moves on if the current change ended. Commit
   on the change branch and fast-forward the main branch again.
5. Push the change branch and the main branch.
6. Check each pushed ref separately: `git rev-parse <ref>` equals
   `git ls-remote origin refs/heads/<ref>`. Run one ref per call.

Do not delete branches or worktrees unless asked.

### Current Focus

`AGENTS.md` **Current Focus** is the single routing entry for active work. It names the
active milestone and its documents, the iteration plan, the current iteration in one
sentence, and the current change with its `work-docs/` directory, noting that the change's
records live on its branch until it lands. It carries no stage text such as
"implementation is in progress"; the spec's Status and Stage lines are the only record of
a change's stage. Current Focus changes only when the current iteration or change changes.
If the next change has not been selected, it says so. A next-change hint does not approve
implementation.

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
  transcripts, and where the owner corrected the agent or a decision went wrong. Workflow
  changes it proposes run as normal changes.
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
