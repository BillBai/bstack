# Control session

You coordinate one project. Your cwd is its main checkout, `<project>_workspace/<project>/`.

## Start

1. **Read the project.** Read `AGENTS.md` (Current Focus first), `AGENTS.local.md` when it
   exists, and the workflow documents `AGENTS.md` links. Note what they define: the main
   branch, the stage order, the stopping points, the landing and push rules, the record
   paths, and the CI. Where they are silent, ask the owner and use the answer for this
   session.
2. **Prepare the workspace.** Make sure `../worktrees/` and `../control/briefs/` exist.
   Create `../control/status.md` from [../references/status.md](../references/status.md)
   if it is missing. If the main checkout has no `AGENTS.local.md`, tell the owner that
   work sessions will see no personal preferences, and offer to create one.
3. **Recap.** Run the refresh below, then give the owner the recap.
4. **Schedule the refresh.** Repeat the refresh every 30 minutes with the harness's
   scheduling tool (Claude Code: `CronCreate`, session-only), or at the interval the owner
   sets. Without a scheduler, refresh on each owner message. When a refresh finds
   something new under Needs you or Overlaps, tell the owner; otherwise update the file
   silently.

## Refresh

A refresh brings `../control/status.md` up to date. It is done when every row in the work
table has been checked against Git and Herdr, and every section of the file holds the
current state.

1. **Sessions.** Read `status.md`. Check each row against `git worktree list` and
   `herdr agent list`. A session that is gone while its worktree remains becomes "session
   closed; worktree kept" under Needs you, with the offer to reopen it.
2. **State.** For each live work session, read its screen
   ([../references/herdr.md](../references/herdr.md), "Read a screen") and classify it with
   the rules in [../references/status.md](../references/status.md), "Needs you".
3. **Progress.** For each work item, read its records and branch: `git log` on the branch
   since the main branch, the Status and Stage lines of its spec or tickets, and new review
   comments. Write one line of what it has produced, not only whether it waits.
4. **Main branch and CI.** `git fetch`, then note new commits on the main branch and the CI
   results the project's docs say how to read.
5. **Overlaps.** Run the overlap check below.
6. **Host.** Note anything that stops sessions: the machine slept (sessions stopped with an
   error), low disk space, a service the project needs that is down.
7. **Write.** Rewrite `status.md` with the time of this refresh.

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

## Dispatch a work session

On the owner's word to start a piece of work:

1. **Propose.** Give the owner the name (`[a-z][a-z0-9_-]{0,31}`, also the Herdr agent
   name and the tab label), the branch name in the project's convention, the base, the
   agent kind (default: your own kind), and the stage you take the owner to authorize. Wait
   for agreement or corrections.
2. **Create the worktree.** From the main checkout:
   `git worktree add -b <branch> ../worktrees/<name> <base>`. Then link the personal
   preferences: `ln -s ../../<project>/AGENTS.local.md ../worktrees/<name>/AGENTS.local.md`
   when the main checkout has that file. Uninitialized submodules stay uninitialized; the
   brief says how the project initializes them.
3. **Write the brief** to `../control/briefs/<name>.md` from
   [../references/work-brief.md](../references/work-brief.md).
4. **Open the session**, following [../references/herdr.md](../references/herdr.md),
   "Open a work session".
5. **Record and track.** Add the row to `status.md`, start the wait loop
   ([../references/herdr.md](../references/herdr.md), "Wait loop"), and tell the owner
   which tab holds the session.

Work that edits nothing in the repository, such as a question to investigate, still gets
its own worktree unless the owner says otherwise, so the main checkout stays clean.

## When a session settles

The wait loop notifies you when a session settles. Read its screen, classify it, update
`status.md`, and tell the owner only when it needs them: what it waits on, in one line,
with the tab. Then restart the wait loop for that session.

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
3. **Propose the next work** from the project's plan and `status.md`.
