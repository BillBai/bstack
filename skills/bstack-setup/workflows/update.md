# Update Workflow (Incremental Sync for Adopted Repositories)

Use this workflow when a repository already follows the `bstack` layout (`docs/guide/workflow.md` and `docs/agents/agent-environment.md` exist) and the owner wants to sync recent improvements from [`../references/`](../references/).

`bstack` stores no state files or version markers inside consumer repositories. Updates work by direct semantic comparison between the repository's workflow/agent files and [`../references/`](../references/), strictly respecting ownership boundaries.

## 1. Respect file ownership boundaries

Divide repository files into three categories before comparing:

1. **Project-owned files (skip content comparison; never overwrite):**
   - `README.md`
   - `GLOSSARY.md`
   - `docs/plans/**`
   - `docs/topics/**`, `docs/reports/**`, `docs/adr/**`
   - `work-docs/**`
   - `AGENTS.local.md` (member-owned and gitignored; never compare or overwrite)
   - Verify only that structural conventions still hold (for example, if a future `bstack` update introduces a new required directory or metadata convention, note it as an optional structural suggestion without touching project content).
2. **Hybrid files (compare universal sections only; preserve project-owned sections):**
   - `AGENTS.md` vs [`../references/root-AGENTS.md`](../references/root-AGENTS.md): keep the project overview, component list, `## Current Focus`, and project-specific `Required reading` or domain rules untouched; compare only the standard `Required reading` pointers, `## Working rules`, and `## Writing` rules.
   - `docs/README.md` vs [`../references/docs/README.md`](../references/docs/README.md): keep project-specific primary entry links untouched; compare the directory layout table and standard entry points.
   - `docs/guide/prior-art-and-refs.md` vs [`../references/docs/guide/prior-art-and-refs.md`](../references/docs/guide/prior-art-and-refs.md) (only if present in the repo): keep the project's reference table untouched; compare `## Usage rules`.
   - `../AGENTS.md` vs [`../references/workspace-AGENTS.md`](../references/workspace-AGENTS.md) (only if present and requested).
3. **Standard workflow and agent files (full semantic comparison):**
   - `CLAUDE.md` (`@AGENTS.md`, regular file)
   - `docs/guide/workflow.md` vs [`../references/docs/guide/workflow.md`](../references/docs/guide/workflow.md)
   - `docs/agents/agent-environment.md` vs [`../references/docs/agents/agent-environment.md`](../references/docs/agents/agent-environment.md)
   - `docs/agents/agent-setup.md` vs [`../references/docs/agents/agent-setup.md`](../references/docs/agents/agent-setup.md)
   - `docs/agents/domain.md` vs [`../references/docs/agents/domain.md`](../references/docs/agents/domain.md)
   - `docs/agents/issue-tracker.md` vs [`../references/docs/agents/issue-tracker.md`](../references/docs/agents/issue-tracker.md)
   - `docs/agents/triage-labels.md` vs [`../references/docs/agents/triage-labels.md`](../references/docs/agents/triage-labels.md)

## 2. Distinguish upstream updates from intentional project adaptations

Read both the repository's files in categories 2–3 and the corresponding files in [`../references/`](../references/). Ignore harmless project-specific substitutions such as:

- Replacing `<project-name>` with the actual repository name.
- Omitting `prior-art-and-refs.md` / `../ref/` references in repositories that do not use sibling reference checkouts.
- Domain-specific verification sentences in `workflow.md` or `AGENTS.md` (for example, compiler/bytecode behavior-plus-effect checks in protection projects).

If no substantive differences remain, report that the repository already matches the current `bstack` baseline (also running link and `CLAUDE.md` checks to confirm health) and stop without editing any file.

## 3. Present itemized diff summary and confirm

When differences exist, present a concise numbered list in the owner's conversation language separating:

1. **Recommended updates from `bstack`:** file path and a one-line summary of each change (for example, updated model tiers/IDs in `docs/agents/agent-environment.md`, refined review/retro guidance in `docs/guide/workflow.md`, or updated writing rules in `AGENTS.md`).
2. **Detected project-specific customizations:** differences that look deliberately tailored for this repository, with a recommendation to **preserve** them unless the owner wants them reset.

Wait for the owner to confirm which numbered items to apply (for example, "apply all recommended updates and keep project customizations").

## 4. Apply approved updates and verify

1. Edit only the approved sections and files, preserving all project-owned content and zero `<...>` placeholders.
2. Confirm `CLAUDE.md` is a regular file (not a symlink) containing `@AGENTS.md`.
3. If the update removes personal preferences from `AGENTS.md` (for example, the conversation-language rules now in [`../references/root-AGENTS.local.md`](../references/root-AGENTS.local.md)), offer to carry them into `AGENTS.local.md` so behavior does not change silently. Ensure `.gitignore` contains `/AGENTS.local.md` and `git ls-files AGENTS.local.md` prints nothing.
4. Validate every relative Markdown link and `#heading` anchor across modified files, and run `git diff --check`.
5. Summarize the applied updates and `git status` in the owner's conversation language, leaving commit and branch decisions to the owner.
