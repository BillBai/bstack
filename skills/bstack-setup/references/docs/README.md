# Documentation

This directory holds `<project-name>`'s maintained guides, product and milestone plans,
technical topic notes, status reports, architectural decision records, and agent
configurations.

## Layout

| Path | Purpose |
| --- | --- |
| [`guide/`](guide/) | Long-lived engineering guides: workflow, architecture, build and test rules, style guide, and prior-art references. |
| [`plans/`](plans/) | Product roadmap, milestone plans, iteration plans, designs, milestone/iteration research, progress tracking, and retros. |
| [`topics/`](topics/) | Standalone technical deep dives, algorithm study notes, and platform mechanism explorations not tied to a single iteration. |
| [`reports/`](reports/) | Periodic work summaries and milestone/project status reports. |
| [`agents/`](agents/) | New-machine setup, daily agent/model routing, and Matt Pocock skill configurations. |
| [`adr/`](adr/) | Architectural Decision Records (`NNNN-slug.md`) for hard-to-reverse, non-obvious tradeoff decisions. |
| [`../work-docs/`](../work-docs/) | Per-change execution records (`m<x>-i<y>-<slug>/`: `grill.md`, `spec.md`, `tickets/`, `review.md`, `probes/`) and `backlog.md`. |

## Primary entry points

- [`plans/roadmap.md`](plans/roadmap.md) — product boundaries and milestone sequence.
- [`plans/m1-skeleton/milestone.md`](plans/m1-skeleton/milestone.md) — active milestone scope, acceptance criteria, and open design questions.
- [`guide/workflow.md`](guide/workflow.md) — planning, implementation, verification, review, landing, and retro workflow.
- [`guide/prior-art-and-refs.md`](guide/prior-art-and-refs.md) — read-only sibling reference checkouts under `../ref/`.
- [`agents/agent-setup.md`](agents/agent-setup.md) — onboarding setup for new teammates and machines.
- [`agents/agent-environment.md`](agents/agent-environment.md) — daily runner, model-tier, and task-routing reference.
