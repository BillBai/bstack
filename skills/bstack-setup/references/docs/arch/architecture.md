# Architecture

`<project-name>` <one-sentence statement of what the system does, for whom, and on which
platforms>. This document describes the system as it is now. Plans and change specs
describe how it gets here; update this document in the change that alters the design.

## Goals and invariants

- **<Invariant name>:** <the property every design must keep, stated so a reviewer can
  check it>.

## Parts and boundaries

| Part | Responsibility | Owns | Depends on |
| --- | --- | --- | --- |
| `<component-1>` | <what it does> | <the state, objects, or files it owns> | <the parts it calls> |

## Main flow

<The main path through the system as a short sequence, such as input → stage → output,
with one concrete example.>

## Related records

Design decisions behind this architecture live in `docs/plans/*/design/` documents and in
[`docs/adr/`](../adr/).
