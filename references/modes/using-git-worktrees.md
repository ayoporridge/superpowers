# Using Git Worktrees

> Mode: `git-worktrees` — Use when you need an isolated development workspace.

**Announce at start:** "I'm using the superpowers git-worktrees mode to set up an isolated workspace."

## Core Principle

**Systematic directory selection + safety verification = reliable isolation.**

Never work directly on main/master for feature development. Always use a worktree.

## Step 1: Choose Worktree Directory

Follow this priority order:

### Priority 1: Check for existing directories
```bash
# Look for project-local worktree directories
ls -d .worktrees/ worktrees/ 2>/dev/null
```

### Priority 2: Check AGENTS.md / project config
Look for worktree directory preferences in `AGENTS.md` or project configuration files.

### Priority 3: Ask the user
If neither exists, ask: "Where should I create worktrees for this project?"

**Common choices:**
- `.worktrees/` (project-local, recommended)
- `worktrees/` (project-local)
- `~/worktrees/<project>/` (home directory)

## Step 2: Verify Safety (REQUIRED)

**Never skip this step.** Verify project-local directories are gitignored:

```bash
# Check if the worktree directory is properly ignored
git check-ignore -q .worktrees/ 2>/dev/null
echo $?  # Must be 0 (ignored)
```

If NOT ignored:
1. Add to `.gitignore`
2. Verify with `git check-ignore` again
3. Do NOT proceed until ignored

**Why:** Accidentally committing a worktree directory to the repo causes serious problems.

## Step 3: Create Worktree

```bash
# Detect project name
PROJECT_NAME=$(basename "$(git rev-parse --show-toplevel)")

# Create worktree with descriptive branch name
git worktree add .worktrees/${PROJECT_NAME}-${FEATURE_NAME} -b feature/${FEATURE_NAME}
```

## Step 4: Setup Project

Auto-detect and run project setup:

| Indicator | Setup Command |
|-----------|--------------|
| `package.json` | `npm install` or `pnpm install` |
| `Cargo.toml` | `cargo build` |
| `requirements.txt` | `pip install -r requirements.txt` |
| `pyproject.toml` | `poetry install` or `pip install -e .` |
| `go.mod` | `go mod download` |

## Step 5: Verify Clean Baseline

```bash
# Run tests in the new worktree
cd .worktrees/${PROJECT_NAME}-${FEATURE_NAME}
# Run project-appropriate test command
npm test  # or cargo test, pytest, go test ./...
```

**If baseline tests fail:**
- Do NOT proceed with development
- Report the failure to your human partner
- Get explicit permission before continuing

## Step 6: Report Readiness

Confirm:
- Worktree location
- Branch name
- Setup completed
- Test baseline status (pass/fail)

## OpenClaw Integration

When using `coding-agent` for implementation, pass the worktree path as `workdir`:

```
coding-agent background:true workdir:.worktrees/project-feature
```

This ensures the coding agent works in the isolated worktree, not the main repo.

## Cleanup

Worktrees are cleaned up during the `finishing-a-development-branch` mode:
- After merge → remove worktree
- After discard → remove worktree
- Keep branch → keep worktree

```bash
git worktree remove .worktrees/${WORKTREE_NAME}
git branch -d feature/${FEATURE_NAME}  # only if merged
```

## Integration

- **Required before**: executing-plans, subagent-driven-development
- **Cleaned up by**: finishing-a-development-branch
- **Used by**: coding-agent workdir parameter
