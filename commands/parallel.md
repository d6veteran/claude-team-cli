Generate a parallel session plan for the current work.

You are acting as a session planner. Analyze the current conversation context, any active plan, and the user's stated goals to identify independent work streams that can run in parallel Claude Code sessions.

---

## What to do

1. **Identify the work.** Review the conversation for tasks, plans, or goals. If nothing is clear, ask: "What are you trying to get done? I'll look for ways to split it into parallel sessions."

2. **Find independent streams.** Break the work into 2-3 streams where:
   - Each stream touches different files/directories (no overlap)
   - Each stream can be completed without waiting on the others
   - Each stream maps naturally to a team member's domain

3. **Check for dependencies.** If streams share files or one produces output the other needs, either restructure the split or note the merge order.

4. **Register sessions with conductor.** After presenting the plan, register each session using `claude-conductor add`:

```bash
claude-conductor add --persona [Name] --task "[task description]" --files "[file list]" --depends "[#N if applicable]"
```

Run one `add` command per session. This creates the SESSIONS.md entries and plan checklist automatically.

5. **Present the plan.** Output numbered session prompts in this format. Each prompt must start with an explicit instruction to run the conductor status command FIRST, before any other work. This is critical: sessions will not self-update unless the tracking command is the first action in the prompt, not a suggestion or quote block.

```
## Parallel Session Plan

### Session 1: [domain label]
**Persona:** /[name]
**Task:** [specific, scoped instruction]
**Files:** [explicit file/directory list]

**IMPORTANT: Before doing anything else, run this command:**
```bash
claude-conductor u 1 coding --activity "starting work"
```
When you finish, run: `claude-conductor d 1`

### Session 2: [domain label]
**Persona:** /[name]
**Task:** [specific, scoped instruction]
**Files:** [explicit file/directory list]

**IMPORTANT: Before doing anything else, run this command:**
```bash
claude-conductor u 2 coding --activity "starting work"
```
When you finish, run: `claude-conductor d 2`

### Session 3: [domain label] (if applicable)
**Persona:** /[name]
**Task:** [specific, scoped instruction]
**Files:** [explicit file/directory list]

**IMPORTANT: Before doing anything else, run this command:**
```bash
claude-conductor u 3 coding --activity "starting work"
```
When you finish, run: `claude-conductor d 3`

**Merge order:** [order with reasoning, or "No merge order required; all sessions are independent."]
**Coordination session:** Keep this session open for questions, reviewing work, and committing.
```

6. **Suggest opening the dashboard.** After registering sessions, tell the user:
   "Run `claude-conductor dash --open` to open the live dashboard in your browser."

## Rules

- Maximum 3 parallel sessions
- File scopes must not overlap between sessions
- Every prompt must include persona, task, file scope, and conductor tracking instructions
- If the work cannot be meaningfully parallelized, say so: "This task is too intertwined to split. Better to run it as a single session."
- Do not generate vague or open-ended prompts; each task should be specific enough that the session can complete it without asking clarifying questions
- Always register sessions with `claude-conductor add` before presenting the prompts
- If SESSIONS.md does not exist, run `claude-conductor init` first
