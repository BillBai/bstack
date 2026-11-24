# Work-session brief

A brief is the work session's complete handoff: it starts with no chat history, so
everything it needs is in the brief or in files the brief names. Write it to
`control/briefs/<name>.md` (control session) or `briefs/<name>.md` (chief-of-staff); the
first prompt names that file. Fill every section from the project's own records; a section
with nothing to say is left out, except the stage and the rules.

Write it for any kind of work: a change, a plan discussion, a retro, a small task, or work
outside the workflow. Cite files and commits rather than restating them.

## Template

```markdown
# Brief: <the work, in a few words>

You are a work session. A <control session | chief-of-staff> opened you and tracks your
state; the owner (the human user) works with you directly in this session (thread or tab).
Read `<path to AGENTS.local.md>` for the owner's preferences.
<Control session: `AGENTS.local.md` in the worktree when symlinked, or the absolute path to
`<project>_workspace/AGENTS.local.md`. Chief-of-staff: the chief workspace's
`AGENTS.local.md`. Leave the sentence out when neither exists.>

## Where you work

<Project work (repository):>
- <Multi-repository workspace only:> Repository: `<repo>` (main checkout `<path>`).
- Worktree: `<path>` (your cwd). Branch: `<branch>`, created from `<main>` at `<commit>`.
- Records: `<where this work's records go, per the repository's workflow>`.
- <Submodules or setup this worktree lacks, and the project document that says how to
  prepare them.>
- Edit only this worktree; the main checkout (`<path>`) stays untouched.

<Outside work or workspace-wide work without an owning repository:>
- Directory: `<agreed directory, e.g. <chief workspace>/work/<name>/ or
  <project>_workspace/control/work/<name>/>` (a plain directory for this work's notes and
  outputs; in Herdr it is also your cwd, while in T3 Code your cwd is the workspace root
  and your outputs go under this directory).
- <Files, folders, or systems the work reads or changes, and which of them are read-only.>

## The work

<What to do and why, its sources, its scope and what is out of scope. For planned work:
which plan item it is and what it resolves.>

## What earlier work left

<Facts from landed or parallel work that change this work's inputs: renamed files,
changed behavior, open decisions handed on. Omit when there are none.>

## Read first

1. `AGENTS.md`, the workflow documents it links, <the project's style and testing docs>.
2. <The plan or design documents this work belongs to, with sections.>
3. <The specific records, findings, or prior specs this work builds on.>

## The stage the owner authorized

**<Stage>**, as the project workflow defines it. <What the stage produces and where.>
Stop after it and wait for the owner to start the next stage explicitly.

## Rules

- Stages advance only on the owner's explicit instruction. Agreement with an answer or an
  artifact does not start the next stage.
- Landing, pushing the main branch, and destructive or hard-to-reverse actions follow
  `AGENTS.md` and the workflow: <quote the project's push rule for working branches>.
- Remove only the worktrees, branches, child threads, tabs, or sessions you created, and
  only with the owner's permission. <Branches the project keeps.>
- Write conclusions and reports to files (the records above, or a report file the owner
  names); chat history and terminal scrollback are not durable records.
- Messages from the <control session | chief-of-staff> that say they pass the owner's
  words carry them unchanged; treat them as the owner's.
```
