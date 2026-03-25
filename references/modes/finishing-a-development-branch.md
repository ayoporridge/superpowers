# Finishing a Development Branch

> Mode: `finish-branch` — Use when implementation is complete, all tests pass, and you need to integrate the work.

**Announce at start:** "I'm using the superpowers finish-branch mode to complete this work."

## Prerequisites

**Before entering this mode, verify:**
- [ ] All tests pass (use verification mode — fresh evidence required)
- [ ] All plan tasks are marked completed in tracker
- [ ] Code review has been requested and addressed (if applicable)

## Step 1: Verify Tests

Run the full test suite FRESH (not from memory):

```bash
npm test        # or cargo test, pytest, go test ./...
```

**If tests fail → STOP.** Do not proceed. Fix tests first (use debugging mode).

## Step 2: Determine Base Branch

```bash
# Find the branch this was created from
git log --oneline --graph --all | head -20

# Or check the tracking branch
git rev-parse --abbrev-ref @{upstream} 2>/dev/null
```

Common base branches: `main`, `master`, `develop`

## Step 3: Present Options

Present EXACTLY these 4 options to the user:

### Option 1: Merge locally
Merge this branch into the base branch on your machine.

### Option 2: Push and create a Pull Request
Push the branch and open a PR for team review.

### Option 3: Keep the branch
Leave everything as-is for later work.

### Option 4: Discard this work
Delete the branch and all changes. **Requires confirmation.**

## Step 4: Execute the Chosen Option

### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout main
git pull origin main

# Merge feature branch
git merge feature/${FEATURE_NAME}

# If conflicts: resolve, test, then continue
# After merge: verify tests again
npm test
```

### Option 2: Push and Create PR

```bash
# Push the branch
git push -u origin feature/${FEATURE_NAME}

# Create PR
gh pr create --title "${PR_TITLE}" --body "${PR_BODY}"
```

**OpenClaw enhancement:** After PR creation, broadcast the PR link:
- Use `sessions_send` with `announce:true` to notify via configured channel
- Include PR URL, title, and summary of changes

### Option 3: Keep Branch

No action needed. Report:
- Branch name
- Worktree location (if applicable)
- How to resume later

### Option 4: Discard

**Safety gate:** Require the user to type "discard" to confirm.

```bash
# Only after explicit confirmation
git checkout main
git branch -D feature/${FEATURE_NAME}
```

## Step 5: Cleanup Worktree

**For Options 1 and 4 only:**

```bash
# Remove the worktree
git worktree remove .worktrees/${WORKTREE_NAME}
```

**For Options 2 and 3:** Keep the worktree.

## Critical Rules

- **Never merge with failing tests**
- **Never discard without explicit "discard" confirmation**
- **Always run fresh test verification** (not from memory)
- **Present exactly 4 options** — don't add or remove
- **Report PR URL** when creating a PR

## Integration

- **Called by**: subagent-driven-development, executing-plans (after all tasks complete)
- **Pairs with**: using-git-worktrees (setup), requesting-code-review (before finish)
