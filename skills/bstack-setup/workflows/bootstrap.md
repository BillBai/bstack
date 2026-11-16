# Bootstrap Workflow (New or Greenfield Repository)

Use this workflow when setting up a new or empty repository from scratch. Reference files live under [`../references/`](../references/) mirroring the target repository layout 1-to-1.

## 1. Clarify project scope and options

Summarize what exploration found (repository path, remote, Git identity, parent workspace signals), then clarify the items below in batches of 1 to 3 questions with a recommended answer for each:

1. **Project identity and boundaries (if not already stated):**
   - Project name, one-sentence purpose, core components owned by this repository, and any adjacent components owned by separate repositories.
2. **Bootstrap depth:**
   - **Lightweight skeleton (recommended when starting quickly):** create root entry files, `docs/guide/workflow.md`, `docs/agents/*`, `work-docs/backlog.md`, `.gitkeep` placeholders, and a concise initial `docs/plans/roadmap.md` so work can start immediately.
   - **Full milestone baseline (recommended when initial milestones are ready to scope):** also settle the milestone sequence in `docs/plans/roadmap.md`, draft `docs/plans/m1-<slug>/milestone.md` and `iteration-plan.md`, and optionally record bootstrap decisions and verbatim owner quotes in `work-docs/m0-i0-project-bootstrap/spec.md`.
3. **Optional workspace modules (ask only when relevant or ambiguous):**
   - **Sibling reference checkouts (`../ref/`):** include `docs/guide/prior-art-and-refs.md` when the project uses read-only reference repositories under `../ref/` (recommended: **yes** if `../ref/` already exists, **no** otherwise).
   - **Parent workspace `../AGENTS.md`:** create or update a concise parent routing `../AGENTS.md` modeled on [`../references/workspace-AGENTS.md`](../references/workspace-AGENTS.md) only when this repository sits inside a multi-repository parent workspace and the owner confirms.

## 2. Draft preview and confirm

Before writing files, show the user:

1. The exact list of files and directories to be created.
2. Concise drafts of the project-specific sections (`README.md` summary, `AGENTS.md` intro + `Current Focus`, and `docs/plans/roadmap.md` outline).

Wait for explicit confirmation before writing.

## 3. Write files

Read the reference files under [`../references/`](../references/) and adapt every `<...>` placeholder to the confirmed project details:

- **Root:**
  - `README.md` — based on [`../references/root-README.md`](../references/root-README.md); concise statement of what the project is and what components this repository owns (no workflow boilerplate).
  - `AGENTS.md` — based on [`../references/root-AGENTS.md`](../references/root-AGENTS.md). Keep `Current Focus` accurate for the repository's immediate next step.
  - `CLAUDE.md` — regular file (never a symlink) containing exactly `@AGENTS.md`.
  - `AGENTS.local.md` — based on [`../references/root-AGENTS.local.md`](../references/root-AGENTS.local.md), adjusted to the owner's language preferences. Never commit it.
  - `.gitignore` — create it or append `/AGENTS.local.md`; never overwrite existing entries.
  - `GLOSSARY.md` — based on [`../references/GLOSSARY.md`](../references/GLOSSARY.md), seeded with confirmed project terms (or minimal clean header if no domain terms exist yet).
- **`docs/`:**
  - `docs/README.md` — based on [`../references/docs/README.md`](../references/docs/README.md).
  - `docs/guide/workflow.md` — based on [`../references/docs/guide/workflow.md`](../references/docs/guide/workflow.md), adding any confirmed domain-specific verification rule if needed.
  - `docs/guide/prior-art-and-refs.md` — include only when `../ref/` is enabled, based on [`../references/docs/guide/prior-art-and-refs.md`](../references/docs/guide/prior-art-and-refs.md). **When omitted, remove all links and bullets referencing `prior-art-and-refs.md` or `../ref/` from `AGENTS.md`, `docs/README.md`, `docs/agents/agent-setup.md`, and `milestone.md`.**
  - `docs/agents/{agent-setup.md, agent-environment.md, domain.md, issue-tracker.md, triage-labels.md}` — based on [`../references/docs/agents/`](../references/docs/agents/).
  - `docs/plans/roadmap.md` (and `docs/plans/m1-<slug>/{milestone.md, iteration-plan.md}` when using full milestone baseline, renaming `m1-skeleton` links to the real `m1-<slug>` directory).
  - `docs/topics/.gitkeep`, `docs/reports/.gitkeep`, `docs/adr/.gitkeep` for empty directories.
- **`work-docs/`:**
  - `work-docs/backlog.md` — based on [`../references/work-docs/backlog.md`](../references/work-docs/backlog.md) (omit the example row if no deferred items exist yet, leaving an empty table or clean note).
  - Optional `work-docs/m0-i0-project-bootstrap/spec.md` when recording initial product/bootstrap decisions and verbatim owner quotes.

Do not copy any skill files into the target repository; Matt Pocock's skills and `bstack-setup` remain installed in the user's agent harnesses.

## 4. Verify and report

Run verification checks before reporting completion:

1. Confirm `test -f CLAUDE.md && test ! -L CLAUDE.md` and `CLAUDE.md` equals `@AGENTS.md`.
2. Check that zero unresolved `<...>` placeholders remain across created Markdown files.
3. Validate every local Markdown link and `#heading` anchor across `README.md`, `AGENTS.md`, `GLOSSARY.md`, `docs/**/*.md`, and `work-docs/**/*.md` (plus `../AGENTS.md` if touched).
4. Confirm `.gitignore` contains `/AGENTS.local.md` and `git ls-files AGENTS.local.md` prints nothing.
5. Run `git diff --check` (or whitespace check on untracked files) and report exact verification results to the owner. Ask whether to commit locally or make adjustments.
