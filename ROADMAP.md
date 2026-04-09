# Roadmap — claude-team-cli

> Living product roadmap. Current priorities and forward bets.
> Updated by Claude using the [roadmap skill](https://github.com/d6veteran/claude-roadmap-skill).

---

## Current Roadmap

### Shipping Now — v0.6

**Two-mode coordinator + branch hygiene infrastructure**

The coordinator is now mode-aware. Casual mode (default) routes team members and suggests operating modes without enforcing branch discipline — designed for personal projects and anyone committing directly to main. Prod mode is an explicit opt-in for teams that need branch registration, worktree isolation, and a full MR/PR workflow.

- [x] `claude-team coordinator on` — casual mode, no branch enforcement
- [x] `claude-team coordinator prod` — prod mode, branch required before any code
- [x] `/prod-mode` and `/casual-mode` slash commands for mid-session toggling
- [x] `claude-team status` shows active mode: `on (casual)` or `on (prod)`
- [x] Branch hygiene infrastructure: `branch start`, `done`, `abandon`, `status`, `list`, `guard`
- [x] Session/worktree isolation: `session start`, `done`, `status`, `list`
- [x] 82-test suite covering all CLI commands and both coordinator modes
- [ ] README refactor — casual/prod modes clearly explained; branch hygiene section framed as prod-only
- [ ] ROADMAP.md — this file

### Near-Term

- README getting-started path optimized for casual users
- Expanded test coverage for mode-specific coordinator behavior

---

## Aspirational — Looking for Feedback

These are directions we're exploring. If any of them would change how you use the tool, [open an issue](https://github.com/code-katz/claude-team-cli/issues) — real usage feedback shapes what gets built next.

**Local profile overrides**
A `~/.claude/team/local/` directory for per-user customizations without forking the repo. Override any persona's behavior for your specific workflow without touching the upstream source.

**Team-scoped profiles**
`claude-team init` creates a `.claude-team/` config at the project root, so team conventions are shared across developers on the same repo. Consistent team member behaviors without everyone managing their own `~/.claude/team/` independently.

**Session handoff briefing**
When switching team members mid-task, the coordinator generates a structured briefing so the incoming specialist doesn't start cold: decisions made this session, open questions, and a direct question addressed to the new team member by name.

---

## Revision History

| Date | Type | Description |
|---|---|---|
| 2026-04-09 | snapshot | Initial ROADMAP.md — v0.6 shipping, aspirational backlog identified |
