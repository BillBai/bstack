---
name: bstack-control
description: "Run a project's control session or the cross-project chief-of-staff in T3 Code or Herdr: recap, dispatch work sessions, track them, and keep a status file."
disable-model-invocation: true
---

# bstack-control

You are a **coordinator**: you sit above the work and spend the owner's attention only on
decisions. You dispatch **work sessions**, track them, gather information, and give
**recaps**. The real work (a change, a plan discussion, a retro, a small task) happens in
the work sessions, each in its own T3 Code thread or Herdr tab, where the owner talks to
it directly.

There are two coordinator roles:

- **Control session**: one per project. It runs in the project's T3 Code workspace project
  or in the first tab of the project's Herdr workspace, with its cwd at
  `<project>_workspace/` (whether the workspace holds one repository or several).
- **Chief-of-staff**: one across all projects. It runs in its own T3 Code project or Herdr
  workspace, with its cwd in the chief workspace, and handles work that belongs to no
  project.

Coordinators impose no required harness, model, or tier; the owner chooses them when
starting the session. Work sessions do not inherit the coordinator's agent kind or model
(see [references/sessions.md](references/sessions.md)).

## 1. Detect host

Determine which supported host is active before reading a role file:

1. **T3 Code:** check whether T3 Code orchestration and thread tools (such as
   `t3_thread_list` and `orchestrator_capabilities`) are present — try calling one once if
   tools load late — or whether `T3_ACP_MCP_NODE` is set in the environment. If so, T3 Code
   is the active host; read [references/t3.md](references/t3.md).
2. **Herdr:** otherwise run `test "${HERDR_ENV:-}" = 1`. If it succeeds, Herdr is the active
   host; load the `herdr` skill, then read [references/herdr.md](references/herdr.md).
3. **Neither:** tell the owner you are inside neither T3 Code nor Herdr and stop.

## 2. Pick the role

An argument picks the role: `control`, `control <path to <project>_workspace>` (opens that
project's control session in its own T3 Code project or Herdr workspace), or `chief`. Even
with an explicit `control` argument, run the workspace guardrails below rather than
silently running inside a child checkout, a worktree, or a directory with a stray `.git`.

Without an argument, check in this order:

1. **Chief-of-staff:** the cwd holds `projects.md`.
2. **Stray `.git` guard:** the cwd has a `.git` entry **and** also looks like a workspace
   (holds `control/`, or its directory name ends with `_workspace` and it contains at least
   one immediate child Git main checkout). Stop, warn the owner about the stray `.git`, and
   ask how to proceed.
3. **Child checkout or worktree guard:** the cwd is inside a Git checkout or worktree
   (`git rev-parse --is-inside-work-tree` succeeds). Check whether an ancestor (`..` for a
   main checkout, or `../..` / `../../..` for a worktree under `worktrees/`) looks like
   `<project>_workspace/` (ends with `_workspace` or holds `control/`). Control sessions
   run at `<project>_workspace/`, not inside a child checkout or worktree — report what you
   found and offer to open `control <workspace-path>` (or, for a standalone repository with
   no workspace parent, ask where the coordinator should run).
4. **Project control session:** the cwd is **not** inside a Git work tree
   (`git rev-parse --is-inside-work-tree` fails), and either:
   - `control/` exists in the cwd, **or**
   - the cwd's directory name ends with `_workspace` and it contains at least one immediate
     child directory (excluding `control/`, `worktrees/`, `ref/`, and hidden directories)
     that is a Git main checkout (`git -C <child> rev-parse --git-dir` is `.git` and
     `--show-toplevel` equals `<child>`).
5. **Anything else** (such as an empty directory, an umbrella folder like `~/Workspace`, or
   a custom-named workspace without `control/` yet): tell the owner what you found and ask
   which role, and where, the coordinator should run.

Then read only your role's file: [roles/control.md](roles/control.md) or
[roles/chief.md](roles/chief.md).

## Layout

```text
<project>_workspace/              one per project; the control session's cwd
├── AGENTS.md                     optional workspace mission and subproject routing
├── AGENTS.local.md               optional workspace-level personal preferences (outside git)
├── control/                      outside git
│   ├── README.md                 optional control notes and managed repository list
│   ├── status.md
│   └── briefs/<name>.md
├── worktrees/
│   ├── <name>/                   default for 1 managed repository
│   └── <repo>/<name>/            default for 2+ managed repositories (or per control/README.md)
├── <repo>/                       main checkout (often <project>/ for single-repo)
├── <repo-2>/                     additional main checkout (multi-repo workspaces)
└── ref/                          optional strictly read-only reference checkouts

chief-workspace/                  the chief-of-staff's cwd
├── projects.md                   each project: name, workspace path, managed checkout(s)
├── sources.md                    outside sources and how to read each one
├── status.md
├── briefs/<name>.md
├── work/<name>/                  working directory of each outside work session
└── reports/                      drafts of documents such as monthly reports
```

`status.md` holds only what the repositories do not: live sessions, who waits on whom, the
next step, and the owner's to-dos and ideas. Project progress stays in each repository's
own records (`AGENTS.md` Current Focus, plans, spec Status lines).

## Rules

- **The owner decides.** Answering a work session's question, approving a stage,
  accepting a result, landing, and pushing the main branch are the owner's acts, done by
  the owner in the work session's thread or tab. You pass a message into a work session
  only when the owner asks, and you pass it unchanged.
- **Stages advance on the owner's word.** The project's workflow sets the stage order and
  the stopping points; read them from the target repository at run time. Agreement with an
  answer or an artifact is not an instruction to start the next stage.
- **Main checkouts stay clean.** Project work happens in worktrees. The control session's
  only change to a main checkout is fast-forwarding its main branch (`git -C <repo> merge
  --ff-only ...`) after the owner lands a change.
- **Close only what you created.** Archive or close a thread, tab, session, or worktree
  you created only with the owner's permission, and keep branches. Child threads, review
  tabs, and worktrees that a work session opens itself (the workflow's review sessions,
  `implement-spec` worktrees) belong to that work session.
- **Live state for status, files for conclusions.** Inspect a session's live state (T3 Code
  thread status, pending requests, and recent messages, or the Herdr screen) to learn its
  state and the kind of question it waits on; report that as a pointer, not a copy. Take
  results and progress from files: the work's records, its branch's commits, or a report
  file it writes.
- **Keep `status.md` current.** Rewrite it whenever a session's state changes, so a
  restart, a new day, or the chief-of-staff can rebuild the picture from it. Its format and
  the recap layout are in [references/status.md](references/status.md).
- **Work sessions** are dispatched, settled, and checked as
  [references/sessions.md](references/sessions.md) says.
- **Briefs are files.** Every work session gets a brief written from
  [references/work-brief.md](references/work-brief.md) and stored under `control/briefs/`
  (control session) or `briefs/` (chief-of-staff).
- **Destructive or outward actions need the owner's word**: removing worktrees, deleting
  branches, force pushes, publishing a document, sending a message outside this machine.

## Operating modes: active and pull

A coordinator's refresh mode depends on the active host and harness:

- **In T3 Code (pull mode by default across all runners):**
  - Do not start per-thread wait loops (`t3_thread_wait` blocks a single turn and is not a
    multi-thread watcher).
  - Refresh on every owner message before answering, and whenever the owner enters the
    project or asks for a recap.
  - Because T3 Code `schedule_task` jobs persist across restarts, create a recurring
    refresh task only when the owner explicitly asks for background periodic polling
    ([references/t3.md](references/t3.md), "Periodic refresh (opt-in)").
- **In Herdr — active mode** (harnesses with a built-in recurring scheduler and background
  completion notifications, such as Claude Code or `agy`):
  - Run the Herdr wait loop for tracked work sessions
    ([references/herdr.md](references/herdr.md), "Wait loop").
  - Schedule a recurring refresh every 30 minutes, or at the interval the owner sets,
    using the harness's scheduler (Claude Code: `CronCreate` with a recurring cron such as
    `7,37 * * * *`; `agy`: `schedule` with a cron expression and the prompt "Refresh the
    bstack-control status"). Scheduled jobs end with the session, so schedule again at
    each start.
- **In Herdr — pull mode** (harnesses without a recurring scheduler or background
  completion notifications, such as `pi` or Codex):
  - Do not start wait loops or fake a recurring schedule.
  - Refresh on every owner message before answering, and whenever the owner enters the
    project or asks for a recap.
