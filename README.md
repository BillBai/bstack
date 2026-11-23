# bstack

Personal user-invoked agent skills for bootstrapping, migrating, and maintaining multi-agent engineering repositories.

Every skill in `bstack` sets `disable-model-invocation: true` (and `allow_implicit_invocation: false` for Codex) so it consumes **zero context tokens** during normal sessions and loads only when explicitly invoked by the user.

## Installation

### Recommended: Local checkout + symlinks (instant updates across all agents)

Clone the repository and run `install.sh` to symlink `skills/*` into your local user skill directories (`~/.claude/skills/` for Claude Code, `~/.agents/skills/` for Codex and `pi`, and `~/.gemini/config/skills/` for Antigravity):

```bash
git clone https://github.com/BillBai/bstack.git ~/Workspace/bstack
~/Workspace/bstack/install.sh
```

Check or remove symlinks at any time:

```bash
~/Workspace/bstack/install.sh --check
~/Workspace/bstack/install.sh --uninstall
```

Because the skill directories are symlinked directly to `~/Workspace/bstack/skills/*`, editing reference files locally or running `git -C ~/Workspace/bstack pull` takes effect immediately across all installed harnesses without refreshing plugin caches.

### Alternative: Plugin managers

- **Claude Code:**
  ```bash
  claude plugin marketplace add BillBai/bstack
  claude plugin install bstack@bstack
  ```
- **Codex:**
  ```bash
  codex plugin marketplace add BillBai/bstack
  codex plugin add bstack@bstack
  ```

Pick either `install.sh` symlinks or plugin installation per agent, not both, to avoid duplicate skill entries.

## Skills

| Command | Mode | Description |
| --- | --- | --- |
| [`/bstack-setup`](./skills/bstack-setup/SKILL.md) | User-invoked only | Bootstrap a new repository, migrate an existing repository, or incrementally update an already-adopted repository to the `bstack` engineering workflow and multi-agent configuration. |
| [`/bstack-control`](./skills/bstack-control/SKILL.md) | User-invoked only | Run a project's control session or the cross-project chief-of-staff in T3 Code or Herdr: recap the state, dispatch work sessions into their own worktrees and threads or tabs, track them, and keep a status file. |

### Companion skills

`bstack-setup` configures repositories to work directly with [Matt Pocock's engineering skills](https://github.com/mattpocock/skills) (`grill-with-docs`, `grilling`, `domain-modeling`, `to-spec`, `to-tickets`, `implement`, `implement-spec`, `code-review`, and `tdd`), wiring their local issue-tracker, triage-label, and glossary conventions to `work-docs/<change>/` and `GLOSSARY.md`. Repositories set up with `/bstack-setup` do not need to run `/setup-matt-pocock-skills`.

## Updating the workflow or agent configuration

All canonical documents live as plain Markdown files under [`skills/bstack-setup/references/`](./skills/bstack-setup/references/), mirroring the target repository layout 1-to-1:

1. Edit the relevant Markdown files in `skills/bstack-setup/references/` (for example, updating model versions in `docs/agents/agent-environment.md` or refining rules in `docs/guide/workflow.md` and `root-AGENTS.md`), commit, and push.
2. Pull `~/Workspace/bstack` on any machine.
3. Run `/bstack-setup` inside any existing project to compare its workflow and agent files against the latest references and selectively apply updates without touching project-owned plans, glossaries, or `Current Focus`.
