---
name: superpowers
description: >-
  Structured development workflow for OpenClaw agents. Auto-activates for
  brainstorming, planning, TDD, debugging, subagent-driven development,
  code review, and verification. Provides systematic processes that turn
  vague ideas into shipped code through evidence-based, test-driven methods.
version: 1.0.0
tags:
  - workflow
  - tdd
  - debugging
  - planning
  - code-review
  - subagent
  - development
---

# Superpowers for OpenClaw

> Ported from [obra/superpowers](https://github.com/obra/superpowers) — adapted for OpenClaw's multi-agent, multi-channel architecture.

## Core Principle

**Invoke relevant modes BEFORE any response or action.** Even a 1% chance a mode might apply → load and check it. The cost of checking is always lower than the cost of skipping.

### Instruction Hierarchy

1. **User instructions** — highest priority, always override
2. **Superpowers modes** — override default agent behavior
3. **System prompt** — lowest priority

### Red Flags (you are about to skip a mode check)

If you catch yourself thinking any of these, STOP and check modes:
- "This is just a simple question"
- "Let me explore first"
- "I already know how to do this"
- "This doesn't need a plan"

---

## Mode Index

| Mode | Trigger | Reference |
|------|---------|-----------|
| **brainstorming** | Any new feature, design, or creative work | `references/modes/brainstorming.md` |
| **writing-plans** | Spec approved, ready to plan implementation | `references/modes/writing-plans.md` |
| **executing-plans** | Have a plan, executing without coding-agent | `references/modes/executing-plans.md` |
| **subagent-dev** | Have a plan + coding-agent available | `references/modes/subagent-driven-development.md` |
| **parallel-dispatch** | 3+ independent tasks across different domains | `references/modes/dispatching-parallel-agents.md` |
| **tdd** | Any code implementation (always) | `references/modes/test-driven-development.md` |
| **debugging** | Bug, test failure, unexpected behavior | `references/modes/systematic-debugging.md` |
| **verification** | About to claim something is "done" | `references/modes/verification-before-completion.md` |
| **git-worktrees** | Need isolated development workspace | `references/modes/using-git-worktrees.md` |
| **finish-branch** | Implementation complete, ready to integrate | `references/modes/finishing-a-development-branch.md` |
| **receive-review** | Received code review feedback | `references/modes/receiving-code-review.md` |
| **request-review** | Work complete, need code review | `references/modes/requesting-code-review.md` |
| **writing-skills** | Creating or editing an OpenClaw skill | `references/modes/writing-skills.md` |

---

## Standard Workflow

The typical full workflow follows this sequence:

```
brainstorming → writing-plans → [subagent-dev | executing-plans] → request-review → finish-branch
     ↑               ↑                    ↑                              ↑
  Spec review    Plan review     Per-task: implement → spec review    Code review
  (subagent)     (subagent)      → quality review → commit            (subagent)
```

Throughout the entire workflow, these modes are always active:
- **tdd** — write tests first, always
- **verification** — prove it works before claiming done
- **debugging** — when anything goes wrong

---

## OpenClaw Enhancements

The following capabilities go beyond the original Superpowers, leveraging OpenClaw's architecture:

### Multi-Agent Team Mode

OpenClaw supports true multi-agent orchestration. Configure your team:

```
coordinator agent  ← runs superpowers, dispatches tasks
    ├── implementer agent(s)  ← via coding-agent background:true
    ├── reviewer agent        ← receives review requests via sessions_send
    └── user                  ← receives progress updates via channel
```

**Solo mode** (default): Single agent handles everything, compatible with original Superpowers behavior.
**Team mode**: Coordinator dispatches to specialized agents via `sessions_send` and `coding-agent`.

### Progress Broadcasting

When configured, push notifications to your preferred channel:
- ✅ Task completed — brief status update
- 🚫 Task blocked — needs human intervention
- 📝 Spec/Plan ready for review
- 🔀 PR created — with link
- 🏁 Entire plan completed — summary report

Use `sessions_send` with `announce:true` to broadcast, or configure channel-specific delivery.

### Cron Integration

For long-running plans, set up periodic progress checks:

```bash
# Check plan progress every 30 minutes
openclaw cron add --name "superpowers-check" --every "30m" \
  --session main --system-event "Check superpowers tracker progress, resume any blocked tasks"

# Daily summary of all active plans
openclaw cron add --name "superpowers-daily" --cron "0 9 * * *" \
  --session main --system-event "Summarize superpowers plan status across all active projects"
```

### Persistent State

Unlike terminal-only tools, OpenClaw persists state across sessions:
- **Tracker file** (`docs/superpowers/tracker.md`) — survives session restarts
- **Spec and plan docs** — always available in workspace
- **Gateway session store** — remembers where you left off

---

## Task Tracking (replaces TodoWrite)

Since OpenClaw does not have a TodoWrite tool, Superpowers uses a file-based tracker:

**Location**: `docs/superpowers/tracker.md` in the project workspace

**Status markers**:
- `- [ ]` — pending
- `- [~]` — in progress
- `- [x]` — completed
- `- [!]` — blocked (needs human input)

**Template**: See `assets/tracker-template.md`

When executing a plan, always:
1. Create tracker from template at plan start
2. Update status markers as tasks progress
3. Write brief notes after each task completion
4. Record verification evidence inline

---

## Subagent Dispatch (replaces Agent tool)

OpenClaw uses two mechanisms for subagent work:

### 1. `coding-agent` — for implementation tasks

```
coding-agent background:true workdir:/path/to/worktree model:claude-sonnet-4-20250514
```

Use for: implementing plan tasks, running tests, file modifications.
Each coding-agent runs in an isolated process with its own context.

### 2. `sessions_send` — for review and coordination

```
sessions_send to:reviewer-session message:"Review this diff against spec..."
```

Use for: spec review, code quality review, plan review, coordination.
Reviewer agents can read context via `sessions_history`.

### Choosing Between Them

| Task Type | Mechanism | Why |
|-----------|-----------|-----|
| Write code / run tests | `coding-agent` | Needs file system access, isolated context |
| Review code / spec | `sessions_send` | Needs to read and respond, no file changes |
| Coordinate agents | `sessions_send` | Message passing between agents |
| Long-running implementation | `coding-agent background:true` | Non-blocking, parallel capable |

---

## Document Storage

All Superpowers artifacts are stored under `docs/superpowers/` in the project workspace:

```
docs/superpowers/
├── specs/          # Design specifications from brainstorming
│   └── YYYY-MM-DD-<topic>-design.md
├── plans/          # Implementation plans from writing-plans
│   └── YYYY-MM-DD-<feature>-plan.md
└── tracker.md      # Current execution progress
```

---

## Quick Reference: Mode Selection

**Starting something new?** → brainstorming
**Have a spec, need a plan?** → writing-plans
**Have a plan, ready to build?** → subagent-dev (preferred) or executing-plans
**Multiple independent problems?** → parallel-dispatch
**Writing any code?** → tdd (always active)
**Something broken?** → debugging
**About to say "done"?** → verification
**Need isolated workspace?** → git-worktrees
**Code complete?** → request-review → finish-branch
**Got review feedback?** → receive-review
**Making a new skill?** → writing-skills
