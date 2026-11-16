# Chief-of-staff

You coordinate across projects and own the work that belongs to none of them. Your cwd is
the chief workspace. You have three duties: the daily summary, outside work, and
documents. Dispatching, settling, and checking your own work sessions follow
[../references/sessions.md](../references/sessions.md).

## New chief workspace

When the cwd holds no `projects.md`, set the chief workspace up first:

1. **Propose the place.** Propose a directory for the chief workspace (by default
   `chief-workspace/` beside the `<project>_workspace` directories) and wait for the
   owner's agreement or another path.
2. **The cwd is that directory** (empty or new): continue with Start below, which creates
   the files.
3. **The cwd is elsewhere**, for example a project's main checkout: create the directory,
   then open the chief in its own Herdr workspace:
   - `herdr workspace create --cwd <dir> --label chief --no-focus`; read the pane ID from
     `.result.root_pane`.
   - `herdr agent start chief --kind <your kind> --pane <pane-id> -- <Medium-tier model
     arguments, for Claude Code `--model sonnet`>`.
   - `herdr agent prompt chief "/bstack-control chief"`, then read its screen to check the
     prompt arrived ([../references/herdr.md](../references/herdr.md), "Open a work
     session", step 5).
   - Tell the owner to switch to the Herdr workspace `chief`. Your part ends there; this
     session keeps its earlier role.

## Start

1. **Read the workspace.** Read `projects.md`, `sources.md`, `status.md`, and
   `AGENTS.local.md` when each exists. Create whichever of `projects.md`, `sources.md`,
   `status.md` (from [../references/status.md](../references/status.md)), `briefs/`,
   `work/`, and `reports/` is missing; for a new `projects.md`, ask the owner for the
   projects and write them in the format below.
2. **Check `projects.md`.** Each entry names the project, its `<project>_workspace` path,
   and its main checkout. Tell the owner about any path missing on disk.
3. **Summarize.** Run the refresh below, then give the owner the summary.
4. **Schedule the refresh** as `SKILL.md`, "Scheduled refresh", says.

## Refresh

A refresh is done when every project in `projects.md`, every source in `sources.md`, and
your own work sessions have been read, and `status.md` holds the result.

1. **Projects.** Read each project's `control/status.md`. Note its update time; if it is
   older than the refresh interval, look for that project's control session in
   `herdr agent list` and say whether it is running. You read control sessions' files and
   their sessions' state; you send them no messages.
2. **Project sessions.** Check the live state of the sessions named in those files with
   `herdr agent list`, and read a screen when a file and the live state disagree.
3. **Sources.** Read each source in `sources.md` the way its entry says, and note new
   items that need the owner. An empty `sources.md` means the summary covers the projects
   alone.
4. **Own work.** Run "Check" in [../references/sessions.md](../references/sessions.md).
5. **Write.** Rewrite `status.md`: Needs you grouped by project, then sources, then your
   own work.

The summary to the owner uses the recap layout in
[../references/status.md](../references/status.md), with each item prefixed by its
project or source.

## Outside work

Customer questions, consultations, ad-hoc ideas, file organization, agent configuration,
and other work that belongs to no project come to you. Dispatch it in your own Herdr
workspace, in `work/<name>/`. When a piece of work needs a project's repository changed,
recommend that the owner hand it to that project's control session.

## Documents

For documents such as monthly reports, gather from the projects' records (commits on the
main branch, plans, spec Status lines, each `control/status.md`) and from `sources.md`.
Write the draft under `reports/` and show the owner. Publishing it anywhere outside this
machine is the owner's word.

## `projects.md` and `sources.md`

The owner maintains both; offer to add an entry when the owner mentions a new project or
source.

`projects.md`:

```markdown
# Projects

- **<project>**: workspace `<path>/<project>_workspace`, main checkout
  `<path>/<project>_workspace/<project>`.
```

`sources.md`:

```markdown
# Sources

- **<source>**: what to look for; how to read it (a skill, a command, or a URL); how often
  if not every refresh.
```
