# bstack-control: design decisions

Status: grill complete (2026-11-15); the skill is in `skills/bstack-control/`. The design
covers two roles: the per-project control session and the cross-project chief-of-staff
session. (Follow-up updates: [T3 Code as a peer host](./t3-code-host-2026-11.md) and
[Unify coordinator cwd onto `<project>_workspace/`](./control-workspace-cwd-2026-11.md).)

## The mode

One long-lived **control session** sits in a repository's main checkout and edits nothing
there. For each piece of change work, on the owner's word, it creates a branch and a git
worktree, opens a Herdr tab there, starts an agent in it, briefs that **change session**
through a brief file, and tracks its state for the owner. The owner works with each change
session directly in its tab. The control session never answers, approves, accepts, lands,
or pushes on the owner's behalf.

The owner, 2026-11-15: "我们这种控制台模式，我觉得比较好，你开一个 herdr session，我们在那个
session，把这种模式通过 skills 定下来".

The owner, 2026-11-15, on where it lives: "我希望是一个 bstack 里面的 skills".

## Goals

The owner works on several projects at once and also handles small tasks between them:
customer questions, consultations, ad-hoc ideas, organizing files on the computer, and
agent configuration. The aim is to reduce the owner's mental load. Sessions above the work
dispatch tasks, track their state, gather information, and give recaps. The actual work
happens in separate work sessions.

1. **One control session per project.** Each project has its own Herdr workspace, and its
   first tab holds the project's control session (for example `<project> control`).
2. **Entry and recap.** When the owner comes to a project (the first time each day, or after
   switching from another project), the control session reports the project's progress
   and what needs the owner's attention, then recommends the next work session and its
   workflow.
3. **Any kind of work session.** A work session may drive one change, discuss a milestone
   or iteration plan, run a retro (whole-codebase review or refactoring), handle a trivial
   task, or do work outside the workflow.
4. **What matters most:** tracking state across sessions, and complete handoffs to new
   sessions. Saving setup steps comes next. The safety rules (no stage skipping, no
   answering, landing, or removing on the owner's behalf) are the floor.
5. **A chief-of-staff session across projects** (designed together with the control
   session, D4). It works in its own directory, a chief workspace that lists the projects the
   owner follows, and has its own Herdr workspace. It can talk with the control sessions,
   look at work sessions, produce what needs the owner's attention, and do document work
   such as monthly reports. D5 sets its first duties.
6. **Model:** the control session runs on the Medium tier.
7. **Worktree location:** worktrees live in `<project>_workspace/worktrees/`. The bstack
   setup should state this.

The owner, 2026-11-15 (project and platform names omitted): "我希望 control session
减轻我的心智负担。帮我派发任务，跟进任务的状态，汇总信息，帮我 recap 等，但是实际的工作，还是在各个具体的
agent session 里面工作。" and "control session 使用 Medium tier 的 model 就行了。" and
"worktree，都放在 <project>_workspace/worktrees/ 目录".

## Decisions

### D1. How general the skill is

The skill holds a generic core: the control session's role, its steps, and the Herdr
mechanics. The project part (stage order, landing and push rules, the main branch's name,
record paths) is read at run time from the target repository's `AGENTS.md` and the
workflow documents it links. When the repository does not say, the control session asks
the owner. The bstack workflow stages appear only as an example.

Reason: the one project that runs the mode today uses a different workflow path, main
branch name, and record directory layout than the bstack reference. A skill bound to the
reference's literal paths would be wrong there. bstack is public, so project details can
only come from the target repository at run time.

The owner (project name omitted): "<project> 将会迁移到 bstack". The skill stays generic
after that migration as well.

### D2. Where these decisions are recorded

In this file, `docs/design/<skill-name>.md`, on a branch of bstack. bstack does not adopt
the full bstack workflow (no `work-docs/`, spec, or tickets).

The owner: "我们这个仓库还没 setup matt-pocock 的工作流。不过考虑到我们这个仓库的工作比较简单，
我认为我们这个就只有 docs/design/<skill-name>.md 简单记录就行了。 不需要搞完整的 workflow".

### D3. Which agents the skill supports

Claude Code first; the rest stays agent-neutral where it can. Herdr mechanics and rules are
written for any agent kind. Lessons specific to Claude Code (its suggested reply in the
input box, its auto-mode classifier, the sleep API error, a first slash command) are marked
as such. The change session's agent kind is a parameter that defaults to the control
session's own kind.

Reason: `install.sh` links bstack skills into Claude Code, Codex, pi, and Gemini skill
directories, but the mode has run only on Claude Code. The Claude Code lessons are
verified and worth keeping; marking them keeps them from misleading another agent.

### D4. Scope of this round

The control session and the chief-of-staff session are designed and built together in
this round, rather than the control session first.

The owner chose option B on 2026-11-15 ("B"), over building the control session first with
a fixed state file that the chief-of-staff reads later.

### D5. The chief-of-staff's first duties

1. **Daily summary.** It reads each project's control-session state and reports what needs
   the owner's attention today, and in which project.
2. **Entry for work outside the projects.** Customer questions, consultations, ad-hoc
   ideas, organizing files, and agent configuration go to the chief-of-staff. It opens
   work sessions in the chief workspace, briefs them, and tracks them, as a control
   session does for project work.
3. **Document work.** It writes documents such as monthly reports from the projects'
   records.

It does not pass the owner's instructions on to a control session in the first version;
the owner tells a project's control session directly in that project's Herdr workspace.

The owner chose a, b, and c ("6 abc") on 2026-11-15.

### D6. Names in this public repository

No project or internal platform names appear in bstack; records use placeholders such as
`<project>`. The owner chose C ("7 C") on 2026-11-15.

### D7. The worktree directory

The skills and the bstack setup references use `<project>_workspace/worktrees/`. A project
that uses another directory renames it when it migrates to bstack (`git worktree move`,
after closing the sessions running in those worktrees). The owner chose A ("8 A") on
2026-11-15.

### D8. Where the state lives

Each project keeps its control-session state in `<project>_workspace/control/`, beside
`worktrees/`, outside git:

- `status.md`: the status table (work item, branch, session, stage, waiting on whom), what
  needs the owner, the next step, and to-dos and ideas the owner mentioned.
- `briefs/<name>.md`: each work session's brief.

The chief workspace has the same structure, plus a list of the projects with each
project's workspace path. The repository's own records (Current Focus, spec Status lines)
stay the source of project progress; `status.md` holds only what the repository does not.
On start, a control session reads `status.md` and checks it against `git worktree list`
and `herdr agent list`.

Reason: `/private/tmp` is cleared on reboot, and Herdr sessions end with a reboot. A
tracked file would conflict with the rule that the control session edits nothing in the
main checkout, and would fill the history with status churn. The owner chose A ("A") on
2026-11-15.

### D9. How the chief-of-staff learns each project's state

It only reads: each project's `control/status.md`, plus `herdr agent list` and
`herdr agent read` for live session state. It sends no messages to control sessions. In
turn, a control session updates `status.md` at once whenever its state changes.

Reason: a message to a control session is typed into its tab and can mix with the owner's
own typing there. The owner chose A ("10A") on 2026-11-15.

### D10. Where personal settings live

The owner's preferences stay in the main checkout's gitignored `AGENTS.local.md`, the
bstack convention. When a control session creates a worktree, it links that worktree's
`AGENTS.local.md` to the main checkout's file. A brief then says only to read
`AGENTS.local.md`; it does not copy the preferences. Claude Code memory needs nothing: a
session in a git worktree already uses the main checkout's memory directory.

Reason: one source, readable by Claude Code and Codex alike; `git worktree add` does not
check out a gitignored file. The owner chose A ("A") on 2026-11-15, after asking why a
worktree would not see settings configured on the main branch ("为啥看不到？我 master 上配置好了，
以后能看到啊").

### D11. One skill, split by role

One skill holds both roles, laid out like `bstack-setup`:

```
skills/bstack-control/
├── SKILL.md              shared rules; decides the role, then reads only that role's file
├── roles/control.md      the project control session: recap, dispatch, tracking
├── roles/chief.md        the chief-of-staff: daily summary, outside work, documents
└── references/
    ├── work-brief.md     the work-session brief template
    ├── status.md         the format of `status.md`
    └── herdr.md          Herdr mechanics and lessons (load `/herdr` first)
```

The role follows from the working directory: a directory holding the project list is the
chief workspace; otherwise the session is a project's control session.

Reason: the shared rules and Herdr mechanics are written once, a session reads only its
role's file, and the layout matches `bstack-setup`. Two skills would either duplicate the
shared part or depend on a cross-skill path that a plugin install can break.

### D12. The name

`bstack-control`, invoked as `/bstack-control`. Its description is a listing line only,
because bstack skills set `disable-model-invocation: true`.

### D13. Changes to `bstack-setup` and the README

1. `skills/bstack-setup/references/docs/guide/workflow.md`, section 2, states that
   worktrees live in `<project>_workspace/worktrees/` (D7).
2. The README's skill table gets a row for `bstack-control`.
3. The workflow does not describe the control session; a project works the same without
   it.

D11 to D13: the owner agreed to all three recommendations ("都同意") on 2026-11-15.

### D14. Overlap check

At each recap and before dispatching a new work session, the control session compares the
files each active branch changes against the main branch (`git diff --name-only`) and
judges overlap by area, not only by exact path. On an overlap it first looks for the order
in the project's plan (for example the change plan or the order of planned changes).
When the plan sets the order, the report states it as information, such as which branch
lands first and which one rebases after. The control session asks the owner only when the
plan does not set the order, or when the two pieces of work change the same behavior in
different directions. Work sessions do not settle an overlap between themselves.

Revised after the owner, 2026-11-15: "报告给你，由你决定谁先合入 这个也存疑，其实很多时候，谁先合入，
就是看计划的顺序而已".
A work session and its own review tabs or implementation worktrees do not overlap with
each other.

### D15. What counts as needing the owner

`references/status.md` lists both sides. Needs the owner: a session blocked on an approval
or question dialog; a last reply that asks the owner for a decision or action not yet
given, including an action a permission check refused; a session reporting a failure it
cannot fix; a host problem. Does not need the owner: waiting on CI or on another person's
approval; text in a session's input box (often the agent's suggested reply); a question
the owner already answered.

### D16. A fixed recap layout

A recap is readable in seconds and keeps one order: needs you, overlaps, working, waiting,
idle, host. The host line covers problems seen in practice, such as the machine having
slept or low disk space.

D14 to D16 come from a published write-up of a similar practice
(halcight.dev, "managing a dozen agents"). The owner agreed to all three ("1 2 3 同意") on
2026-11-15.

### D17. Sessions a work session opens itself

There is no depth limit. A work session opens review tabs and, with `implement-spec`,
its own worktrees for tickets; the project workflow requires both. The control session
counts them as part of that work session in its status table and overlap check, and does
not close them.

The owner rejected a two-level limit: "工作 session 自己开 review tab 是我们 workflow 的规定。
工作 session 也可能使用 implement-spec，就是自己开 worktree 的形式实现 tickets，这都是我们的工作流的一部分".

### D18. Periodic polling for information

Polling gathers information, not only state, and is split by role:

- A control session polls its own project: CI results, new review comments, new commits
  on the main branch, and a progress summary of each work session (what it produced, not
  only whether it waits). It writes them into `status.md`.
- The chief-of-staff polls sources outside the projects and reads each project's
  `status.md`, then summarizes what needs the owner.

The default interval is 30 minutes and can be changed. Entering a project or asking for a
recap refreshes at once. The owner chose A ("A") on 2026-11-15, after noting:
"轮询不一定是为了获取状态，可能也是为了获取信息".

### D19. The chief-of-staff's outside sources

The skill names no source. The chief workspace holds a `sources.md` that lists each
source and the skill or command that reads it; the skill defines only that file's format.
With an empty list, the chief-of-staff summarizes the projects alone.

Reason: internal tool names cannot appear in this public repository (D6), and a new source
needs only an edit to one file. The owner chose A ("A") on 2026-11-15.

### D20. Pointers, not copies

When a work session waits on the owner, a coordinator reports a pointer: the session, the
tab, and the kind of wait in one line (such as "grill question 4 of about 7"). It does not
repeat the question's text, background, options, or recommendation; the owner reads and
answers them in the work session's tab.

The owner, 2026-11-16 (project name omitted): "我发现现在的 <project>-control 里面，总是把工作 agent 的 grill 问题原样输出让我回答，
这不好，这是重复冗余。不要这样做".

## Next step

The owner said to write the skill ("写", 2026-11-15). Pushing this repository needs the
owner's instruction.
