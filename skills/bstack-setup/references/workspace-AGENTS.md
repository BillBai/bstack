# <workspace-name>

## Mission

<Concise statement of the multi-repository workspace's overall mission, target platforms,
and boundaries.>

## Scope and subprojects

This directory groups multiple independent Git repositories in one workspace. Read a
subproject's own `AGENTS.md` when working inside it. Do not create new subproject
repositories or start unapproved tracks without explicit owner instruction.

1. **`<subproject-1>`** (`<subproject-1>/AGENTS.md`): <role, current status, and link to
   its roadmap>.
2. **`<subproject-2>`** (planned): <planned scope and boundaries>.

Checkouts under `ref/` hold upstream and historical reference implementations and are
strictly read-only. New implementation lives in the corresponding subproject repository;
this file records only workspace mission, cross-repo scope, and subproject entry points.
