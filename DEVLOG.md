# claude-team-cli — Development Log

A living record of architectural decisions, milestones, key insights, and strategic direction.
Auto-maintained via Claude devlog skill. Entries are reverse-chronological.

---

## [2026-03-27] Added no-emdash writing rule and parallel session support

**Category:** `feature`
**Tags:** `coordinator`, `parallel-sessions`, `writing-style`, `toni`, `content-rules`
**Risk Level:** `low`
**Breaking Change:** `no`

### Summary
Added a global "no emdashes" writing style rule to the coordinator and a new `/parallel` slash command for generating parallel session plans. Also rewrote the lint blog post to eliminate emdashes.

### Detail
- Added "Writing Style" section to `profiles/coordinator.md` with global no-emdash rule: restructure sentences instead of character-swapping
- Added same rule to `profiles/toni.md` and `commands/toni.md` under "How You Communicate"
- Added "Parallel Sessions" section to `profiles/coordinator.md` with proactive detection of parallelizable work streams
- Created `commands/parallel.md` slash command that generates copy-paste session prompts with persona, task, and file scope
- Rewrote `publish/posts/post-12-lint.md` using commas, colons, semicolons, and parentheses instead of emdashes; recreated the gist
- Updated no-emdash rule in `claude-publish-agent/SKILL.md` and `~/.claude/skills/plans/SKILL.md`

### Decisions Made
- **No-emdash rule placement:** Put in the coordinator (not individual personas) so all team members inherit it globally. Toni has a duplicate because content writing is core to that persona's role.
- **Rule wording:** "Restructure the sentence" not "swap the character." Early attempts at find-and-replace produced broken grammar. The rule must instruct Claude to rewrite, not substitute.
- **Parallel session cap:** Maximum 3 sessions. Coordination overhead outweighs speed gains beyond that. Validated in prior session (2026-03-26) with 3 parallel streams completing independently with no merge conflicts.
- **File scope as hard boundary:** Each parallel session prompt must include explicit file/directory scope with no overlap between sessions, which is the key to avoiding merge conflicts.

## [2026-03-26] Added no-emdash content generation rule to Toni persona

**Category:** `feature`
**Tags:** `toni`, `content-style`, `emdash`, `writing-rules`
**Risk Level:** `low`
**Breaking Change:** `no`

### Summary
Added an explicit "no emdashes" rule to the Toni persona so generated content uses hyphens, commas, colons, or semicolons instead of emdashes. Same rule added to the publish and plans skills.

### Detail
- Rule added to `How You Communicate` section in both `profiles/toni.md` and `commands/toni.md`
- Rule added to `Medium Formatting Conventions` in publish skill (`claude-publish-agent/SKILL.md` and installed `~/.claude/skills/publish/SKILL.md`)
- Rule added to `Style Guidelines` in plans skill (`~/.claude/skills/plans/SKILL.md`)
- Reinstalled claude-team-cli via `install.sh`

### Decisions Made
Rule applies to content generation only, not to the persona definition files themselves. The instruction tells Claude not to produce emdashes in output, rather than retroactively removing them from skill documentation.

## [2026-03-26] Added lint requirement to all engineer personas and coordinator

**Category:** `feature`
**Tags:** `lint`, `static-analysis`, `engineer-personas`, `coordinator`, `code-quality`
**Risk Level:** `low`
**Breaking Change:** `no`

### Summary
All six engineer personas (Akira, Robin, Sasha, Alex, Morgan, Jordan) and the coordinator now proactively check for linter configuration when encountering a new codebase, and flag it if missing with stack-specific recommendations.

### Detail
- Added a new bullet to `## Enterprise Security Focus` in each engineer persona, framed through their domain lens:
  - **Akira**: security anti-patterns + code quality (bandit/S rules)
  - **Robin**: pre-test quality gate (lint catches bugs before tests run)
  - **Sasha**: code consistency + accessibility lint plugins (eslint-plugin-jsx-a11y)
  - **Alex**: CI/CD pipeline quality gate (lint as blocking step before tests)
  - **Morgan**: security baseline (cheapest static analysis for injection, secrets, unsafe calls)
  - **Jordan**: pipeline reliability + SQLFluff for SQL-heavy projects
- Added `### When starting work on a new project or codebase` subsection to coordinator's Check-In Behavior with full detection signal checklist
- Detection covers: Python (Ruff), JS/TS (ESLint/Biome), Swift (SwiftLint), Go (golangci-lint), Rust (clippy), SQL (SQLFluff), and `.pre-commit-config.yaml`
- Updated both `profiles/` and `commands/` directories (13 files total), reinstalled via `install.sh`

### Decisions Made
- **Bullet in Enterprise Security Focus, not a 4th Required Interactive Behavior** — Lint is a code quality/security concern, not a conversational behavior pattern. Adding it to Enterprise Security Focus preserves the consistent "3 behaviors + handoff" structure across all personas.
- **Domain-specific framing per persona** — Each bullet uses the persona's lens (security, testing, CI/CD, etc.) rather than generic copy-paste, making the recommendation feel natural to each persona's voice.
- **Coordinator gets a checklist, not a bullet** — The coordinator subsection uses a bulleted checklist of detection signals by stack, since it serves as a reference guide rather than a persona behavior.

### Related
- Plan file: `~/.claude/plans/shimmering-swimming-treehouse.md`

---

## [2026-03-21] Added plans and todo companion skills to README, updated posts path to publish/posts/

**Category:** `feature`
**Tags:** `companion-skills`, `plans`, `todo`, `content-kit`, `readme`
**Risk Level:** `low`
**Breaking Change:** `no`

### Summary
Updated README to document two new companion skills (claude-plans-skill and claude-todo-skill) alongside devlog and roadmap. Updated `.gitignore` to reflect the `posts/` → `publish/posts/` directory move matching the publish-agent convention.

### Detail
- Companion Skills table expanded from 2 to 4 entries: added claude-plans-skill (`/plans`) and claude-todo-skill (`/todo`)
- Install block updated from "Install both" to "Install all four" with curl commands for all four skills
- Usage section updated with `/plans` and `/todo` slash command examples
- `.gitignore` updated: `posts/` → `publish/posts/` to match the publish-agent content kit convention
- Remote origin updated from legacy gitlab-master.nvidia.com to github.com/code-katz/claude-team-cli

### Decisions Made
- **Four companion skills in one table** — Plans and todo are natural additions to the devlog/roadmap pair. All four serve the same purpose: persistent project context that survives session boundaries.
- **publish/posts/ convention adopted** — Aligns with the publish-agent's decision to keep posts inside the content kit directory rather than at project root.

### Related
- claude-plans-skill: https://github.com/code-katz/claude-plans-skill
- claude-todo-skill: https://github.com/code-katz/claude-todo-skill
- publish-agent posts path change: [2026-03-21] entry in claude-publish-agent DEVLOG.md

---

## [2026-03-17] Codekatz brand identity established — 10 cat persona badges, logo, and visual identity system

**Category:** `strategy`
**Tags:** `codekatz`, `branding`, `visual-identity`, `badges`, `personas`, `gtm`
**Risk Level:** `low`
**Breaking Change:** `no`

### Summary
Created the "Code Katz" brand identity for the claude-team-cli blog series and broader tool suite. Each of the 10 personas now has a unique cartoon cat character rendered as an employee badge. The codekatz.com domain was acquired, and a complete visual identity system was designed — from favicon to GitHub org avatar to Medium hero images.

### Detail
- All 10 persona cat badges created via Gemini and saved to `assets/badges/` — each cat has a distinct personality expressed through line art style (ear shape, eye expression, markings, props)
- Badge format: "Code Katz Staff ID" employee badges with cat illustration, persona name, role title, employee ID, hire date, and paw logo mark
- Art style: rust-orange (#d97757) line art on cream background, consistent across all 10 badges
- Morgan's cat has a monocle and lock shield; Sasha's has a JS badge; each cat is visually distinct at thumbnail scale
- Image prompts document (`posts/image-prompts.md`) fully rewritten for the cat approach — Phase 1 (base character design), Phase 2 (blog hero images per persona), Phase 3 (brand extensions)
- Brand extension roadmap defined: GitHub org avatar (paw icon), README headers per repo, codekatz.com landing page, animated GIFs, sticker pack, "which cat are you?" quiz
- Post file naming convention established and applied: `post-{NN}-{slug}.md` (1-2 word slugs)

### Decisions Made
- **Different cats per persona over one cat in different poses** — Originally planned a single cat mascot. Pivoted to 10 unique cats after seeing the reference style (Sudowoodo minimal cat faces). Different cats create instant visual recognition per post, "collect them all" engagement, and match the product better — these are specialists with distinct personalities, not modes of one tool.
- **Cats over human figures** — Human illustrations created gender/diversity representation challenges. Cats eliminate the issue entirely while adding approachability and fun to a developer tools brand.
- **codekatz.com as the umbrella brand** — The domain unifies the tool suite (team-cli, devlog, roadmap, publish-agent) under one memorable brand. Individual GitHub repos remain under `code-katz` org.
- **Employee badge format** — Badges are more visually interesting and shareable than plain character portraits. They add worldbuilding detail (employee IDs, hire dates) that makes the personas feel like a real team.
- **Paw icon as logo mark** — Extracted from the badge artwork. Simple enough for favicon (32px), distinctive enough for GitHub org avatar. Rust orange on charcoal as primary lockup.

### Related
- Badge assets: `assets/badges/*.png` (10 files)
- Image prompts: `posts/image-prompts.md`
- Style guide: `publish/style-guide.md`
- Domain: codekatz.com
- GitHub org: github.com/code-katz

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
