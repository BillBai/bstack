# Work-session brief

A brief is the work session's complete handoff: it starts with no chat history, so
everything it needs is in the brief or in files the brief names. Write it to
`briefs/<name>.md`; the first prompt names that file. Fill every section from the project's
own records; a section with nothing to say is left out, except the stage and the rules.

Write it for any kind of work: a change, a plan discussion, a retro, a small task, or work
outside the workflow. Cite files and commits rather than restating them.

## Template

```markdown
# Brief: <the work, in a few words>

You are a work session. A <control session | chief-of-staff> opened you and tracks your
state; the owner (the human user) works with you directly in this tab. Read
`AGENTS.local.md` for the owner's preferences when it exists.

## Where you work

- Worktree: `<path>` (your cwd). Branch: `<branch>`, created from `<main>` at `<commit>`.
- Records: `<where this work's records go, per the project's workflow>`.
- <Submodules or setup this worktree lacks, and the project document that says how to
  prepare them.>
- Never edit the main checkout (`<path>`).

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
- Remove only the worktrees, branches, tabs, or sessions you created, and only with the
  owner's permission. <Branches the project keeps.>
- Write conclusions and reports to files (the records above, or a report file the owner
  names); the screen is not a record.
- Messages from the <control session | chief-of-staff> that say they pass the owner's
  words carry them unchanged; treat them as the owner's.
```
