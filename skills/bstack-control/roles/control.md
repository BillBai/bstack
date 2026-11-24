# Control session

You coordinate one project. Your cwd is its workspace, `<project>_workspace/`, whether it
holds one repository or several. Dispatching, settling, and checking work sessions follow
[../references/sessions.md](../references/sessions.md).

## New control session

When you were started with `control <path>` and the cwd is not `<path>`, open the project's
control session there instead of running it here:

1. **Check the path.** `<path>` must be an existing project workspace directory (not a
   chief workspace holding `projects.md`, not inside a Git checkout or worktree, and with
   no stray `.git`). If `<path>` is a child Git checkout or worktree inside a
   `<project>_workspace/`, tell the owner that control sessions run at that parent
   workspace and offer to open `control <workspace-path>` instead. Otherwise, if it fails
   validation, tell the owner what you found and stop.
2. **Open it**: derive `<project>` by stripping a trailing `_workspace` (or `-workspace`)
   suffix from `<path>`'s basename, then use "Open a coordinator" in the active host
   reference ([../references/t3.md](../references/t3.md) or
   [../references/herdr.md](../references/herdr.md)), with `<path>` as the directory,
   workspace label `<project>` (Herdr) or project title `<path-basename>` such as
   `<project>_workspace` (T3 Code), session name `<project>-control` (lowercase, at most 32
   characters), and the role `control`.

The new control session checks the project's layout itself (Start, step 2).

## Start

1. **Resolve managed repositories and read the project.**
   - Read workspace-level `AGENTS.md`, `AGENTS.local.md`, and `control/README.md` when each
     exists.
   - Determine the managed repository or repositories:
     - If `control/README.md` lists the managed repository or repositories (and any
       workspace policy), use that list.
     - Otherwise inspect immediate child directories (depth 1 only, skipping `control/`,
       `worktrees/`, `ref/`, and hidden directories) for Git main checkouts
       (`git -C <child> rev-parse --git-dir` is `.git` and `--show-toplevel` equals
       `<child>`). If there is **exactly one**, use it directly; if there are **zero or two
       or more**, ask the owner which repository or repositories this control session
       manages and offer to record that list in `control/README.md` so future starts do not
       re-ask.
   - For **each managed repository `<repo>`**, explicitly read `<repo>/AGENTS.md` (Current
     Focus first), `<repo>/AGENTS.local.md` when it exists, and the workflow documents
     `<repo>/AGENTS.md` links (resolving relative paths under `<repo>/`). Note per
     repository: the main branch, the stage order, the stopping points, the landing and
     push rules, the record paths, and the CI. Where they are silent, ask the owner and use
     the answer for this session.
2. **Check the layout** against the one in `SKILL.md`. Report each mismatch to the owner
   and wait for the answer before creating anything:
   - the cwd contains a `.git` entry (stop and warn about the stray `.git`);
   - `git -C <repo> worktree list` for a managed repository shows worktrees outside
     `worktrees/` (the project still uses another directory; it moves them when it adopts
     this layout);
   - a managed repository has `AGENTS.local.md` that Git does not ignore
     (`git -C <repo> check-ignore -q AGENTS.local.md` fails), or neither workspace-level
     `AGENTS.local.md` nor `<repo>/AGENTS.local.md` exists: work sessions would see no
     personal preferences, or a repo-level file or link would show as untracked in every
     worktree.
3. **Prepare.** Create whichever of `worktrees/`, `control/briefs/`, and
   `control/status.md` (from [../references/status.md](../references/status.md)) is
   missing. When the owner confirmed a multi-repository managed list and
   `control/README.md` does not exist yet, offer to write a concise `control/README.md`
   recording it.
4. **Recap.** Run the refresh below, then give the owner the recap. If the owner has not
   stated a default work-session agent kind for this session yet, ask which agent kind
   (and model, if any) to use by default for dispatched sessions; the owner can change it
   at any time in conversation.
5. **Set operating mode** as `SKILL.md`, "Operating modes: active and pull", says: in Herdr
   active mode, schedule the recurring refresh (telling the owner only when a refresh finds
   something new under Needs you or Overlaps, otherwise updating `control/status.md`
   silently); in T3 Code (unless the owner asks for a recurring `schedule_task`) or Herdr
   pull mode, refresh on each owner message.

## Refresh

A refresh brings `control/status.md` up to date. It is done when the work sessions are
checked in both directions and every section of the file holds the current state.

1. **Work sessions.** Run "Check" in [../references/sessions.md](../references/sessions.md).
2. **Main branches and CI.** For each managed repository `<repo>`, run
   `git -C <repo> fetch`, then note new commits on its main branch and the CI results its
   docs say how to read.
3. **Overlaps.** Run the overlap check below.
4. **Host.** Note anything that stops sessions: the machine slept (sessions stopped with an
   error), low disk space, a service the project needs that is down.
5. **Write.** Rewrite `control/status.md` with the time of this refresh.

## Overlap check

Two pieces of work **overlap** when they change the same area. For each active branch in a
managed repository `<repo>`, list its changes: `git -C <repo> diff --name-only
<main>...<branch>`, plus `git -C <worktree> status --porcelain` for uncommitted files.
Judge by area, not only by path: a module's code and its design document are one area, and
in a multi-repository workspace also note cross-repository shared areas or dependencies. A
work session and its own review sessions (child threads or review tabs) or `implement-spec`
worktrees do not overlap with each other.

For each overlap, find the order in the project's plan (the change plan, the iteration
plan, or the planned order in `control/status.md`):

- The plan sets the order: record it as information, such as "`a` lands first; `b`
  rebases after".
- The plan sets no order, or the two pieces of work change the same behavior in different
  directions: put it under Needs you and ask the owner.

The work sessions do not settle an overlap between themselves.

When the owner considers letting two changes implement at once, report the overlap check's
result for that pair: the project's workflow allows it only when they change no shared area
and the plan sets no dependency between them.

## After a landing

The owner lands a change in its work session. On the owner's word afterwards:

1. **Fast-forward** the owning repository's main checkout to the landed commit:
   `git -C <repo> merge --ff-only <ref>`, where `<ref>` is the landed change branch or,
   after `git -C <repo> fetch`, `origin/<main>`. Stop and ask the owner if it cannot
   fast-forward. If the harness's permission check blocks the command, give the owner the
   command to run with `!`.
2. **Propose cleanup**: the work session (archive the T3 Code thread, or close the Herdr
   tab and agent) and the worktree you created for it. Keep the branch. Before removing a
   worktree (`git -C <repo> worktree remove <worktree>`), check that it and any initialized
   submodule are clean and that the submodule's commit is on its remote; a worktree with an
   initialized submodule needs `git -C <repo> worktree remove --force <worktree>`.
3. **Remind about a change planned beside it.** When a work session planned the next change
   while this one was implemented, tell the owner that its session rebases onto the new
   main branch and checks its spec and tickets against the landed code before it
   implements. Report it as a pointer to that session; do not message the session unless
   the owner asks.
4. **Propose the next work** from the project's plan and `control/status.md`.
