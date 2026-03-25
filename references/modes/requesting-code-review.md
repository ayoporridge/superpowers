# Requesting Code Review

> Mode: `request-review` — Use when work is complete and needs review before integration.

**Announce at start:** "I'm using the superpowers request-review mode to get this code reviewed."

## When to Request Review

**Mandatory:**
- After each task in subagent-driven-development (per-task review)
- After completing a major feature
- Before merging to main/master

**Recommended:**
- When stuck on an approach
- Before major refactoring
- After complex bug fixes

## The Process

### Step 1: Gather Context

```bash
# Get the commit range
BASE_SHA=$(git merge-base HEAD main)  # or the base branch
HEAD_SHA=$(git rev-parse HEAD)

# Review the diff
git diff ${BASE_SHA}..${HEAD_SHA} --stat
```

### Step 2: Dispatch Reviewer

**Via coding-agent:**
```
coding-agent background:false prompt:"
[Paste code reviewer prompt from references/prompts/code-reviewer-prompt.md with:
  DESCRIPTION: {what was implemented}
  PLAN_OR_REQUIREMENTS: {relevant plan/spec section}
  BASE_SHA: {base commit}
  HEAD_SHA: {current commit}
]"
```

**Via sessions_send (if reviewer agent available):**
```
sessions_send to:reviewer message:"
Code review request:
- Feature: {name}
- Branch: {branch name}
- Commits: {BASE_SHA}..{HEAD_SHA}
- Plan: {plan file path}
[Paste code reviewer prompt with details]"
```

### Step 3: Act on Feedback

| Severity | Action |
|----------|--------|
| **Critical** | Fix immediately. Re-review. |
| **Important** | Fix before proceeding to next task. |
| **Suggestion** | Address at your discretion. |

**No changes proceed with unresolved Critical or Important issues.**

### In Subagent-Driven Workflows

Review after each task to catch issues early:
- Task complete → spec review → quality review → move on
- This prevents issue accumulation

### In Plan Execution

Review in batches:
- Every 3 tasks, request a review covering all 3
- Or at natural checkpoint boundaries in the plan

## Red Flags (Don't Skip Review)

- "This change is too simple for review" — simple changes can have non-obvious impacts
- "I'm confident in this code" — confidence ≠ verification
- "It's just a refactor" — refactors can change behavior
- "Tests all pass" — tests don't catch everything

## OpenClaw Enhancement

After receiving review approval, broadcast to your channel:
```
sessions_send announce:true message:"[superpowers] ✅ Code review passed for {feature}. Ready to finish branch."
```

## Integration

- **Follows**: executing-plans or subagent-driven-development
- **Precedes**: finishing-a-development-branch
- **Uses**: code-reviewer-prompt from `references/prompts/code-reviewer-prompt.md`
