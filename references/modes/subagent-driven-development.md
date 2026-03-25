# Subagent-Driven Development

> Mode: `subagent-dev` — Use when you have a plan and coding-agent is available.

**Announce at start:** "I'm using the superpowers subagent-driven-development mode with coding-agent."

## Core Concept

**Fresh coding-agent per task + two-stage review (spec then quality) = high quality, fast iteration.**

Each coding-agent receives isolated context tailored to their specific task, preventing context pollution while the coordinator (you) maintains the big picture.

## Prerequisites

- [ ] A written plan exists (from writing-plans mode)
- [ ] Plan has been reviewed and approved
- [ ] Git worktree is set up (use git-worktrees mode)
- [ ] Tracker file created at `docs/superpowers/tracker.md`
- [ ] `coding-agent` skill is available

## Execution Modes

### Safe Mode (Default)

Tasks are executed **serially** — one coding-agent at a time. Each task goes through the full implement → review → fix cycle before the next starts.

Use when: tasks share files, have dependencies, or you want maximum safety.

### Parallel Mode (OpenClaw Only)

Independent tasks are dispatched to **multiple coding-agents simultaneously**, each in its own worktree.

Use when: 3+ tasks are truly independent (different files, different directories, no shared state).

**Requirements for parallel mode:**
- Each task works in a separate git worktree
- No two tasks modify the same file
- Run conflict check after all complete: `scripts/check-conflicts.sh`

## Per-Task Workflow

For each task in the plan:

### 1. Implementation

Update tracker: 🔄 in progress

Dispatch coding-agent with the implementer prompt:

```
coding-agent background:true workdir:{WORKTREE_PATH} prompt:"
[Paste implementer prompt from references/prompts/implementer-prompt.md
 with TASK_DESCRIPTION, PLAN_SECTION, and SPEC_SECTION filled in]
"
```

**Model selection by complexity:**
- Mechanical (1-2 files, clear spec) → fast model (e.g., `model:claude-sonnet-4-20250514`)
- Integration (multi-file) → standard model
- Architecture/complex → capable model (e.g., `model:claude-opus-4-6`)

Wait for coding-agent to report. Check status:
- **DONE** → proceed to spec review
- **DONE_WITH_CONCERNS** → evaluate concerns, proceed to spec review
- **BLOCKED** → investigate, unblock or escalate
- **NEEDS_CONTEXT** → provide context, re-dispatch

### 2. Spec Compliance Review

Dispatch spec reviewer:

```
coding-agent background:false prompt:"
[Paste spec reviewer prompt from references/prompts/spec-reviewer-prompt.md
 with IMPLEMENTER_REPORT, TASK_REQUIREMENTS, and FILE_LIST filled in]
"
```

Or via sessions_send to a reviewer agent:
```
sessions_send to:reviewer message:"Spec compliance review for Task N: [details]"
```

**If issues found:**
1. Send issues back to implementer (re-dispatch coding-agent with fix instructions)
2. Re-review after fixes
3. Max 3 iterations

**Do NOT proceed to quality review until spec compliance passes.**

### 3. Code Quality Review

Only after spec compliance passes:

```
coding-agent background:false prompt:"
[Paste code quality reviewer prompt from references/prompts/code-quality-reviewer-prompt.md
 with IMPLEMENTER_REPORT, TASK_DESCRIPTION, BASE_SHA, and HEAD_SHA filled in]
"
```

**If Critical or Important issues found:**
1. Send back to implementer for fixes
2. Re-review (only quality review — spec compliance already passed)
3. Max 3 iterations

### 4. Task Completion

When both reviews pass:
1. Update tracker: ✅ completed
2. Record verification evidence in tracker
3. Move to next task

### 5. Repeat

Continue until all tasks are done.

## After All Tasks Complete

1. **Final code review** — dispatch a full code review:
   ```
   coding-agent background:false prompt:"
   [Paste code reviewer prompt from references/prompts/code-reviewer-prompt.md
    with full feature context]
   "
   ```

2. **Finish branch** — transition to finish-branch mode:
   > "All tasks complete and reviewed. I'm using the superpowers finish-branch mode."

**OpenClaw enhancement:** Broadcast completion:
```
sessions_send announce:true message:"[superpowers] 🏁 All tasks done for {feature}: {N} tasks, all reviews passed."
```

## Parallel Mode Details (OpenClaw)

When using parallel mode:

### Setup
```bash
# Create separate worktrees for each parallel task
git worktree add .worktrees/task-3 -b feature/task-3
git worktree add .worktrees/task-4 -b feature/task-4
git worktree add .worktrees/task-5 -b feature/task-5
```

### Dispatch
```
# Launch all in parallel
coding-agent background:true workdir:.worktrees/task-3 prompt:"[implementer prompt for task 3]"
coding-agent background:true workdir:.worktrees/task-4 prompt:"[implementer prompt for task 4]"
coding-agent background:true workdir:.worktrees/task-5 prompt:"[implementer prompt for task 5]"
```

### Monitor
Use `sessions_history` or `process action:log` to check progress of each agent.

### Integrate
After all complete:
1. Run conflict check: `bash scripts/check-conflicts.sh`
2. Merge each task branch into the feature branch
3. Run full test suite on merged result
4. Proceed with reviews on the integrated code

## Critical Rules

- **Never start on main/master** without explicit consent
- **Never skip either review stage** (spec then quality, in that order)
- **Never make subagents read the plan file directly** — paste the relevant section
- **Never proceed with unresolved review issues**
- **Spec compliance MUST pass before code quality review**
- **Update tracker after every status change**
- **In safe mode: one task at a time, no parallel implementation**
