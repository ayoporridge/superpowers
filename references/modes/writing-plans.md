# Writing Plans

> Mode: `writing-plans` — Use when you have an approved spec and need to plan the implementation.

**Announce at start:** "I'm using the superpowers writing-plans mode to create an implementation plan."

## Core Principles

- **Assume limited codebase knowledge** — plans should be followable by a skilled engineer who's never seen this codebase
- **Bite-sized tasks** — each step takes 2-5 minutes, represents one atomic action
- **Test-driven** — every task follows TDD: write test → watch fail → implement → watch pass
- **Frequent commits** — break work into committable chunks
- **Exact paths** — every file path must be complete and accurate

## The Process

### Step 1: Map File Structure

Before writing any tasks:

1. Survey existing codebase structure
2. Identify files to create and modify
3. Ensure clear responsibilities (one responsibility per file)
4. Files that change together should live together
5. Follow established codebase patterns

### Step 2: Write Plan

Use the template from `assets/plan-template.md`.

**Required sections:**
- **Goal** — one sentence
- **Architecture** — 2-3 sentences explaining the approach
- **Tech stack** — key technologies
- **Files** — exact paths for all new and modified files
- **Tasks** — ordered, bite-sized, with code examples and test commands
- **Execution method** — which mode to use
- **Verification** — how to confirm everything works

**Each task must include:**
```markdown
### Task N: {Title}

**Files**: `exact/path/to/file.ts`
**Test**: `exact/path/to/file.test.ts`

Steps:
1. Write failing test:
   ```typescript
   // Complete test code — not pseudocode
   ```
2. Implement minimal code to pass
3. Verify: `exact test command with expected output`
4. Commit: `git commit -m "feat: description"`
```

**Task header for agentic execution:**
Every plan must include this header after the tech stack section:

```markdown
> **For agentic execution:** If using coding-agent or subagent-driven-development,
> load `references/modes/subagent-driven-development.md` and follow that workflow.
> For inline execution, load `references/modes/executing-plans.md`.
```

### Step 3: Plan Review Loop

Dispatch a plan review (single reviewer, max 3 iterations):

**Using coding-agent:**
```
coding-agent background:false prompt:"[plan-document-reviewer prompt from references/prompts/plan-document-reviewer-prompt.md]"
```

**Using sessions_send (if reviewer agent available):**
```
sessions_send to:reviewer message:"Review this plan: docs/superpowers/plans/YYYY-MM-DD-<feature>-plan.md against spec: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md"
```

**Provide only these files to the reviewer:**
- The plan document
- The spec document
- Do NOT include full session history (keeps reviewer focused)

**Review loop:**
1. Send plan for review
2. If issues found → fix and re-submit
3. If approved → proceed to Step 4

### Step 4: Execution Handoff

Present execution options to the user:

#### Option 1: Subagent-Driven Development (Recommended)
Fresh subagent per task with two-stage review (spec + quality).
Best for: quality-critical work, multi-file changes.
→ Load `references/modes/subagent-driven-development.md`

#### Option 2: Inline Execution
Execute tasks sequentially in current session with checkpoints.
Best for: simple plans, single-file changes.
→ Load `references/modes/executing-plans.md`

#### Option 3: Multi-Agent Parallel (OpenClaw Only)
Dispatch independent tasks to separate coding-agents in parallel.
Best for: plans with 3+ independent tasks across different files.
→ Load `references/modes/dispatching-parallel-agents.md`

**OpenClaw enhancement:** After plan approval, broadcast a summary to the user's channel:
> "[superpowers] 📝 Plan approved: {feature name} — {N} tasks, estimated {time}. Ready to execute."

### Step 5: Create Tracker

Before starting execution, create the tracker file:
```
docs/superpowers/tracker.md
```

Use the template from `assets/tracker-template.md`. Fill in all task titles from the plan.

## Write Plan to File

Save the plan to:
```
docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md
```

## Anti-Patterns

- ❌ Tasks longer than 5 minutes
- ❌ Vague steps ("implement the feature")
- ❌ Missing test commands or expected output
- ❌ Pseudocode instead of real code examples
- ❌ Missing file paths
- ❌ Skipping the review loop
- ❌ Starting execution without a tracker
