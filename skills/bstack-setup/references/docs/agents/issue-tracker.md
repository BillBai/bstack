# Issue tracker: Local Markdown

Work records are local Markdown files tracked in Git under `work-docs/`. Use these paths
in place of any skill's example `.scratch/`, `issues/`, or external issue-service paths.

## Directory and file layout

- **Change directories:** code changes use `work-docs/<change>/`. A change inside an
  iteration names it `m<x>-i<y>-<slug>` (for example, `work-docs/m1-i1-core-pipeline/`),
  and pre-M1 setup uses `m0-i0-<slug>` (such as `work-docs/m0-i0-project-bootstrap/`).
  Work outside an iteration, such as a retro, a refactoring series, or a workflow change,
  uses a descriptive slug with no required pattern. Throwaway prototypes and standalone
  research notes do not create `work-docs/` directories; their conclusions live in the
  owning plan's `research/<slug>.md` or `docs/topics/<slug>.md`.
- **`task.md` (lightweight tasks):** single-file record (~25–40 lines) for changes running
  on the lightweight `/poteto-mode` track. Begins with `Status` and `Stage` lines,
  followed by `## TL;DR` (including `Out of scope`), optional `## Decisions` (tradeoffs,
  verbatim owner quotes, and any `pending owner confirmation` items), `## Verification`,
  and `## Review` (`Skipped by owner` or a compact 1-round summary). Creates no
  `spec.md`, `tickets/`, or separate `review.md`.
- **`grill.md` (full changes, temporary only):** optional draft created only when a grill
  spans multiple sessions to hold resolved points, verbatim owner quotes, and open
  questions before `spec.md` exists; delete `grill.md` once consolidated into `spec.md`.
- **`spec.md` (full changes):** complete change design using `to-spec`'s native template
  sections, prepended with `Status`, `Stage`, `Triage` (see
  [triage-labels.md](triage-labels.md)), and a concise `## TL;DR` (see
  [workflow.md](../guide/workflow.md#the-spec)). Plain-language walkthroughs are generated
  in conversation on demand rather than stored in `spec.md`.
- **`tickets/<NN>-<slug>.md` (full changes):** one file per vertical slice numbered from
  `01` in dependency order, using `to-tickets`'s native `<local-ticket-template>` and
  linking to `../spec.md`, without copying spec context or adding gate-only empty tickets.
  Keep `Status` and acceptance checkboxes current, and keep `## Comments` concise (1–5
  lines for final verification, CI build, `Untested paths`, and key pitfalls).
- **`review.md` (full changes):** compact per-round ledger (~10 lines per round) across
  spec design review and code review: pinned commits, reviewer models/efforts, one-line
  fixed blockers, rejected/deferred blockers with reasons, and verification. Full raw
  reports stay in temporary files outside the repository.
- **`probes/`:** optional directory created only when retaining reproducible programs that
  back a recorded decision.
- **`work-docs/backlog.md`:** cross-change deferred problems that are not yet scheduled in
  a milestone or iteration plan, with context and evidence links.

## Skill terms

In skill instructions, **publish** means write the local file, **fetch** means read it, and
**close** means mark the ticket complete and retain it in place. Design decisions belong
in `spec.md` (or `task.md`); tickets refer to them instead of copying them. Track
selection, stage progression, review convergence, CI, and landing rules are defined in
[workflow.md](../guide/workflow.md).
