# Unify `bstack-control` coordinator cwd onto `<project>_workspace/` (2026-11): design decisions

Status: decisions settled with the owner (2026-11-24); skill and reference edits applied (2026-11-24).

## The task

Unify `bstack-control` so that **every** project control session — single-repository and multi-repository alike — runs with its cwd at `<project>_workspace/` instead of placing single-repository control sessions inside `<project>_workspace/<project>/` and multi-repository control sessions at `<project>_workspace/`.

## Decisions

### D1. Role detection and workspace guardrails

Replace the Git main-checkout detection in `skills/bstack-control/SKILL.md` ("Pick the role") with `<project>_workspace/` detection and explicit safety guardrails:

1. `projects.md` in cwd selects `chief`.
2. A `.git` entry in cwd alongside `control/` or a `*_workspace` directory with immediate child Git main checkouts stops and warns about a stray `.git`.
3. Running inside a Git checkout or worktree checks whether an ancestor (`..`, `../..`, or `../../..`) is `<project>_workspace/` (ends with `_workspace` or holds `control/`) and offers to open `control <workspace-path>` instead of running inside the child checkout.
4. Outside a Git work tree, either `control/` in cwd or a `*_workspace` basename with at least one immediate child Git main checkout (excluding `control/`, `worktrees/`, `ref/`, and hidden directories) selects `control`. Requiring `control/` or `_workspace` prevents false positives in umbrella directories such as `~/Workspace`.
5. `control <path>` validates `<path>` with the same guardrails and derives `<project>` by stripping a trailing `_workspace` (or `-workspace`) suffix.

### D2. Managed repository list via `control/README.md` (with zero-config single-repo default)

On Start and Refresh, a control session needs to know which child repositories to `git -C <repo> fetch`, inspect for worktrees and overlaps, read `AGENTS.md` / workflow docs from, and query in T3 Code:

1. If `control/README.md` lists the managed repository or repositories, use that list directly.
2. Otherwise inspect immediate child directories (depth 1 only, skipping `control/`, `worktrees/`, `ref/`, and hidden directories): if there is **exactly one** Git main checkout, use it with zero extra config; if there are **zero or two or more**, ask the owner and offer to record the confirmed list in `control/README.md` so future starts do not re-ask.

Workspace-level `AGENTS.md` is still read for mission and workspace policies, but is not heuristically parsed to infer managed repositories.

The owner, 2026-11-24: "管控仓库，直接在 README.md 里面记录就行".

### D3. Worktree layout convention

- Single managed repository (default): `worktrees/<name>/`.
- Two or more managed repositories (default), or when explicitly specified in `control/README.md`: `worktrees/<repo>/<name>/`.
- Workspace-wide work with no owning repository: agree on a plain directory (such as `control/work/<name>/`) and record destination with the owner before dispatch.

`skills/bstack-setup/references/docs/guide/workflow.md` adds a brief clause noting `worktrees/<repo>/<name>/` for multi-repository workspaces, while `skills/bstack-setup/references/workspace-AGENTS.md` remains independent of `bstack-control` (per [`bstack-control.md`](./bstack-control.md), D13). The owner accepted this recommendation (2026-11-24).

### D4. Two-level `AGENTS.local.md` support

Control sessions support both repository-level `<repo>/AGENTS.local.md` and workspace-level `<project>_workspace/AGENTS.local.md` without forcing duplication:

- The coordinator reads workspace-level `AGENTS.local.md` and each managed `<repo>/AGENTS.local.md` when present.
- When dispatching a worktree: if `<repo>/AGENTS.local.md` exists and is gitignored (`git -C <repo> check-ignore -q AGENTS.local.md`), symlink it into the worktree (`../../<repo>/AGENTS.local.md` for flat worktrees, `../../../<repo>/AGENTS.local.md` for nested `worktrees/<repo>/<name>/`); otherwise cite `<project>_workspace/AGENTS.local.md` by absolute path in the brief (symlinking only if Git ignores it in `<repo>`).

The owner accepted this recommendation (2026-11-24).

### D5. Explicit doc reads and `git -C <repo>`

Because the coordinator's cwd is `<project>_workspace/` rather than a child repository root:

- Control sessions explicitly read workspace `AGENTS.md` / `AGENTS.local.md` / `control/README.md`, plus each managed repository's `<repo>/AGENTS.md`, `<repo>/AGENTS.local.md`, and linked workflow docs on Start.
- All Git operations use `git -C <repo> ...` (and `git -C <worktree> status --porcelain`).
- Control state paths sit directly under cwd (`control/status.md`, `control/briefs/<name>.md`, `worktrees/...`) without `../` escapes.
- Multi-repository workspaces add an optional `Repo` column in `control/status.md`'s Work table and check cross-repository overlaps alongside per-repository diffs.

### D6. Host mechanics in T3 Code and Herdr

- **T3 Code (`references/t3.md`):** register `<project>_workspace` (title `<project>_workspace`) for the coordinator thread (`<project>-control`, `workspaceStrategy: { type: "root" }`) and workspace-wide threads, and register each managed repository `<project>_workspace/<repo>` (title `<repo>`) for its work threads (`workspaceStrategy: { type: "existing_worktree", worktreePath }`). During live-state inspection, control sessions list top-level threads across `<project>_workspace` **and** each managed repository's `projectId`. This guarantees T3 Code's worktree validation and Git UI bind to the real repository while cleanly grouping multi-repo work threads. The owner accepted this recommendation (2026-11-24).
- **Herdr (`references/herdr.md`):** one Herdr workspace per project with `--cwd <project>_workspace` and label `<project>`; work-session tabs open in the same Herdr workspace with `--cwd <worktree or work dir>` (noting `--add-dir <project>_workspace` for `agy` when reading briefs or workspace-level `AGENTS.local.md`).

## Files touched

- `docs/design/control-workspace-cwd-2026-11.md` (new)
- `docs/design/bstack-control.md`
- `skills/bstack-control/SKILL.md`
- `skills/bstack-control/roles/control.md`
- `skills/bstack-control/roles/chief.md`
- `skills/bstack-control/references/sessions.md`
- `skills/bstack-control/references/t3.md`
- `skills/bstack-control/references/herdr.md`
- `skills/bstack-control/references/status.md`
- `skills/bstack-control/references/work-brief.md`
- `skills/bstack-setup/references/docs/guide/workflow.md`
