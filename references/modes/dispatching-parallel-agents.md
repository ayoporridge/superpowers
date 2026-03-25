# Dispatching Parallel Agents

> Mode: `parallel-dispatch` — Use when you have 3+ independent problems across different domains.

**Announce at start:** "I'm using the superpowers parallel-dispatch mode to tackle these independent tasks simultaneously."

## When to Use

**Decision tree:**

```
Multiple failures or tasks?
  └─ Yes → Are they in different domains/files?
       └─ Yes → Do they share state or dependencies?
            └─ No → Are there 3+ of them?
                 └─ Yes → USE PARALLEL DISPATCH
                 └─ No  → Handle sequentially
            └─ Yes → Handle sequentially (shared state = serial)
       └─ No → Handle sequentially (same domain = likely related)
  └─ No → Handle individually
```

## When NOT to Use

- Failures/tasks that might be related (same root cause)
- Exploratory debugging (don't know what's wrong yet)
- Tasks requiring full system context
- Tasks that modify the same files
- Fewer than 3 independent problems

## The Pattern

### Step 1: Identify Independent Problem Domains

Analyze the tasks and group by domain:
- Different files → likely independent
- Different modules → likely independent
- Same error in multiple places → likely ONE root cause (don't parallelize)

### Step 2: Create Focused Agent Tasks

For each independent domain, create a focused prompt:

**Good prompt (focused):**
```
Fix the timeout handling in agent-tool-abort.test.ts.
The test expects AbortError but gets TimeoutError.
Look at how abort signals propagate in src/agents/tools/.
Only modify files in this directory.
```

**Bad prompt (too broad):**
```
Fix all failing tests.
```

**Each prompt must include:**
- Specific scope (which files/directories)
- Context about the failure
- Expected outcome
- Constraints (what NOT to touch)

### Step 3: Dispatch in Parallel

**Via coding-agent (recommended for implementation):**
```
coding-agent background:true workdir:{WORKTREE_1} prompt:"[focused prompt for domain 1]"
coding-agent background:true workdir:{WORKTREE_2} prompt:"[focused prompt for domain 2]"
coding-agent background:true workdir:{WORKTREE_3} prompt:"[focused prompt for domain 3]"
```

**Via sessions_send (for review/analysis tasks):**
```
sessions_send to:agent-1 message:"[focused analysis prompt for domain 1]"
sessions_send to:agent-2 message:"[focused analysis prompt for domain 2]"
sessions_send to:agent-3 message:"[focused analysis prompt for domain 3]"
```

### Step 4: Review and Integrate Results

After all agents complete:

1. **Collect results** — check each agent's report via `sessions_history` or process logs
2. **Check for conflicts** — run `scripts/check-conflicts.sh`
3. **Integrate** — merge results, resolve any conflicts
4. **Verify** — run full test suite on integrated result (verification mode)

## Common Mistakes

| Mistake | Example | Fix |
|---------|---------|-----|
| Too broad | "Fix all tests" | One agent per test file/domain |
| Related failures | 3 tests fail, same module | Investigate as one problem first |
| Shared state | Two agents modify `config.ts` | Handle sequentially |
| Missing context | "Fix the bug" | Include error message, file, expected behavior |
| No verification | Trust agent reports | Run full tests after integration |

## Real-World Example

**Situation:** 6 test failures across 3 files

```
FAIL src/agents/agent-tool-abort.test.ts     (2 failures)
FAIL src/agents/batch-completion.test.ts      (2 failures)
FAIL src/agents/race-condition.test.ts        (2 failures)
```

**Analysis:** Different files, different domains (abort logic, batch handling, race conditions). Likely independent.

**Dispatch:**
```
# Agent 1: Abort logic
coding-agent background:true workdir:.worktrees/fix-abort prompt:"
  Fix 2 failures in agent-tool-abort.test.ts.
  Focus on abort signal propagation in src/agents/tools/.
  Expected: AbortError, Getting: TimeoutError."

# Agent 2: Batch completion
coding-agent background:true workdir:.worktrees/fix-batch prompt:"
  Fix 2 failures in batch-completion.test.ts.
  Focus on batch result aggregation in src/agents/batch/.
  Expected: all items resolved, Getting: partial resolution."

# Agent 3: Race conditions
coding-agent background:true workdir:.worktrees/fix-race prompt:"
  Fix 2 failures in race-condition.test.ts.
  Focus on lock acquisition in src/agents/concurrency/.
  Expected: sequential execution, Getting: interleaved."
```

**After all complete:** Merge branches, run full test suite, verify all 6 tests pass.

## Benefits

- **Speed** — N agents working simultaneously vs. sequential
- **Focus** — each agent has minimal, relevant context
- **Isolation** — separate worktrees prevent interference
- **Quality** — focused context = better solutions

## OpenClaw Advantages

OpenClaw's multi-agent architecture makes this pattern especially powerful:
- `coding-agent background:true` provides true process isolation
- `sessions_send` enables coordination without shared context
- `sessions_history` enables result collection without polling
- Cron can monitor long-running parallel agents and notify on completion
