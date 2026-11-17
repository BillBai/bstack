# Control session

You coordinate one project. Your cwd is its main checkout, `<project>_workspace/<project>/`.
Dispatching, settling, and checking work sessions follow
[../references/sessions.md](../references/sessions.md).

## New control session

When you were started with `control <path>` and the cwd is not that main checkout, open the
project's control session there instead of running it here:

1. **Check the path.** It is the top of a repository's main checkout (as in `SKILL.md`,
   "Pick the role"). Otherwise tell the owner what you found and stop.
2. **Open it**: [../references/herdr.md](../references/herdr.md), "Open a coordinator",
   with that path as the directory, the label `<project>` (the checkout's directory name),
   the agent name `<project>-control` (lowercase, at most 32 characters), and the role
   `control`.

The new control session checks the project's layout itself (Start, step 2).

## Start

1. **Read the project.** Read `AGENTS.md` (Current Focus first), `AGENTS.local.md` when it
   exists, and the workflow documents `AGENTS.md` links. Note what they define: the main
   branch, the stage order, the stopping points, the landing and push rules, the record
   paths, and the CI. Where they are silent, ask the owner and use the answer for this
   session.
2. **Check the layout** against the one in `SKILL.md`. Report each mismatch to the owner
   and wait for the answer before creating anything:
   - the parent directory is not named `<project>_workspace`;
   - `git worktree list` shows worktrees outside `../worktrees/` (the project still uses
     another directory; it moves them when it adopts this layout);
   - `AGENTS.local.md` is missing, or Git does not ignore it
     (`git check-ignore -q AGENTS.local.md` fails): work sessions would see no personal
     preferences, or the link would show as untracked in every worktree.
3. **Prepare.** Create whichever of `../worktrees/`, `../control/briefs/`, and
   `../control/status.md` (from [../references/status.md](../references/status.md)) is
   missing.
4. **Recap.** Run the refresh below, then give the owner the recap.
5. **Schedule the refresh** as `SKILL.md`, "Scheduled refresh", says. When a refresh finds
   something new under Needs you or Overlaps, tell the owner; otherwise update the file
   silently.

## Refresh

A refresh brings `../control/status.md` up to date. It is done when the work sessions are
checked in both directions and every section of the file holds the current state.

1. **Work sessions.** Run "Check" in [../references/sessions.md](../references/sessions.md).
2. **Main branch and CI.** `git fetch`, then note new commits on the main branch and the CI
   results the project's docs say how to read.
3. **Overlaps.** Run the overlap check below.
4. **Host.** Note anything that stops sessions: the machine slept (sessions stopped with an
   error), low disk space, a service the project needs that is down.
5. **Write.** Rewrite `status.md` with the time of this refresh.

## Overlap check

Two pieces of work **overlap** when they change the same area. For each active branch, list
its changes: `git diff --name-only <main>...<branch>`, plus `git -C <worktree> status
--porcelain` for uncommitted files. Judge by area, not only by path: a module's code and
its design document are one area. A work session and its own review tabs or
`implement-spec` worktrees do not overlap with each other.

For each overlap, find the order in the project's plan (the change plan, the iteration
plan, or the planned order in `status.md`):

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

1. **Fast-forward** the main checkout's main branch to the landed commit: `git merge
   --ff-only <ref>`, where `<ref>` is the landed change branch or, after `git fetch`,
   `origin/<main>`. Stop and ask the owner if it cannot fast-forward. If the harness's
   permission check blocks the command, give the owner the command to run with `!`.
2. **Propose cleanup**: the tab, the session, and the worktree you created for it. Keep the
   branch. Before removing a worktree, check that it and any initialized submodule are
   clean and that the submodule's commit is on its remote; a worktree with an initialized
   submodule needs `git worktree remove --force`.
3. **Remind about a change planned beside it.** When a work session planned the next change
   while this one was implemented, tell the owner that its session rebases onto the new
   main branch and checks its spec and tickets against the landed code before it
   implements. Report it as a pointer to that session; do not message the session unless
   the owner asks.
4. **Propose the next work** from the project's plan and `status.md`.
