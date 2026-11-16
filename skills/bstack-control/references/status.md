# Status file and recap

`status.md` is the coordinator's memory across restarts and days. A recap is the same
content shown to the owner. Both keep one order, so the owner can read either in seconds:
**Needs you, Overlaps, Working, Waiting, Idle, Host**, then the next step and the to-dos.

## Format

```markdown
# Status: <project or chief workspace>

Updated: <YYYY-MM-DD HH:MM>

## Needs you
1. `<session>` (tab `<label>`): <pointer, see "Pointers">.

## Overlaps
- `<a>` and `<b>` both change <area>. Plan order: `<a>` lands first; `<b>` rebases after.

## Work
| Work | Branch | Session | Stage | State | Waiting on | Progress |
| --- | --- | --- | --- | --- | --- | --- |
| <name> | <branch> | <agent name> | <stage> | working / waiting / idle / closed | owner / CI / nobody | <one line> |

## Host
<machine slept, low disk, a service down; "OK" otherwise>

## Next
<the recommended next work and its workflow>

## To-dos and ideas
- <items the owner mentioned in passing, with the date>
```

Rewrite the whole file on each update. Keep Needs you numbered, and say what each number
refers to when you mention it.

## Needs you

A session needs the owner when:

- it is blocked on an approval or a question dialog;
- its last reply asks the owner for a decision or an action not yet given, including an
  action a permission check refused;
- it reports a failure it cannot fix;
- a host problem stops it.

A session does not need the owner when:

- it waits on CI or on another person's approval;
- its input box holds text: that is usually the agent's own suggested reply
  (Claude Code), not the owner's unsent typing;
- its question was already answered.

A definition too wide fills the recap with noise; one too narrow misses a session that is
blocked. When unsure, read the screen again rather than guess.

## Pointers

When a session waits on the owner, the owner reads and answers it in that session's tab.
Report a **pointer** to it: the session, the tab, and the kind of wait, in one line, such
as "fix-login (tab fix-login): grill question 4 of about 7" or "add-cache: approve
`to-tickets`". The question's text, background, options, and recommendation stay in the
work session's tab; a coordinator that copies them makes the owner read everything twice.

## Recap

Lead with the first item under Needs you as the owner's next action. Then the sections in
order, each as short as its content allows; leave out an empty section except Host. End
with Next.

```text
Needs you
1. fix-login (tab fix-login): grill question 4 waits for your answer.
Overlaps: none
Working: add-cache (implementing ticket 02)
Waiting: split-config (CI on 1a2b3c4)
Idle: none
Host: OK
Next: answer fix-login's question, then start rate-limit (planned after add-cache).
```
