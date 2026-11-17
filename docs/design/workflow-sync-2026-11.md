# Workflow sync 2026-11: design decisions

Status: grill complete (2026-11-16). The skill edits wait for the owner's instruction.

## The task

Bring `bstack-setup`'s generic workflow and document layout up to date with what a project
learned after it adopted an earlier version of them. A later, separate session migrates
that project onto the result.

The owner, 2026-11-16 (project name omitted): "接下来我想通过 bstack setup 来整理一下我们的文件和文档架构以及流程。不过我们的
workflow 已经和 bstack 有了一些偏离，我想先开一个 session，把 bstack 更新一下，然后再开一个 session 把
<project> 迁移到 bstack 的文档结构和workflow。"

## The evidence

The project changed its workflow through three recorded changes, each with a spec that
holds its decisions and the owner's reasons:

1. **A process retro** (2026-10-28). It reviewed four weeks of sessions and repaired what
   went wrong: decisions made after spec approval that never reached the owner, the
   owner's words narrowed in decision texts, user-facing names chosen ticket by ticket,
   stage text copied into `AGENTS.md`, review reports lost to context compaction, landing
   steps rebuilt each time, and CI builds started by records-only pushes.
2. **A workflow speedup** (2026-11-16). A script measured each stage's wall-clock time
   from the session transcripts of three changes. The largest lever was strict serial
   order: the next change's planning waited for the current change to land. Local test
   runs that repeated CI's configurations were the largest tool cost.
3. **Owner confirmations and a design review** (2026-11-16). One change collected 28
   decisions pending owner confirmation, most of them internal details the owner could
   not judge. The three decisions that were wrong did less than the spec asked, and the
   code review found them, not the confirmation. A spec had no reader but the owner
   before code was written.

Each decision below names what the project did, what bstack now does, and the reason.
The project is the source of evidence; the rules are written for any repository.

## How the decisions were made

The comparison found 24 differences. The owner decided nine of them directly. For the
other fifteen, the owner accepted the agent's preliminary judgment without a question
per item: "3 A" on 2026-11-16, to the option "明确的按初判处理，只把 4 条较重的逐条 grill". Those
fifteen are marked **(preliminary judgment)** below.

## Decisions

### Planning

#### D1. A discussion before the grill

Planning starts with a discussion. Either side opens: the owner states the background and
their thinking, or the agent reads the code and documents and explains the background,
the problem, and a rough design. The agent asks only what it needs to understand the
owner. It closes with a short summary of the background, the goal, and the rough design;
the owner corrects it. The grill starts when the owner agrees with the summary, and does
not ask again what the discussion settled. The summary is not a record; the spec records
what the grill settles. What the owner says in the discussion is quoted like the owner's
words in a grill.

Reason: a grill that opens with a list of questions gives the owner no picture to answer
from. (preliminary judgment)

#### D2. The grill's question format

Each question gives its background: what the thing is, the facts, and what each option
leads to, with a small example where it helps, and a recommended answer with its reason.
Progress shows as "question N of about M". One to three questions per message and a heavy
decision alone, as before. This overrides the grilling skill's single round of the whole
question list. (preliminary judgment)

#### D3. User-facing names are designed as one set

When a change adds or renames something users or the owner read (command-line commands
and options, public API names, file and directory names users see, user-facing messages),
the grill presents the whole set as one list. Each entry gives the name, its meaning, and
a plain-word alternative, checked against `GLOSSARY.md`. The spec records the list. A
ticket that needs a new user-facing name asks the owner when it comes up.

Reason: names chosen ticket by ticket made a user-facing tool inconsistent, and the owner
stopped implementation to redesign it. (preliminary judgment)

#### D4. The spec's walkthrough: a TL;DR, then the full walkthrough

`spec.md` opens with a TL;DR the owner can read in 10 minutes. The detailed plain-language
walkthrough follows it: background, problem, proposed behavior, design, the tradeoffs
actually weighed, boundaries, and verification, through concrete examples. The detailed
walkthrough is the owner's main design discussion surface, not a summary. This replaces
bstack's single walkthrough sized for 15 minutes.

The owner, 2026-11-16 (project name omitted): "workflow 需要先写一个 10 分钟能读完的 tl;dr, 然后写
<project> 里面要求的那些。这一项去 <project> 和 bstack 的结合。"

#### D5. A design review of the spec

After the spec is written and before its briefing, a model reviews the design read-only,
with fresh context, so that a design problem is found before any code exists. It judges,
as prompts and not a checklist:

1. whether the design is sound for the stated problem;
2. whether a better design exists, simpler or more reasonable: architecture and module
   boundaries, which module owns each responsibility and piece of state, and how the
   design serves evolution and maintenance over years;
3. whether it breaks an architecture invariant;
4. whether the spec agrees with itself and with the source design it cites.

The agent corrects what is plainly right. A finding that would change a decision goes to
the owner in the briefing, before the briefing's other questions. At most two rounds: the
second runs when round one's material findings changed the spec, after they are all
settled, and before the revision's briefing. Findings that remain go to the owner. Each
round, its model, and each finding's disposition go in the change's `review.md`.

The workflow names the reviewer by role: a family other than the implementer's,
preferring a third family that neither implements nor runs the expert review.
`agent-environment.md` names the current model (Gemini 4 Carbon at `high`, through `agy`).
When that model is unavailable, the agent reports it and the owner decides the
substitute; the agent does not substitute on its own or count the step as passed.

The owner chose A ("5 A") on 2026-11-16, over naming Gemini in the workflow and over
reusing the expert reviewer's family.

### Implementation

#### D6. Decisions made in implementation: three kinds

A decision made in implementation settles something the spec leaves open or departs from
it. The test is whether it affects the design and the change's goals, not whether a user
or the owner can see it:

1. **An implementation detail** that leaves the design and goals as they are: how a test is
   written, where a helper lives, the shape of an internal function, two internal types
   merged into one. The agent writes it into the spec with its source, such as
   `(Decided in ticket 05.)`. The reviews check it; the owner does not confirm it.
2. **A finding that shakes the approved design or goals**: the implementation approach does
   not work, the architecture or technical plan is wrong, an acceptance criterion cannot
   be met, or the change would do less than the spec asks. The agent stops and asks the
   owner at once.
3. **An open point with real consequences** that does not overturn the design, such as what
   happens when a configuration file is missing. The agent chooses, marks it
   `(Decided in ticket 05; pending owner confirmation.)`, and continues. Final acceptance
   lists these for the owner.

A new user-facing name is asked when it comes up (D3). When the agent cannot tell which
kind a decision is, it treats it as the heavier kind. A decision put to the owner is
written in the owner's language: what it changes and the recommended answer with its
reason; a function or file name may appear with a few words on what it is.

This replaces bstack's rule that every open detail carries the marker. The project had
tried a different test, whether an app or the owner sees the result; the owner rejected
it. The owner, 2026-11-16 (project name omitted): "其实 owner 看不看得到不是一个好的标准，主要是
测试怎么写、helper 放哪这类内部细节，这类特别具体的，但是不影响我们的设计和目标的问题，不要确认了。但是其他的比如发现了实现方法有问题，架构和技术方案有问题，验收标准达不到，或者会引发实际问题的，这些需要确认，这些有些
owner 能看到有些不能看到。 这个 <project> 那边讨论出来的“ owner 看不看得到” 标准不合适。"
The owner then chose A ("A"): the third kind waits for final acceptance rather than
stopping the work, since dependent work does not build on a wrong design.

#### D7. The spec's texts disagree; never less than the spec

The agent does not implement less than the spec asks. Where two texts of the spec
disagree, in what they ask for or in how much, or a ticket's criteria contradict the spec,
the agent stops and asks the owner; it does not choose between them. The owner's answer is
recorded in the spec and the overruled text is corrected. The spec passed its discussion
and its design review, so a disagreement left in it is a defect of the spec.

Reason: the three wrong decisions in the evidence each did less than the spec, one of them
by following a narrow list where a user story asked for more; its repair touched 93
files. (preliminary judgment)

#### D8. Local checks stay small; CI runs the matrix

1. After a ticket, and after each review round's repairs, the agent runs the tests the
   ticket adds or changes and the tests of the code it changes.
2. The full local suite in the default configuration runs once per change, after the last
   ticket and before regular review.
3. Configurations CI runs (other build configurations, sanitizers, simulators) are not
   repeated locally; a local run of one diagnoses its CI failure. A check CI cannot run
   runs when the work changes what it tests, and once on the landing candidate.
4. After each group of related tickets the agent pushes the branch and lets CI run while
   it continues with the next ticket. It handles the result when the build ends; a
   failure is diagnosed before it is fixed. Regular review starts without waiting for the
   last build; a failure found during review is repaired as a review finding.
5. A CI result during implementation goes into the Comments of the ticket whose commit it
   tested and is committed with the next commit, not in a commit of its own.

The pre-landing CI gate is unchanged. Reason: local suites that repeated CI's matrix were
the largest tool cost, and CI found problems the local default runs missed.
(preliminary judgment)

#### D9. Rules in an implementer's brief

With `implement-spec`, each implementer and the merger start with fresh context. Their
brief carries D6 and D7. An implementer sets its ticket's Status to in progress at the
start and commits each completed ticket, so the worktree's log and the ticket file show
progress. Reason: progress read from subagent transcripts failed. (preliminary judgment)

#### D10. Planning the next change beside the current one

Once the owner approves the current change's implementation, the next change may run its
discussion, grill, spec, and tickets in its own session and branch, each stage on the
owner's instruction. By default its code waits until the current change lands, so one
change at a time changes code. The owner may approve two changes implementing at once
when `bstack-control`'s overlap check finds no shared area and the plan sets no
dependency between them.

After the current change lands and before the next change's implementation starts, the
next change's agent rebases its branch onto the new main branch and checks its spec and
tickets against the landed code. The branch is not pushed before this rebase, so the
rebase needs no force push. The agent corrects records that differ; a difference that
shakes the design goes to the owner as D6's second kind. Current Focus keeps naming the
current change until it lands.

`bstack-control`'s "After a landing" adds a reminder: when a next change was planned
beside the landed one, its session rebases and checks its spec before it implements.

Reason: the measured changes spent four to five hours of serial agent work each, while the
owner was idle during implementation and review. Parallel implementation was not chosen
as the default because changes that share files cost rebases and repeated reviews. The
owner chose B ("B") on 2026-11-16.

### Completion

#### D11. Landing follows a written list

On the owner's instruction to land:

1. Record the owner's acceptance in the spec's Status and Comments; commit.
2. Check that the commits after the CI gate's tested commit change only paths CI ignores
   (D12); otherwise rerun the gate first.
3. Fast-forward the main branch to the change branch. If it cannot fast-forward, stop and
   ask the owner.
4. Record the landing: the spec's Status gives the landed commit and date, and the
   milestone's progress record gives the landing date; Current Focus moves on if the
   current change ended. Commit and fast-forward again.
5. Push the change branch and the main branch.
6. Check each pushed ref separately: `git rev-parse <ref>` equals
   `git ls-remote origin refs/heads/<ref>`, one ref per call.

Reason: agents rebuilt the landing steps from earlier commits each time, and four
landings failed on the same command. (preliminary judgment)

#### D12. The CI exemption follows CI's ignore list

A change whose files all match the CI pipeline's ignore list (records and agent guidance)
needs no remote CI gate; it uses document checks. The project's build guide lists the
ignored paths, and the CI configuration skips pushes that touch only them. This replaces
"documentation-only changes". (preliminary judgment)

#### D13. Current Focus routes; the spec records the stage

`AGENTS.md` Current Focus names the active milestone, the iteration plan, the current
iteration in one sentence, and the current change with its `work-docs/` directory, noting
that the change's records live on its branch until it lands. It carries no stage text
such as "implementation is in progress". The spec's Status and Stage lines are the only
record of a change's stage. Current Focus changes only when the current iteration or
change changes. `progress.md` records start and landing dates, not intermediate stages.

Reason: 66 of 648 commits in one month touched `AGENTS.md` only to move a stage, and the
copies disagreed. (preliminary judgment)

#### D14. Landing waits for the pending confirmations

The acceptance report lists every decision marked pending owner confirmation, written as
D6 says, for the owner to confirm one by one. A confirmed decision loses its marker.
Landing waits until every one is confirmed, unless the owner says otherwise.
(preliminary judgment)

#### D15. A script for the remote CI gate

When a project has remote CI, it keeps a project skill with a script that finds the build
of a commit, waits for it in the background, and downloads a failing job's logs. The
workflow's CI gate points to it, and `bstack-setup` asks about it when a project has CI.

Reason: three sessions made 177 calls to the CI tool and wrote 15 different wait loops.
bstack ships no script; each CI service differs. (preliminary judgment)

### Documents and records

#### D16. Change directories outside an iteration

A change inside an iteration uses `work-docs/m<x>-i<y>-<slug>/`. Work outside an
iteration, such as a retro, a series of refactoring changes, or a workflow change, uses a
descriptive slug with no required pattern.

The owner, 2026-11-16: "迭代外的工作 不强制命名方式".

#### D17. Planning decisions live in their owning document

bstack's rule stands: a planning decision goes in the document that owns the topic
(`roadmap.md`, `milestone.md`, `iteration.md`, or a `design/` document), with the owner's
words quoted beside it; there is no `decision-log.md` by default. The project's milestone
decision log moves into those documents when it migrates.

The owner, 2026-11-16: "已 bstack 为准，<project> 也要迁移" (project name omitted).

#### D18. An architecture directory and an archive

- `docs/arch/architecture.md` describes the system as it is: its parts, their
  responsibilities and boundaries, and its invariants. Module-level documents may join it
  in `docs/arch/`. `AGENTS.md` required reading adds: architecture, design, or invariants
  → read `docs/arch/architecture.md`.
- `docs/archive/` holds superseded designs, plans, and records, kept for provenance. They
  are not the current source of truth and need no routine reading.

Reason: `docs/guide/` describes how to work; the architecture describes what the system
is. Keeping them apart makes each easy to find.

The owner, 2026-11-16: "bstack 加上 archive，也加上架构文档。" The owner chose A ("1 A") for
`docs/arch/` over `docs/guide/architecture.md`.

#### D19. The retro also reviews the workflow

A retro may review the workflow itself: where each stage's time went, measured from
session transcripts, and where the owner corrected the agent. Workflow changes it
proposes run as normal changes. Reason: the project's two workflow changes started from
such a review and measurement. (preliminary judgment)

#### D20. Hooks

`.agents/hooks/` holds the canonical hook scripts; each agent tool keeps only a thin
adapter or configuration that points at them, and a `README.md` there lists the scripts
and the adapters. bstack recommends a guard that blocks git commands that discard work or
rewrite a branch (`reset --hard`, forced `clean`, `branch -D`, force push), and states its
rules; it ships no script in this round. (preliminary judgment; that bstack ships no
script is the agent's reading, since bstack takes no code from the project.)

### Agents and writing

#### D21. Model and runner rules

bstack keeps its tier names (XL, Large, Medium, Small) and adds to `agent-environment.md`:

1. Only the Large and XL tiers of the Claude and GPT families implement or run a code
   review.
2. When a required model is unavailable, the agent reports it and records any
   substitution; it does not substitute silently or count the step as passed.
3. `review.md` records each review round's model and effort.
4. A lightweight task given to a smaller model reads and reports only. Its output is a
   lead; the main agent checks the cited files and lines before relying on it.
5. Before the first `pi` run from Claude Code or Codex, the agent asks the owner; the
   permission covers the scope the owner states. When `pi` stands in for an unavailable
   harness, the record names the harness, the reason, and the model that ran.

The owner chose A ("6 A") on 2026-11-16.

#### D22. Writing rules

The root `AGENTS.md` Writing section adds:

- Answer the question asked, without an unrequested proposal or an offer to start work.
  Do not comment on how large or hard the work is.
- Write passed and failed, not red and green. Durable prose and commit messages omit test
  counts.
- Define a name, abbreviation, or number on first use.
- Use a selection form only when the options are real, few, and mutually exclusive.

(preliminary judgment)

#### D23. The ownership rule

The root `AGENTS.md` Ownership rule takes the fuller text: prefer the design that stays
clear and easy to change over the one quickest to write; leave what you touch at least as
readable as you found it; this is judgment, not a checklist. (preliminary judgment)

#### D24. Personal rules live in `AGENTS.local.md`

The owner's personal working rules, such as how to explain and report, go in
`AGENTS.local.md`, not in the shared `AGENTS.md`. The file takes any topic; its template
shows language and working-preference examples. It still cannot relax `AGENTS.md`'s
working rules: a member's file must not lift a safety rule such as "pushing the main
branch needs the owner's instruction" for everyone's agents. `bstack-setup`'s migrate
workflow offers to move personal rules it finds in a shared `AGENTS.md` into
`AGENTS.local.md`.

The owner, 2026-11-16: "可以放在 AGENTS.local.md ，这个 AGENTS.local.md 的内容不做限制". The owner
then chose A ("2 A"): any topic, but no relaxing of the working rules.

## Not carried over

- **Rules both already had:** the owner's words quoted verbatim and the Spec review axis
  checking them for narrowing; programs that back a decision committed as tests or probes;
  review reports written to files.
- **A design explainer page** made by a subagent after the spec. The project designed it
  but never adopted it; the owner found such pages hard to read and preferred a walk
  through in the conversation.
- **Project-specific rules:** a vendored submodule's push rules, device test runs, fixture
  rules, binary inspection commands, and the project's model version table.

## Files the edits touch

- `skills/bstack-setup/references/docs/guide/workflow.md`: D1–D11, D13, D14, D16, D19.
- `skills/bstack-setup/references/docs/agents/`: `issue-tracker.md` (D4, D16),
  `domain.md` (D17), `agent-environment.md` (D5, D21).
- `skills/bstack-setup/references/root-AGENTS.md`: D13, D18, D20, D22, D23, D24.
- `skills/bstack-setup/references/root-AGENTS.local.md`, `docs/README.md`, new
  `docs/arch/architecture.md` and `docs/archive/` (D18, D24).
- `skills/bstack-setup/SKILL.md` and `workflows/` (D15, D18, D20, D24);
  `skills/bstack-control/roles/control.md` (D10).

## Next step

Edit the skills on the owner's instruction (stage 4 of the session brief). Pushing this
repository needs the owner's instruction.
