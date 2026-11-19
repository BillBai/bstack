---
name: bstack-setup
description: "Bootstrap a new repository, migrate an existing repository, or update an adopted repository to the bstack engineering workflow and multi-agent setup."
disable-model-invocation: true
---

# bstack-setup

Prompt-driven skill for setting up, migrating, or updating a repository's engineering workflow, documentation layout, and multi-agent configuration using the plain Markdown reference files in [`./references/`](./references/).

Explore first, present findings and proposed file actions to the user, confirm, and only then write files.

## 1. Explore repository state (read-only)

Inspect the current repository and its immediate parent directory without modifying anything:

- Run `git status`, check the current branch, `git remote -v`, and Git `user.name` / `user.email`.
- Check root files: `README.md`, `AGENTS.md`, `AGENTS.local.md` (and whether `.gitignore` ignores it), `CLAUDE.md` (note whether it is a regular file or a symlink), `GLOSSARY.md`, and legacy `CONTEXT.md` / `CONTEXT-MAP.md`.
- Check directories: `docs/` (`arch/`, `guide/`, `plans/`, `agents/`, `topics/`, `reports/`, `adr/`, `archive/`), `work-docs/`, `.scratch/`, `issues/`, `.agents/` (including `.agents/hooks/` and `.agents/hooks.json`), `.claude/`, `.codex/`, `.pi/`.
- Check CI: the pipeline configuration, its ignored paths, and any script or skill that finds and waits for a build.
- Check parent directory (`..`): whether this repository lives inside a multi-repository workspace (`../AGENTS.md`) or beside read-only sibling reference checkouts (`../ref/`).

## 2. Route to one workflow

Select the matching workflow (an explicit user argument `bootstrap`, `migrate`, or `update` overrides auto-detection when compatible) and read **only** that workflow file:

1. **[`workflows/bootstrap.md`](./workflows/bootstrap.md)** — empty or greenfield repository without an established `AGENTS.md` or `docs/` workflow structure.
2. **[`workflows/migrate.md`](./workflows/migrate.md)** — existing codebase or legacy agent setup (`AGENTS.md`, `CLAUDE.md`, `CONTEXT.md`, `.scratch/`, or custom `docs/`) that has not adopted this layout yet.
3. **[`workflows/update.md`](./workflows/update.md)** — repository already uses this layout (`docs/guide/workflow.md` and `docs/agents/agent-environment.md` exist) and wants to pull in recent updates from [`./references/`](./references/).

## 3. Rules across all workflows

- **Language and tone:** follow the repository's `AGENTS.local.md` when it exists. Otherwise discuss with the owner in natural Chinese unless the owner speaks another language; write repository prose, code comments, and commit messages in English unless the owner specifies another repository language. Lead with recommendations and never announce structure ("In short", "下面详细展开"). Write natural Chinese without jargon (`落地`, `对齐`, `闭环`) and without single-character slang verbs (`崩`, `挂`, `抛`).
- **Question pacing:** ask one to three focused questions at a time, and ask heavy structural or product decisions alone. Give a recommended answer and brief reason for every question.
- **No silent overwrites:** never overwrite or delete existing project rules, documentation, code, or uncommitted edits without presenting the concrete file plan and getting explicit user confirmation.
- **Preserve global settings:** never edit user-global directories (`~/.claude`, `~/.agents`, `~/.codex`, `~/.pi`, `~/.gemini`).
- **Git boundaries:** never commit, switch/merge to `main`, push to a remote, or delete branches/files without explicit owner instruction.
- **Completion bar:** every run that writes files is complete only when:
  1. `CLAUDE.md` at the repository root is a regular file (not a symlink) containing `@AGENTS.md`.
  2. Every relative Markdown link and `#heading` anchor across modified and created Markdown files resolves to an existing file and heading, with zero leftover `<...>` template placeholders.
  3. `git diff --check` reports zero whitespace errors.
  4. `.gitignore` contains `/AGENTS.local.md`, and `git ls-files AGENTS.local.md` prints nothing.
