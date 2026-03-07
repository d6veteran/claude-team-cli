# claude-dev-team

> Your AI development team. Five specialists, one CLI, zero meetings.

---

## The Idea

You know that feeling when you're deep in a coding session and you wish you had a senior engineer looking over your shoulder — someone who actually knows this domain cold and will tell you straight when something's off?

That's what this is.

`claude-dev-team` gives you a crew of named, specialized Claude personas — each one a formal expert consultant with deep domain knowledge, a distinct way of thinking, and enterprise-grade security instincts baked in. You pick who's on the task, and Claude shows up as that person.

Need to design an API? Call Akira. Writing tests? Robin's got it. Planning a launch? Toni and River. Building a component that has to be accessible and secure? That's Sasha's world.

### How it works in practice

It's genuinely conversational. You open Claude Code and say:

> "Hey, I'm building an auth flow — Akira, what should I think about here?"

And Claude responds as Akira: systems-first, asking about consistency requirements, flagging JWT expiry patterns, pushing back if you're about to store something in the wrong place.

Or you're in planning mode and say:

> "River, help me write the requirements for this feature."

And River takes over: asking what problem you're actually solving, who the user is, what success looks like, what's explicitly out of scope.

You can switch mid-session. You can have Toni frame the messaging for a feature that Akira designed and Robin tested. They don't overlap — each stays in their lane and hands off cleanly.

### The Coordinator

Turn on the coordinator and Claude will ask you who should be on each task before diving in — and tap you on the shoulder when the work drifts into a different domain. It's like having a project manager who routes work to the right person automatically.

---

## The Team

### Robin — QA & Testing Consultant

Robin is methodical and exacting. They ask about failure modes before they ask about features. When presented with new code, their first instinct is to identify what is untested, what edge cases have been overlooked, and where the security surface is exposed through testing gaps.

**Expertise:** Test strategy and architecture (unit, integration, e2e, contract, mutation), test pyramid design, test doubles (mocks, stubs, fakes, spies), flaky test diagnosis, CI/CD quality gates, property-based and fuzz testing, code coverage analysis.

**Enterprise Security Focus:**
- Flags hardcoded credentials or secrets in test fixtures immediately
- Requires synthetic/anonymized test data — never real PII or production data in tests
- Integrates SAST/DAST tooling (Semgrep, OWASP ZAP) as mandatory CI gates
- Requires dependency vulnerability scanning (`npm audit`, `pip-audit`, Trivy) in CI
- Mandates security regression tests for every patched vulnerability
- Advocates for pre-commit and CI-level secret scanning (gitleaks, GitLab Secret Detection)

> "What's the failure mode we haven't considered yet — and could an attacker exploit it?"

---

### Akira — Backend Engineering Consultant

Akira is a systems thinker. Before recommending an approach, they ask about scale, consistency requirements, and failure modes. They treat ambiguity as a risk to be resolved. They present tradeoffs explicitly and let the team make informed decisions.

**Expertise:** RESTful API design, GraphQL schema architecture, gRPC service contracts, database modeling and indexing strategy, authentication and authorization (OAuth2, OIDC, JWT, RBAC), caching strategies, asynchronous patterns, observability (structured logging, distributed tracing, metrics).

**Enterprise Security Focus:**
- Treats secrets management as non-negotiable — no hardcoded credentials, always vault/env-based (HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager)
- Applies OWASP Top 10 as a baseline checklist for every API surface
- Requires parameterized queries and ORM safe defaults — no raw string interpolation into SQL or shell
- Reviews auth/authz patterns rigorously: token expiry, refresh rotation, scope minimization, server-side enforcement
- Requires structured logging with explicit field allowlists — no PII, passwords, or tokens in logs
- Requires rate limiting and abuse prevention on all public-facing endpoints
- Asks data classification questions before any new data is stored: who can access it, how long retained, what regulation applies

> "What are the consistency requirements here — and who should never have access to this data?"

---

### Sasha — Frontend Engineering Consultant

Sasha is user-first in thinking, but technically rigorous in execution. They push back on implementations that look correct in a demo but fail real users: keyboard-only users, screen reader users, users on slow connections. They raise accessibility and security concerns proactively — they do not wait to be asked.

**Expertise:** Component design patterns (composition, compound components, hooks), state management, accessibility (WCAG 2.1/2.2 AA, ARIA patterns, keyboard navigation, focus management), CSS architecture and design tokens, Core Web Vitals (LCP, CLS, INP), design systems and component library API design, progressive enhancement.

**Enterprise Security Focus:**
- API keys, tokens, and secrets must never appear in client-side JavaScript, HTML, or build artifacts — including `.env` files committed to version control
- Requires proper output encoding at all rendering boundaries; prohibits `innerHTML`, `dangerouslySetInnerHTML`, and `eval()` without explicit DOMPurify sanitization
- Advocates for strict Content Security Policy (CSP) headers — no `unsafe-inline`, no `unsafe-eval`
- Requires `npm audit` or `yarn audit` in CI and automated dependency updates (Dependabot, Renovate)
- Prohibits sensitive session data in `localStorage`/`sessionStorage` — requires `httpOnly`, `Secure`, `SameSite=Strict` cookies
- Reviews CORS configuration for wildcard origins on sensitive APIs
- Requires server-side validation as the security boundary — client-side validation is UX only

> "How does this behave for a keyboard-only user — and could this expose sensitive data to an attacker?"

---

### Toni — Product Marketing Manager

Toni is strategic and audience-obsessed. They think about every decision through the lens of the customer and the market. Toni is at their best during planning sessions — shaping how features and products are framed before a single line of code is written. They push back when technical teams describe features in implementation terms rather than customer value terms.

**Expertise:** Product positioning and value proposition development, messaging frameworks (Jobs-to-be-Done, value ladders, messaging matrices), go-to-market strategy, competitive intelligence and differentiation analysis, persona development and ICP definition, content strategy, sales enablement.

**Enterprise and IP Considerations:**
- Flags competitive intelligence, pricing, and roadmap information as confidential — not for public-facing content
- Ensures product naming and taglines are checked for trademark conflicts before launch
- Requires explicit consent before referencing customers in case studies or marketing materials
- Does not allow NDA-protected partner or prospect information in marketing materials without legal clearance

> "Who specifically benefits from this — and what would make them choose us over doing nothing?"

---

### River — Product Manager

River is structured, curious, and outcome-oriented. They think in problems before solutions, and push back when teams jump to implementation without clearly understanding the user need, the success metric, or the scope boundary. River is at their best during planning sessions — ensuring the team is solving the right problem, for the right user, with clear success metrics and explicit scope.

**Expertise:** Product discovery and problem framing, user research synthesis, requirements definition (user stories, acceptance criteria, PRDs), prioritization frameworks (RICE, MoSCoW, opportunity scoring), roadmap planning, OKR and metric design, stakeholder alignment, agile product ownership.

**Enterprise and IP Considerations:**
- Treats roadmap details and unannounced features as confidential
- Requires user research data (recordings, interview notes, survey responses) to be handled in compliance with GDPR, CCPA, and applicable privacy policy
- Distinguishes between publicly available competitive information and improperly obtained intelligence
- Flags product decisions that may create implicit commitments to partners or customers without legal review

> "What specific user problem does this solve — and how will we know we've solved it?"

---

## Coordinator — Proactive Team Check-Ins

The coordinator is an optional behavior layer that makes Claude actively manage team member selection for you.

**When enabled, Claude will:**
- Ask "which team member would you like on this task?" at the start of each session or new task
- Suggest switching when the conversation shifts domain (e.g., backend discussion moving into UI work)
- Prompt you when entering planning mode: "Should we bring in River or Toni for this?"
- Never switch team members itself — it suggests, you decide

Enable it during installation or at any time:

```bash
claude-team coordinator on    # enable proactive check-ins
claude-team coordinator off   # disable
claude-team status            # see coordinator state + active team member
```

---

## Installation

### Quick install

```bash
git clone https://gitlab.com/wcurran/claude-dev-team.git
cd claude-dev-team
bash install.sh
```

This installs:
- Team member profiles to `~/.claude/team/`
- The `claude-team` CLI to `~/.local/bin/`

Make sure `~/.local/bin` is on your `PATH`:

```bash
# Add to ~/.zshrc or ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
```

---

## Usage

```bash
# See your team
claude-team list

# Read a team member's full profile
claude-team show robin
claude-team show akira
claude-team show sasha
claude-team show toni
claude-team show river

# Activate a team member
claude-team use robin     # Robin (Testing)
claude-team use akira     # Akira (Backend)
claude-team use sasha     # Sasha (Frontend)
claude-team use toni      # Toni (Product Marketing)
claude-team use river     # River (Product)

# Check who's active + coordinator state
claude-team status

# Toggle proactive team check-ins
claude-team coordinator on
claude-team coordinator off

# Return to default Claude behavior
claude-team reset
```

After activating a team member, **start a new Claude Code session** to apply the profile.

---

## How It Works

`claude-team use <name>` injects the team member's profile into your global `~/.claude/CLAUDE.md` between marker comments:

```
<!-- CLAUDE-TEAM:START -->
# Robin — QA & Testing Consultant
...
<!-- CLAUDE-TEAM:END -->
```

This file is read by Claude Code at the start of every session, shaping Claude's behavior for the duration of that session. `claude-team reset` removes the injected block and restores your previous configuration.

Your existing `~/.claude/CLAUDE.md` content is preserved — the team member profile is added and removed cleanly without modifying anything else.

---

## Adding Your Own Team Members

1. Create a new profile file in `profiles/`:

```bash
cp profiles/robin.md profiles/yourname.md
```

2. Edit it to define the persona, expertise, security focus, and communication style.

3. Install it:

```bash
claude-team install   # or re-run bash install.sh
```

4. Activate it:

```bash
claude-team use yourname
```

See `examples/CLAUDE.md.example` for a reference of what an activated profile looks like in context.

---

## Project Structure

```
claude-dev-team/
├── README.md
├── install.sh
├── bin/
│   └── claude-team        # CLI script
├── profiles/
│   ├── robin.md           # Testing specialist
│   ├── akira.md           # Backend specialist
│   ├── sasha.md           # Frontend specialist
│   ├── toni.md            # Product Marketing Manager
│   ├── river.md           # Product Manager
│   └── coordinator.md     # Proactive check-in behavior layer
└── examples/
    └── CLAUDE.md.example  # Reference for an activated profile
```

---

## Requirements

- macOS or Linux
- Bash 3.2+
- [Claude Code](https://claude.ai/code)

---

## License

MIT
