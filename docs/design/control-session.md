# Control-session skill: design decisions

Status: grill in progress (2026-11-15). The skill is not written yet. The file name is
provisional until the skill's name is decided.

## The mode

One long-lived **control session** sits in a repository's main checkout and edits nothing
there. For each piece of change work, on the owner's word, it creates a branch and a git
worktree, opens a Herdr tab there, starts an agent in it, briefs that **change session**
through a brief file, and tracks its state for the owner. The owner works with each change
session directly in its tab. The control session never answers, approves, accepts, lands,
or pushes on the owner's behalf.

The owner, 2026-11-15: "我们这种控制台模式，我觉得比较好，你开一个 herdr session，我们在那个
session，把这种模式通过 skills 定下来".

The owner, 2026-11-15, on where it lives: "我希望是一个 bstack 里面的 skills".

## Decisions

### D1. How general the skill is

The skill holds a generic core: the control session's role, its steps, and the Herdr
mechanics. The project part (stage order, landing and push rules, the main branch's name,
record paths) is read at run time from the target repository's `AGENTS.md` and the
workflow documents it links. When the repository does not say, the control session asks
the owner. The bstack workflow stages appear only as an example.

Reason: the one project that runs the mode today uses a different workflow path, main
branch name, and record directory layout than the bstack reference. A skill bound to the
reference's literal paths would be wrong there. bstack is public, so project details can
only come from the target repository at run time.

The owner (project name omitted): "<project> 将会迁移到 bstack". The skill stays generic
after that migration as well.

### D2. Where these decisions are recorded

In this file, `docs/design/<skill-name>.md`, on a branch of bstack. bstack does not adopt
the full bstack workflow (no `work-docs/`, spec, or tickets).

The owner: "我们这个仓库还没 setup matt-pocock 的工作流。不过考虑到我们这个仓库的工作比较简单，
我认为我们这个就只有 docs/design/<skill-name>.md 简单记录就行了。 不需要搞完整的 workflow".

### D3. Which agents the skill supports

Claude Code first; the rest stays agent-neutral where it can. Herdr mechanics and rules are
written for any agent kind. Lessons specific to Claude Code (its suggested reply in the
input box, its auto-mode classifier, the sleep API error, a first slash command) are marked
as such. The change session's agent kind is a parameter that defaults to the control
session's own kind.

Reason: `install.sh` links bstack skills into Claude Code, Codex, pi, and Gemini skill
directories, but the mode has run only on Claude Code. The Claude Code lessons are
verified and worth keeping; marking them keeps them from misleading another agent.

## Open questions

4. What the skill holds as rules versus what the change-brief template holds, and which
   become files in the skill (brief template, status table, wait loop).
5. Where a restarted control session gets the project state and the status table.
6. Where personal and machine settings come from (reply language, a first prompt such as
   `/i-have-adhd`, the worktree root, the brief directory).
7. The skill's name and listing line, and whether `bstack-setup` references point to it.
