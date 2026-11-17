# Local agent rules

Personal rules for agents working in this checkout. Git ignores this file, and each member
edits it freely, on any topic. It adds to `AGENTS.md` and cannot relax its working rules.

## Language

- Discuss work with me in Chinese. Write natural Chinese without jargon such as 落地, 对齐,
  or 闭环, and without single-character slang verbs such as 崩, 挂, or 抛.
- Write repository prose, code comments, and commit messages in English.

## Working preferences

- Explain each point from zero in short plain sentences, with one small example such as a
  code snippet or a flow sketch.
- Correctness comes first. When evidence shows an earlier decision of mine is wrong,
  recommend the correct design and cite the evidence.
- Design on merit. Do not add constraints that neither the requirements nor the
  architecture ask for, such as keeping a diff small or matching an old output byte for
  byte.
- In review reports, lead with architecture, ownership, dependencies, and readability,
  then edge-case defects.
- Before implementing a plan of several changes, walk me through it in the conversation:
  the background first, then one change per message.
