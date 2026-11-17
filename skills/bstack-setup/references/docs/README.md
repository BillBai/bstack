# Documentation

This directory holds `<project-name>`'s architecture, maintained guides, product and
milestone plans, technical topic notes, status reports, architectural decision records,
agent configurations, and archived history.

## Layout

| Path | Purpose |
| --- | --- |
| [`arch/`](arch/) | The current system design: parts, responsibilities, boundaries, and invariants. Start with [`arch/architecture.md`](arch/architecture.md). |
| [`guide/`](guide/) | Long-lived engineering guides: workflow, build and test rules, style guide, and prior-art references. |
| [`plans/`](plans/) | Product roadmap, milestone plans, iteration plans, designs, milestone/iteration research, progress tracking, and retros. |
| [`topics/`](topics/) | Standalone technical deep dives, algorithm study notes, and platform mechanism explorations not tied to a single iteration. |
| [`reports/`](reports/) | Periodic work summaries and milestone/project status reports. |
| [`agents/`](agents/) | New-machine setup, daily agent/model routing, and Matt Pocock skill configurations. |
| [`adr/`](adr/) | Architectural Decision Records (`NNNN-slug.md`) for hard-to-reverse, non-obvious tradeoff decisions. |
| [`archive/`](archive/) | Superseded designs, plans, and records kept for provenance. Not the current source of truth; no routine reading. |
| [`../work-docs/`](../work-docs/) | Per-change execution records (`<change>/`: `grill.md`, `spec.md`, `tickets/`, `review.md`, `probes/`) and `backlog.md`. |

## Primary entry points

- [`arch/architecture.md`](arch/architecture.md) — the system's parts, boundaries, and invariants.
- [`plans/roadmap.md`](plans/roadmap.md) — product boundaries and milestone sequence.
- [`plans/m1-skeleton/milestone.md`](plans/m1-skeleton/milestone.md) — active milestone scope, acceptance criteria, and open design questions.
- [`guide/workflow.md`](guide/workflow.md) — planning, implementation, verification, review, landing, and retro workflow.
- [`guide/prior-art-and-refs.md`](guide/prior-art-and-refs.md) — read-only sibling reference checkouts under `../ref/`.
- [`agents/agent-setup.md`](agents/agent-setup.md) — onboarding setup for new teammates and machines.
- [`agents/agent-environment.md`](agents/agent-environment.md) — daily runner, model-tier, and task-routing reference.
