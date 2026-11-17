# Domain documentation

Maintain one root [GLOSSARY.md](../../GLOSSARY.md) following Matt Pocock's
`domain-modeling` skill format. Consult it during design and naming discussions, surface
terminology conflicts promptly, and keep it strictly limited to project vocabulary (no
implementation details, specs, or status notes).

Record decisions in the document that owns the topic:

- Project, milestone, and iteration goals or scope go in the corresponding planning
  document under `docs/plans/`.
- Cross-change technical choices and weighed alternatives go in the milestone or iteration
  `design/` document; the resulting system design is kept current in
  `docs/arch/architecture.md`.
- Change-level design choices go in `work-docs/<change>/spec.md`.
- There is no `decision-log.md`. The owner's own words are quoted verbatim beside the
  decision they shaped, in the document that owns it.
- Create an ADR under `docs/adr/NNNN-slug.md` only when all three `domain-modeling`
  conditions hold: hard to reverse, surprising without context, and the result of a real
  tradeoff. Mark replaced ADRs as superseded.
