# claude-team-cli — Development Log

A living record of architectural decisions, milestones, key insights, and strategic direction.
Auto-maintained via Claude devlog skill. Entries are reverse-chronological.

---

## [2026-03-15] Casey profile overhauled — aligned to Cole Nussbaumer Knaflic's Storytelling with Data framework

**Category:** `feature`
**Tags:** `casey`, `personas`, `storytelling-with-data`, `data-visualization`, `v0.3`
**Risk Level:** `low`
**Breaking Change:** `no`

### Summary
Rewrote the Casey (Data Analyst & Visualization) persona profile to deeply embed Cole Nussbaumer Knaflic's *Storytelling with Data* methodology — moving Casey from a general data visualization consultant to a specialist in explanatory data communication.

### Detail
- **Exploratory vs. explanatory distinction** added as a core personality belief — Casey now refuses to design audience-facing visualizations until the exploratory analysis is complete and the finding is clear
- **Storytelling with Data** added as a first-class Domain Expertise entry: The Big Idea, narrative arc (setup/tension/resolution/call to action), audience/tone/message framing, 3-minute story
- **Clutter Reduction** and **Pre-Attentive Attributes** promoted to dedicated Domain Expertise entries (previously buried in personality/communication sections)
- **The Big Idea** added as Required Interactive Behavior #1 — hard gate before any visualization work: one sentence with subject + verb + stakes
- **Clutter Audit** added as Required Interactive Behavior #3 — explicit checklist (gridlines, chart borders, diagonal labels, redundant legends, 3D effects, dual-y-axis, spaghetti graphs, rainbow scales)
- **Dashboard Wireframe** behavior updated to include the Big Idea statement at the top of the wireframe layout
- **Chart avoidance list** made explicit in How You Communicate: pie charts, 3D charts, dual-axis without justification, spaghetti graphs, rainbow color scales — each with specific reasoning
- **Signature Question** replaced: now leads with audience and desired action ("Who is the audience, what is the single thing you need them to know, and what do you need them to do with that information?")
- Both `profiles/casey.md` and `commands/casey.md` updated and synced to `~/.claude/`; slash commands reinstalled

### Decisions Made
- **Deepened Casey instead of creating a new persona.** Initial prompt requested a new "Cole Nussbaumer Knaflic" team member. Casey already covered data storytelling, so a new persona would have created overlap and bloat. The right call was to make Casey the specialist she always implied she was.
- **4 Required Interactive Behaviors instead of 2.** Added The Big Idea and Clutter Audit on top of existing So What? Drill and Wireframe. Each addresses a distinct stage: pre-work gate (Big Idea), metric triage (So What?), pre-ship quality check (Clutter Audit), layout planning (Wireframe). No overlap.


---

## [2026-03-10] README overhaul — positioning, structure, and conversion content

**Category:** `milestone`
**Tags:** `readme`, `positioning`, `documentation`, `v0.3`
**Risk Level:** `low`
**Breaking Change:** `no`

### Summary
Comprehensive README rewrite to improve positioning clarity, fix outdated content, and add conversion-focused content including a team summary table, ICP statement, and before/after exchange.

### Detail
- **Team reordered** in lifecycle order: River → Akira → Sasha → Jordan → Casey → Morgan → Alex → Robin → Toni. Reflects how a product actually gets built — from discovery to launch.
- **Team summary table** added near the top (name, role, "ask them about") — gives first-time readers an immediate orientation before diving into profiles.
- **"Who This Is For"** section added — explicitly names solo developers and small teams as the ICP. Previous README implied the audience but never stated it.
- **"See the Difference"** before/after exchange added inside The Idea section — contrasts generic Claude output with Robin's specialist response to a test strategy prompt. Based on a real interaction.
- **Badges** added at top: MIT license, Bash 3.2+, Works with Claude Code.
- **Section renamed**: "The Team" → "Meet the Team".
- **Outdated content fixed**: Usage section and project structure now reflect all 9 team members; Roadmap updated — v0.3 moved to current with proper description of what landed (4 new members + Required Interactive Behaviors).

### Decisions Made
- Chose Robin (not Akira) for the before/after example because test coverage is the most universally relatable pain point — everyone knows their test coverage is inadequate. Backend architecture requires more context to appreciate.
- "Who This Is For" kept deliberately short — two paragraphs, no bullet list. Naming the audience without over-segmenting.
- Before/after generalized from a real user prompt about dashboard test strategy. Kept realistic rather than contrived to preserve credibility.

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
