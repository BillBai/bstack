# Issue tracker: Local Markdown

Work records are local Markdown files tracked in Git under `work-docs/`. Use these paths
in place of any skill's example `.scratch/`, `issues/`, or external issue-service paths.

## Directory and file layout

- **Change directories:** every change uses `work-docs/m<x>-i<y>-<slug>/` (for example,
  `work-docs/m1-i1-core-pipeline/`). Use `m0-i0-<slug>` for pre-M1 setup (such as
  `work-docs/m0-i0-project-bootstrap/`) and `m<x>-i0-<slug>` for milestone-level changes
  not tied to a numbered iteration.
- **`grill.md`:** optional discussion draft holding resolved points, verbatim owner quotes,
  and open questions before `spec.md` is created; consolidate into `spec.md` once written.
- **`spec.md`:** complete change design using `to-spec` sections, prepended with `Status`,
  `Stage`, `Triage` (see [triage-labels.md](triage-labels.md)), and a plain-language
  walkthrough readable within 15 minutes.
- **`tickets/<NN>-<slug>.md`:** one file per ticket numbered from `01` in dependency
  order, using the `to-tickets` template and linking to `../spec.md`. Keep `Status` and
  acceptance checkboxes current, and record useful execution notes and verification
  evidence under `## Comments`.
- **`review.md`:** findings, dispositions, and verifications across all regular and expert
  review rounds.
- **`probes/`:** optional directory created only when retaining reproducible programs that
  back a recorded decision.
- **`work-docs/backlog.md`:** cross-change deferred problems that are not yet scheduled in
  a milestone or iteration plan, with context and evidence links.

## Skill terms

In skill instructions, **publish** means write the local file, **fetch** means read it, and
**close** means mark the ticket complete and retain it in place. Stage progression,
reviews, CI, and landing rules are defined in [workflow.md](../guide/workflow.md).
