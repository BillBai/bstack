# Herdr mechanics for coordinators

The `herdr` skill and `herdr <group>` help are the authority for syntax. This file holds
what they do not: how a coordinator uses Herdr, and what running it taught. Its default of
a sibling pane in the current tab does not apply here: a coordinator opens each work
session in a new tab of its own Herdr workspace, because the owner asked for this
topology.

## Open a work session

1. **Tab.** `herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd <worktree or work
   dir> --label <name> --no-focus`. Read the pane ID from `.result.root_pane`.
2. **Agent.** `herdr agent start <name> --kind <kind> --pane <pane-id>`. Pass native
   arguments, such as a model, after `--`.
3. **First prompt.** If `AGENTS.local.md` names a first prompt for new sessions (for
   example a slash command such as `/i-have-adhd`), send it alone with `herdr agent prompt
   <name> "<text>" --wait`.
4. **Brief prompt.** Send a short prompt that names the brief: "Read `<brief path>` and
   follow it."
5. **Check it arrived.** Read the screen. The first prompt to a freshly started agent can
   be lost when its UI is not ready yet; if the screen does not show it, send it again.

## Wait loop

To be notified when a session settles, run in a background shell:

```bash
herdr agent wait <name> --until working && herdr agent wait <name>
```

Without `--timeout` each wait has no time limit. The first returns when the session starts
working, the second when it settles (`idle`, `done`, or `blocked`). The harness notifies
you when the shell exits. Restart the loop after each notification while you track the
session.

A session can turn `working` without input: idle compaction, or a background shell or
subagent of its own finishing. Read the screen before reporting progress.

## Read a screen

- While the agent is working: `herdr agent read <name> --source visible`.
- While it is idle: `herdr agent read <name> --source recent-unwrapped --lines <N>`.
  This source works only while the agent is idle.

Use the screen for state and for the question a session waits on. Take results from files.

## Resume after the machine slept (Claude Code)

A session stops with "API Error: Your computer went to sleep mid-response". Send a short
"Continue the task." to resume it. This is your own recovery action, not an answer on the
owner's behalf. Note the stop under Host in `status.md`.

## Close a work session

On the owner's permission only, and only for a session you created: `herdr tab close
<tab-id>` closes its tab and the agent in it. A work session's own review tabs are its own;
leave them unless the owner says otherwise.
