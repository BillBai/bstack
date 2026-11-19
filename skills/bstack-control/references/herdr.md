# Herdr mechanics for coordinators

The `herdr` skill and `herdr <group>` help are the authority for syntax. This file holds
what they do not: how a coordinator uses Herdr, and what running it taught. Its default of
a sibling pane in the current tab does not apply here: a coordinator opens each work
session in a new tab of its own Herdr workspace, because the owner asked for this
topology.

## Open a work session

1. **Tab.** `herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd <worktree or work
   dir> --label <name> --no-focus`. Read the pane ID from `.result.root_pane`.
2. **Agent.** `herdr agent start <name> --kind <kind> --pane <pane-id> -- <explicit args>`.
   Pass explicit native arguments — model, reasoning effort or thinking level, and any
   required harness flags — after `--`. When starting `agy` through Herdr, pass
   `--dangerously-skip-permissions` (and `--add-dir <dir>` when accessing files outside
   the working directory) so the session does not stall on interactive trust or
   permission prompts; for review sessions, the brief forbids modifying tracked repository
   files or leaving non-ignored untracked files (gitignored build outputs are fine), and
   the caller verifies `git status --porcelain` afterward.
3. **First prompt.** If `AGENTS.local.md` names a first prompt for new sessions (for
   example a slash command such as `/i-have-adhd`, or `/skill:i-have-adhd` in `pi`), send
   it alone with `herdr agent prompt <name> "<text>" --wait`.
4. **Brief prompt.** Send a short prompt that names the brief: "Read `<brief path>` and
   follow it."
5. **Check it arrived.** Read the screen. The first prompt to a freshly started agent can
   be lost when its UI is not ready yet; if the screen does not show it, send it again.

## Open a coordinator

A coordinator gets its own Herdr workspace, with itself in the first tab. Inputs: the
directory, the workspace label, the agent name, the role argument (`control` or `chief`),
and the harness and model the owner chooses for the coordinator.

1. **Check for a live one.** If `herdr agent list` already shows the agent name, or
   `herdr workspace list` a workspace with that label, tell the owner and stop; one
   coordinator per project, and one chief.
2. **Workspace.** `herdr workspace create --cwd <dir> --label <label> --no-focus`. Read the
   pane ID from `.result.root_pane`.
3. **Agent.** `herdr agent start <name> --kind <coordinator kind> --pane <pane-id> --
   <coordinator model arguments>`. Ask the owner which harness and model to use if they
   have not stated a coordinator preference; `bstack-control` imposes no required model or
   tier.
4. **Prompts.** Send the first prompt for new sessions, if `AGENTS.local.md` names one,
   then invoke `bstack-control` (`/bstack-control <role>` in Claude Code and `agy`, or
   `/skill:bstack-control <role>` in `pi`; check the harness's skill-invocation syntax for
   others). Check each arrived, as in "Open a work session", step 5.
5. **Hand over.** Tell the owner to switch to the Herdr workspace `<label>`. Your part ends
   there; this session keeps its own role.

## Wait loop

Active mode only. To be notified when a session settles, run in a background shell:

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

Use the screen for state and for the kind of question a session waits on. Take results
from files.

## Resume after the machine slept (Claude Code)

A session stops with "API Error: Your computer went to sleep mid-response". Send a short
"Continue the task." to resume it. This is your own recovery action, not an answer on the
owner's behalf. Note the stop under Host in `status.md`.

## Close a work session

On the owner's permission only, and only for a session you created: `herdr tab close
<tab-id>` closes its tab and the agent in it. A work session's own review tabs are its own;
leave them unless the owner says otherwise.
