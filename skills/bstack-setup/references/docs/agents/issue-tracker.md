# Issue tracker: Local Markdown

Work records are local Markdown files tracked in Git under `work-docs/`. Use these paths
in place of any skill's example `.scratch/`, `issues/`, or external issue-service paths.

## Directory and file layout

- **Change directories:** every change uses `work-docs/<change>/`. A change inside an
  iteration names it `m<x>-i<y>-<slug>` (for example, `work-docs/m1-i1-core-pipeline/`),
  and pre-M1 setup uses `m0-i0-<slug>` (such as `work-docs/m0-i0-project-bootstrap/`).
  Work outside an iteration, such as a retro, a refactoring series, or a workflow change,
  uses a descriptive slug with no required pattern.
- **`grill.md`:** optional discussion draft holding resolved points, verbatim owner quotes,
  and open questions before `spec.md` is created; consolidate into `spec.md` once written.
- **`spec.md`:** complete change design using `to-spec` sections, prepended with `Status`,
  `Stage`, `Triage` (see [triage-labels.md](triage-labels.md)), a TL;DR readable within
  10 minutes, and a detailed plain-language walkthrough (see
  [workflow.md](../guide/workflow.md#the-spec)).
- **`tickets/<NN>-<slug>.md`:** one file per ticket numbered from `01` in dependency
  order, using the `to-tickets` template and linking to `../spec.md`. Keep `Status` and
  acceptance checkboxes current, and record useful execution notes and verification
  evidence under `## Comments`.
- **`review.md`:** findings, dispositions, verifications, and each round's model and
  effort across the design review and all regular and expert review rounds.
- **`probes/`:** optional directory created only when retaining reproducible programs that
  back a recorded decision.
- **`work-docs/backlog.md`:** cross-change deferred problems that are not yet scheduled in
  a milestone or iteration plan, with context and evidence links.

## Skill terms

In skill instructions, **publish** means write the local file, **fetch** means read it, and
**close** means mark the ticket complete and retain it in place. Design decisions belong
in the spec; tickets refer to them instead of copying them. Stage progression,
reviews, CI, and landing rules are defined in [workflow.md](../guide/workflow.md).
