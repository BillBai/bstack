# Workflow lean redesign 2026-11: design decisions

Status: complete in `bstack` working tree (2026-11-25); pending owner instruction before
committing or pushing `bstack`, then syncing to `tater`.

## Motivation and measured evidence

Commit timestamps and work-record line counts in `tater` (`m1-i3-deployment-floor` and
`r8-execution-correctness`) established two facts:

1. **Human gates are fast control valves, not the bottleneck:** final confirmation and
   landing took 3 minutes on `m1-i3-deployment-floor` (out of 2.5 hours total) and 4
   minutes on `r8-execution-correctness`.
2. **Three real bottlenecks accounted for the lost time:**
   - **Unbounded review ping-pong:** `r8-execution-correctness` ran 3 regular rounds plus
     2 expert rounds (plus 2 design-review rounds), spending hours on document numbering,
     comment wrapping, license headers, and platform-unrealistic edge defenses (such as
     small-object `std::bad_alloc` paths and restoring floating-point rounding registers
     immediately before process termination).
   - **Duplicated bstack-added record layers:** `m1-i3-deployment-floor` (28 minutes of
     code) produced 1,169 lines of Markdown; `r8-execution-correctness` produced 3,884
     lines (`grill.md` 267 + `spec.md` 1,569 + 15 tickets 1,616 + `review.md` 432).
   - **One-size-fits-all heavy process:** throwaway probes, small fixes, and major
     architectural changes all went through the full multi-stage specification pipeline.

Owner, on update order (2026-11-25): "其实我们的工作流在 bstack 里面，我们可能需要先讨论好，然后去
bstack 里面改，然后同步到 tater".

## Decisions

### D1. Three execution tracks instead of one-size-fits-all

Work routes to one of three tracks, keeping thin glue in `bstack` rather than copying the
internals of `pstack` or `mattpocock-skills`:

1. **Prototype or research:** `/poteto-mode` (`Prototype` / `Investigation` playbooks) or
   Matt Pocock's `prototype` / `research` skills. Throwaway code in scratch space, 0
   review rounds, no `work-docs/` directory, and one concise Markdown note in
   `research/<slug>.md` or `docs/topics/<slug>.md` (or in the throwaway branch commit).
2. **Lightweight task:** `/poteto-mode` (`Bug fix`, `Feature`, or `Refactoring` playbooks)
   for bounded work that changes no public API, package/wire format, or core architecture
   invariant. Three thin project adaptations apply: skip Cursor-only steps (`/deslop`,
   `control-ui`, `Opening a PR`) in favor of repository checks and CI; map subagent models
   via `/setup-pstack` or `agent-environment.md`; and keep human gates before code review
   (default 1 correctness round or owner skip) and before landing. Records live in a
   single file `work-docs/<change>/task.md` (~25–40 lines: `Status`, `Stage`, `TL;DR`
   written up front; optional `Decisions`, `Verification`, and `Review` completed at the
   end).
3. **Full change:** Matt Pocock's workflow (`grill-with-docs` → `to-spec` → `to-tickets`
   → `implement` / `implement-spec` → `code-review`) for cross-module vertical slices,
   core architecture, public APIs, formats, and ABI contracts.

Owner quotes (2026-11-25):
- "整体认同，prototype 预研探索-轻量task-正经的 task 三类"
- "但我还是想保留 matt 的那套流程呀"
- On `/poteto-mode` for the first two tracks: "可以"
- On `task.md` two-part timing and 4-section single-file layout: "都同意"

### D2. Keep Matt Pocock's native templates intact; trim only bstack-added overhead

Full changes preserve Matt's skills and their native templates unchanged, removing only
the extra prose layers `bstack` had stacked on top:

- **`grill.md`:** omitted for single-session grills; when created across sessions, deleted
  once consolidated into `spec.md`.
- **`spec.md`:** keeps `Status`, `Stage`, `Triage`, and a concise `## TL;DR` (kept for
  quick human reading), followed directly by `to-spec`'s 7 native sections. Drops the
  fixed embedded `Plain-language walkthrough` (generated in conversation on demand), drops
  writing internal implementation details back into `spec.md` (only behavioral choices
  marked `pending owner confirmation` are written back), drops duplicating the ticket list
  in `Further Notes`, and drops process diaries in `Comments`.
- **`tickets/<NN>-<slug>.md`:** uses `to-tickets`'s native 10-line
  `<local-ticket-template>` plus `../spec.md` link. Drops `## Context` restatements and
  gate-only empty tickets; keeps `## Comments` to 1–5 lines of final verification, CI
  build, `Untested paths`, and real pitfalls.
- **`review.md`:** keeps full reviewer outputs in `<dir>/<report>.md` outside the
  repository and trims `work-docs/<change>/review.md` to ~10 lines per round (`Scope` +
  models, one-line fixed blockers, rejected/deferred blockers with reasons, verification).
- **`docs/plans/`:** unchanged in this redesign.

Owner quotes (2026-11-25):
- "这个基本同意，但是 grill 可能还是需要掌握一些细节的。"
- "这个同意，walkthrough 可以按需让 agent 生成。"
- "我还是希望保留 matt pocock 的 skills 以及流程和 skill 里面定义的文档。 只是精简我们自己添加的文档"
- "1 A tldr 我还是希望保留的，毕竟 spec.md 真的看不懂"

### D3. Keep Spec Design Review and combine Spec + Tickets briefing

Spec Design Review remains an owner-confirmed gate before briefing. When skipped or when
Round 1 raises no dispute that shakes an approved decision or module boundary, the agent
applies clear fixes to `spec.md`, drafts the ticket breakdown (`to-tickets` steps 1–4),
and presents the spec, surfaced design suggestions, and proposed breakdown in one combined
briefing. Only when Design Review exposes a core design dispute does the agent pause to
settle that decision with the owner before drafting tickets. Consistent with `to-tickets`
steps 4–5, `tickets/<NN>-<slug>.md` files are published only after the owner approves the
breakdown (if the owner approves both the breakdown and implementation in the same reply,
the agent publishes the tickets and starts implementation without an extra round).

Owner quote (2026-11-25): "我觉得 spec 的 review 还是有必要的".

### D4. Positive three-condition Blocker bar, open Suggestions channel, and 2-round cap

All review stages (spec design, regular `Standards`/`Spec`, expert, and lightweight
correctness review) use positive principles rather than a hardcoded list of past edge-case
examples:

1. **Positive scope boundary:** reviews cover behavioral correctness, architecture and
   module boundaries, ownership, and maintainability; mechanical formatting, wrapping,
   numbering, and hand-counted file/test lists belong to automated checks.
2. **Two-bucket output:**
   - **`Blockers`** must meet three positive conditions together — **realistic trigger**
     on the target platform within the module's contracts, **material harm**, and
     **proportionate fix** — and state exact location, trigger path, and consequence.
   - **`Suggestions & Alternatives`** explicitly encourages open-ended architectural
     ideas, simpler designs, and maintainability improvements, guarded on the execution
     side: implementing agents never auto-edit code for this bucket, and it never triggers
     another review round; the main agent surfaces worthwhile items for the owner to
     decide.
3. **Convergence:** full changes default to **1 concurrent code-review round** (Regular
   `Standards`/`Spec` + cross-family Expert in parallel; owner may pick sequential stages
   for high-risk changes). Localized repairs with failing-then-passing tests converge
   after Round 1. Round 2 runs only when Round 1 repairs alter core control flow,
   concurrency, memory safety, or high-risk boundaries, and reviews only the incremental
   repair diff (hard cap: 2 rounds). Routine reviews stay fast and read-only; `pstack`'s
   `interrogate` runs minimal reproductions only to adjudicate contested high-risk claims.

Owner quotes (2026-11-25):
- "停下来问我不是瓶颈，你觉得呢？"
- "另外同意你说的审查无线拉锯耗时最大"
- "0.1% 极端防御性边界 这种问题可大可小，看影响范围可能要复审的"
- "（日常要求 reviewer 跑可运行复现）这个可能会让 review 变得非常冗长吧？"
- "8 条反钻牛角尖禁令 这个我们需要详细讨论一下。但是我觉得需要允许模型广泛提发散性建议。"
- "问题是如果我们列举了这几个例子，那就变成了只针对这几个条款审查了"
- On replacing the example list with the positive 3-condition `Blockers` bar + open
  `Suggestions & Alternatives` bucket with execution-side guardrails: "同意这个。"
- On the thin-glue integration with `pstack` and `mattpocock-skills` and the 3-track
  operational playbook: "认可".
