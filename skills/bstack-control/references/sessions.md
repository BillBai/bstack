# Work sessions: dispatch, settle, check

Both roles dispatch and track work sessions the same way. Where they differ, a step names
its role.

## Dispatch

On the owner's word to start a piece of work:

1. **Propose.** Give the owner the name (`[a-z][a-z0-9_-]{0,31}`, also the Herdr agent
   name and the tab label), the agent kind and explicit model/effort (using the default
   the owner chose for this coordinator session, or asking the owner if none is set; never
   inherit the coordinator's own kind and do not rely on a repository-hardcoded default),
   the stage you take the owner to authorize, and, for the control session, the branch in
   the project's convention and its base. Wait for agreement or corrections.
2. **Create the place it works.**
   - *Control session:* from the main checkout,
     `git worktree add -b <branch> ../worktrees/<name> <base>`. When the main checkout has
     an `AGENTS.local.md` that Git ignores (`git check-ignore -q AGENTS.local.md`), link
     it: `ln -s ../../<project>/AGENTS.local.md ../worktrees/<name>/AGENTS.local.md`.
     Uninitialized submodules stay uninitialized; the brief says how the project
     initializes them. Work that edits nothing in the repository still gets its own
     worktree unless the owner says otherwise, so the main checkout stays clean.
   - *Chief-of-staff:* `mkdir work/<name>`, a plain directory.
3. **Write the brief** to `briefs/<name>.md` from [work-brief.md](work-brief.md).
4. **Open the session** ([herdr.md](herdr.md), "Open a work session").
5. **Record and track.** Add the row to `status.md`. In active mode, start the wait loop
   ([herdr.md](herdr.md), "Wait loop"); in pull mode, skip the wait loop. Tell the owner
   which tab holds the session.

## Settle

Active mode only. The wait loop notifies you when a session settles. Read its screen
([herdr.md](herdr.md), "Read a screen"), classify it ([status.md](status.md), "Needs
you"), update `status.md`, and tell the owner only when it needs them, as a **pointer**
([status.md](status.md), "Pointers"). Then restart the wait loop for that session.

## Check

Checking your work sessions is done when every row of the work table and every worktree
or work directory and agent you can see has been accounted for, in both directions.

1. **Rows to reality.** Check each row of `status.md` against `git worktree list` (control
   session) or `work/` (chief-of-staff), and `herdr agent list`. A session that is gone
   while its worktree or directory remains becomes "session closed; worktree kept" under
   Needs you, with the offer to reopen it.
2. **Reality to rows.** List every worktree or work directory, and every agent in your
   Herdr workspace, that has no row. Show them to the owner and add a row only on the
   owner's word; tabs and worktrees a work session opened itself join that session's row.
   On a first run this is how existing work enters the table.
3. **State.** For each live session, read its screen and classify it
   ([status.md](status.md), "Needs you").
4. **Progress.** For each work item, read its records and branch: `git log` on the branch
   since the main branch, the Status and Stage lines of its spec or tickets, and new review
   comments; for outside work, the files in its directory. Write one line of what it has
   produced, not only whether it waits.
