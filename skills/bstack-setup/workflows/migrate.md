# Migrate Workflow (Existing Repository)

Use this workflow when bringing an existing codebase or legacy documentation/agent setup onto the `bstack` layout without losing project knowledge, build/test commands, or in-flight work. Reference files live under [`../references/`](../references/).

## 1. Inventory existing project assets (read-only)

Read existing project files thoroughly before proposing changes:

1. **Agent and entry files:** `README.md`, `AGENTS.md`, `CLAUDE.md` (note if symlinked), `GEMINI.md`, `.agents/`, `.claude/`, `.codex/`, `.pi/`. Extract every project-specific rule: build/test/lint commands, architecture invariants, directory layout notes, security boundaries, and coding conventions.
2. **Domain and ADR docs:** `GLOSSARY.md`, `GLOSSARY-MAP.md`, legacy `CONTEXT.md` / `CONTEXT-MAP.md`, and any existing `adr/` or `decisions/` directories.
3. **Plans, docs, and issue tracking:** existing `docs/**`, roadmaps, design notes, `.scratch/**`, `issues/**`, or `work-docs/**`.
4. **Repository state:** current Git branch, uncommitted changes (`git status`), build manifests (`Cargo.toml`, `CMakeLists.txt`, `package.json`, `pyproject.toml`, etc.), CI workflows, and sibling `../ref/` or parent `../AGENTS.md`.

## 2. Propose a file-by-file migration map

Present a concrete summary of what exists and a categorized file plan:

- **Create:** missing standard files from [`../references/`](../references/) (`docs/README.md`, `docs/arch/architecture.md`, `docs/guide/workflow.md`, `docs/agents/{agent-setup,agent-environment,domain,issue-tracker,triage-labels}.md`, `work-docs/backlog.md`, `.gitkeep` files for empty `docs/{topics,reports,adr,archive}/`).
- **Merge (preserve all project knowledge):**
  - Merge existing project-specific commands, architecture notes, and coding rules from old `AGENTS.md` / `CLAUDE.md` into the new `AGENTS.md` (or extract bulky build/architecture guides into `docs/guide/<topic>.md` and link them under `AGENTS.md` `## Required reading`) alongside the standard `Working rules` and `Writing` sections from [`../references/root-AGENTS.md`](../references/root-AGENTS.md).
  - Move personal rules found in old agent files or the owner's agent memories (conversation or document language, tone, how to explain and report) into a gitignored `AGENTS.local.md` based on [`../references/root-AGENTS.local.md`](../references/root-AGENTS.local.md), and append `/AGENTS.local.md` to `.gitignore` (create or append, never overwrite).
  - Convert `CLAUDE.md` into a regular file containing `@AGENTS.md` (if `CLAUDE.md` was a symlink or held standalone instructions, migrate its unique instructions into `AGENTS.md` first, then replace the symlink with the regular file).
- **Move (`git mv`):**
  - Legacy `CONTEXT.md` → `GLOSSARY.md` (updating format if needed to match `domain-modeling`).
  - Existing plans/roadmaps → `docs/plans/`, the current architecture → `docs/arch/`, standalone technical notes → `docs/topics/`, architectural decisions → `docs/adr/`, guides → `docs/guide/`, superseded designs, plans, and records → `docs/archive/`.
  - Entries of a `decision-log.md` → the documents that own their topics (`milestone.md`, `iteration.md`, or a `design/` document), keeping the owner's quoted words and dates.
  - Existing hook scripts → `.agents/hooks/`, with each tool's configuration reduced to an adapter that points at them.
  - Existing `.scratch/` or local issue files → either migrate active items into `work-docs/<change>/` or leave historical closed notes where agreed.
- **Keep untouched:** all source code, tests, build configs, user-global settings, and any existing docs the owner prefers to keep in place.

Confirm 1 to 3 key choices with recommended answers:

1. Approval or adjustments on the proposed file map (especially how existing `docs/` or `.scratch/` items map into the new layout).
2. Whether `docs/guide/prior-art-and-refs.md` (`../ref/`) and parent `../AGENTS.md` apply to this repository.
3. Branch choice: run migration on a dedicated branch (recommended: `chore/m0-i0-bstack-migration` or `chore/m<x>-i0-bstack-migration` when uncommitted edits do not conflict) vs the current branch.

Wait for explicit owner approval before modifying any file.

## 3. Execute migration cleanly

1. Preserve any unrelated uncommitted edits. Use `git mv` when relocating tracked files so Git history stays intact.
2. Write and merge Markdown files using [`../references/`](../references/) as the structural baseline, adapting all `<...>` placeholders and omitting `prior-art-and-refs.md` / `../ref/` links when `../ref/` is not used.
3. Ensure `AGENTS.md` `## Current Focus` accurately reflects the repository's real current milestone, iteration, or active work.
4. Update internal Markdown links across moved and edited documents so no references point to retired paths (`CONTEXT.md`, old `docs/` paths, `.scratch/`, or `decision-log.md`).

## 4. Verify and report

1. Confirm `CLAUDE.md` is a regular file (not a symlink) containing `@AGENTS.md`.
2. Validate every local Markdown link and `#heading` anchor across `README.md`, `AGENTS.md`, `GLOSSARY.md`, `docs/**/*.md`, and `work-docs/**/*.md`, and verify zero leftover `<...>` placeholders or stale moved-file references.
3. Run `git diff --check` and existing lightweight doc/lint checks if the repository provides them.
4. Confirm `.gitignore` contains `/AGENTS.local.md` and `git ls-files AGENTS.local.md` prints nothing.
5. Report the completed migration summary and verification counts in the owner's conversation language, then wait for owner instruction before committing or landing.
