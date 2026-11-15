# Agent setup

This guide covers setting up a new machine or environment to work on `<project-name>`.
Daily model tiers, provider IDs, and task-routing rules are maintained in
[agent-environment.md](agent-environment.md).

## 1. Agent CLIs

Set up the primary agents **Claude Code** and **Codex**, along with **`pi`** for internal
model providers; **`agy`** (Antigravity) is optional while under evaluation.

Keep API credentials, authentication tokens, and personal preferences in user-global
configuration rather than committing them to this repository.

## 2. Skills and helper tools

- **Required skills:** Matt Pocock's engineering skills (`grill-with-docs`, `grilling`,
  `domain-modeling`, `to-spec`, `to-tickets`, `implement`, `implement-spec`,
  `code-review`, and `tdd`), made available to your active agent harnesses.
- **Optional helpers (not required):** `herdr` (terminal multiplexer for watching
  delegated agent sessions in separate tabs), `bstack`, `pstack`, and `i-have-adhd`.

Project-specific skill settings live in [domain.md](domain.md),
[issue-tracker.md](issue-tracker.md), and [triage-labels.md](triage-labels.md).

## 3. Reference checkouts

Clone read-only prior-art and upstream reference repositories into `../ref/` in the parent
workspace as needed; see [prior-art-and-refs.md](../guide/prior-art-and-refs.md).

## 4. Environment check

Before starting a change on a new setup, verify that:

1. Your primary agent CLIs run cleanly and can access the models listed in
   [agent-environment.md](agent-environment.md).
2. The required Matt Pocock `SKILL.md` files and templates are readable from your active
   harness.
3. Git author identity is configured for this repository.
