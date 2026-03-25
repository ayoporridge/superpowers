# Executing Plans

> Mode: `executing-plans` — Use when you have a plan to execute without coding-agent subagents.

**Announce at start:** "I'm using the superpowers executing-plans mode to implement this plan."

**Note:** If coding-agent is available, prefer `subagent-driven-development` mode instead — it provides higher quality through fresh context per task and two-stage review.

## Prerequisites

- [ ] A written plan exists (from writing-plans mode)
- [ ] Plan has been reviewed and approved
- [ ] Git worktree is set up (use git-worktrees mode)
- [ ] Tracker file exists at `docs/superpowers/tracker.md`

## The Process

### Step 1: Load and Review Plan

1. Read the plan file
2. Review critically — identify any questions or concerns
3. If concerns → raise them with your human partner before starting
4. If no concerns → update tracker and proceed

### Step 2: Execute Tasks

For each task in the plan:

1. **Update tracker** — mark task as 🔄 in progress
   ```markdown
   | 3 | Implement auth middleware | 🔄 | self | Starting... |
   ```

2. **Follow TDD** (always):
   - Write failing test
   - Watch it fail
   - Implement minimal code
   - Watch it pass
   - Commit

3. **Follow each step exactly** — the plan has bite-sized steps for a reason

4. **Run verification** as specified in the plan

5. **Update tracker** — mark task as ✅ completed with evidence
   ```markdown
   | 3 | Implement auth middleware | ✅ | self | All 5 tests pass |
   ```

6. **Commit** after each task

### Step 3: Handle Blockers

**STOP executing immediately when:**
- Missing dependency, test fails unexpectedly, instruction unclear
- Plan has critical gaps preventing progress
- Verification fails repeatedly

**Update tracker:**
```markdown
| 4 | Database migration | 🚫 | self | Blocked: missing prisma schema |
```

**Ask for clarification rather than guessing.** In OpenClaw, use `sessions_send` to notify your human partner if needed.

### Step 4: Complete Development

After ALL tasks are completed and verified:

1. Run full test suite (verification mode — fresh evidence)
2. Update tracker summary:
   ```markdown
   ## Summary
   - **Total tasks**: 8
   - **Completed**: 8
   - **Blocked**: 0
   - **Last updated**: 2026-03-25T14:30:00Z
   ```
3. Transition to finish-branch mode:
   > "All tasks complete. I'm using the superpowers finish-branch mode to complete this work."
4. Load `references/modes/finishing-a-development-branch.md`

**OpenClaw enhancement:** Broadcast completion:
```
sessions_send announce:true message:"[superpowers] 🏁 Plan complete: {feature} — all {N} tasks done, all tests passing."
```

## Checkpoint Reviews

Every 3 tasks, pause and:
1. Run full test suite
2. Review overall progress against the plan
3. Check for drift from the original spec
4. If significant drift detected → stop and discuss with human partner

## Rules

- **Review plan critically first** — don't blindly execute a flawed plan
- **Follow plan steps exactly** — don't improvise
- **Don't skip verifications** — every step that says "verify" means run the command
- **Stop when blocked** — don't guess
- **Never start implementation on main/master** without explicit user consent
- **Update tracker after every task** — this is your persistence mechanism
