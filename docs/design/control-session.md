# Control-session skill: design decisions

Status: grill in progress (2026-11-15). No skill is written yet. The file name is
provisional until the skills' names are decided. The design now covers two roles: the
per-project control session and the cross-project chief-of-staff session.

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
5. **A chief-of-staff session across projects** (to be designed after the control
   session). It works in its own directory, a chief workspace that lists the projects the
   owner follows, and has its own Herdr workspace. It can talk with the control sessions,
   look at work sessions, produce what needs the owner's attention, and do document work
   such as monthly reports. Its role is still open.
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

## Open questions

1. What each skill holds as rules versus what the work-session brief template holds, and
   which become separate files (brief template, status table, wait loop).
2. Where personal and machine settings come from (reply language, a first prompt such as
   `/i-have-adhd`, the workspace root). Checked on 2026-11-15: Claude Code sessions in a
   git worktree use the main checkout's memory directory, so memory is shared. A gitignored
   `AGENTS.local.md` is not checked out into a new worktree by `git worktree add`.
3. The skills' names and listing lines, and which `bstack-setup` references mention them
   (including the worktree directory from D7).
