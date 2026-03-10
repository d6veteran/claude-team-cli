# claude-dev-team — Development Log

A living record of architectural decisions, milestones, key insights, and strategic direction.
Auto-maintained via Claude devlog skill. Entries are reverse-chronological.

---

## [2026-03-10] Devlog skill schema v2 — richer entry format

**Category:** `feature`
**Tags:** `devlog`, `schema`, `skill`, `adr`
**Risk Level:** `low`
**Breaking Change:** `yes`

### Summary
Updated the devlog skill (`~/.claude/skills/devlog/SKILL.md`) with a richer entry schema: two new metadata fields (`Risk Level`, `Breaking Change`), a dedicated `Decisions Made` section, and a revised category taxonomy.

### Detail
- Added `Risk Level: low | med | high` metadata to every entry — describes blast radius and reversibility
- Added `Breaking Change: yes | no` metadata — flags when public contracts, APIs, or CLI behavior changes
- Added `### Decisions Made` section to the entry template — a lightweight inline ADR for trade-off decisions
- Replaced old categories (`architecture`, `milestone`, `takeaway`, `strategy`) with: `feature`, `bugfix`, `refactor`, `infrastructure`, `security`, `milestone`, `strategy`
- Added new `## Fields Explained` section to document the new fields with definitions and value options
- Updated Style Guidelines with two new rules: flag `high` risk on auth/secrets/data model changes; always populate `Decisions Made` when alternatives were considered
- `strategy` category retained — preserved for purely non-technical/business entries

### Decisions Made
- **Kept `strategy` category**: Initial proposal dropped it in favor of a code-centric taxonomy. Restored after recognizing business/non-technical decisions need a home in the log.
- **Removed `takeaway` and `architecture`**: Both were vague and overlapped with other categories. `architecture` maps cleanly to `refactor`/`infrastructure`; `takeaway` knowledge now belongs in `Decisions Made` of the relevant entry.
- **`Decisions Made` as a section, not inline in `Detail`**: Separating ADR content from general context makes it easier to scan entries for trade-off rationale specifically.

### Related
- Skill file: `~/.claude/skills/devlog/SKILL.md`
- Breaking change: existing DEVLOG.md entries using `architecture`, `takeaway` categories are not retroactively updated — new entries use the new taxonomy

---

## [2026-03-08] Added bash test suite — 36 tests covering all CLI commands

**Category:** `milestone`
**Tags:** `testing`, `quality`, `v0.2`

### Summary
Added `tests/run.sh` — a self-contained 36-test bash suite covering all CLI commands. No external dependencies required.

### Detail
- 36 tests across: help, list, show (incl. case-insensitivity + error), use (injection, switching, idempotency), coordinator block survival across persona switches, reset, coordinator on/off (incl. idempotency), status, and error handling
- Uses a temp `$HOME` (`mktemp -d`) and `CLAUDE_TEAM_PROFILES` env override to run in full isolation — never touches the real `~/.claude/CLAUDE.md`
- Self-contained pure bash — no bats or other external test framework required; runs anywhere the CLI runs
- Key bug caught during implementation: CLI's `touch "$CLAUDE_MD"` fails if `$HOME/.claude/` doesn't exist; fixed in test setup with `mkdir -p "$TEST_HOME/.claude"`
- Decided against adding a `claude-team test` subcommand — single-dev personal tool, `bash tests/run.sh` is sufficient and keeps the CLI surface minimal

### Related
- Protects the awk block manipulation logic in `cmd_use`, `cmd_reset`, and `cmd_coordinator` — the highest-risk area of the codebase

---

## [2026-03-08] v0.2 shipped — in-session persona switching via slash commands

**Category:** `milestone`
**Tags:** `feature`, `slash-commands`, `v0.2`, `bash-compat`

### Summary
Shipped v0.2: in-session persona switching without restarting Claude Code. Users can now type `/robin`, `/akira`, `/sasha`, `/toni`, or `/river` in any Claude Code session to switch personas immediately. Also added `claude-team install-commands` subcommand and switched the installer to symlink the CLI.

### Detail
- Added `commands/` directory with 6 slash command files: one per team member + `/team`
- Each command file calls `claude-team use <name>` (persistent state) AND embeds the full persona inline (immediate in-session adoption — no restart required)
- Added `cmd_install_commands()` to `bin/claude-team`: copies commands to `~/.claude/commands/`, lists installed commands with usage
- Updated `install.sh` to install slash commands as part of the standard install flow
- Changed CLI install from `cp` to `ln -sf` (symlink) — repo edits take effect immediately without reinstalling
- Fixed bash 3.2 compat in install.sh: replaced `${var^^}` with `tr '[:lower:]' '[:upper:]'`
- Updated README to reflect v0.2 as current, moved slash commands from roadmap to shipped

### Related
- v0.3+ backlog: session handoff context, local profile overrides, new members (Alex/DevOps, Morgan/Security, Jordan/Data)

---

## [2026-03-07] v0.1 shipped — blog posts, roadmap, and gitignore cleanup

**Category:** `milestone`
**Tags:** `launch`, `content`, `roadmap`, `v0.1`

### Summary
Completed the v0.1 feature set for claude-dev-team: five personas, coordinator layer, bash 3.2-compatible CLI, and installer. Added a PMM-voice blog post series and a product roadmap to the README.

### Detail
- Five team member personas shipped: Robin (QA/Testing), Akira (Backend), Sasha (Frontend), Toni (Product Marketing), River (Product)
- Coordinator layer added as a separate CLAUDE.md block — survives team member switches, suggests team member + operating mode (Plan / Ask before edits / Edit automatically) at task start and on domain shifts
- Fixed bash 3.2 compatibility (macOS ships bash 3.2; removed `${var^}` and `${var,,}` in favor of `awk`/`tr` helpers)
- Fixed wildcard bug in `cmd_list` where empty `$active` matched every team member
- Fixed coordinator appearing in `claude-team list` output
- Wrote five blog posts in Toni's PMM voice (benefit-first, audience-obsessed, outcome-focused) — one per team member, stored in `claude-dev-team-blog-posts.md` outside the repo
- Added roadmap to README covering: v0.1 current state, v0.2 slash command shortcuts (`/robin`, `/sasha-plan`, etc. via `.claude/commands/`), and v0.3+ backlog
- Added `claude-dev-team-blog-posts.md` to `.gitignore` (draft content, not repo)

### Related
- Slash command implementation planned for v0.2 — Claude Code `.claude/commands/` Markdown files invoking `claude-team use <name>`
