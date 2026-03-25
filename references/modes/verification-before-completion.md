# Verification Before Completion

> Mode: `verification` — Use before ANY claim that work is complete or correct.

**This mode is always active.** You do not need to announce it — just follow it.

## The Rule

**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**

Before stating anything is complete, you must:

1. **Identify** the specific command that proves your claim
2. **Execute** it fully (never partial, never cached, never from memory)
3. **Read** the complete output and check exit codes
4. **Verify** the output actually confirms your claim
5. **Only then** state the result with evidence

## What This Means

**Confidence ≠ evidence.** Feeling certain about a fix is not the same as running the test that proves it.

You MUST run fresh verification before:
- Claiming a task is done
- Expressing satisfaction with code
- Saying tests pass
- Committing code
- Creating a PR
- Marking a tracker item as completed
- Sending a completion notification

## Forbidden Language (without evidence)

These phrases are BANNED unless you've just run verification:

- "This should work"
- "Tests should pass now"
- "That should fix it"
- "I'm confident this works"
- "I believe that's correct"
- "Probably fixed"
- "Seems to be working"
- "Looks good"

**Replace with:** Run the command. Show the output. State the fact.

## Sufficient vs Insufficient Verification

### Tests
- ✅ Run full test suite, show output, zero failures
- ❌ "I ran the relevant tests" (which ones? what output?)
- ❌ "Tests were passing earlier" (earlier ≠ now)

### Build
- ✅ Run build command, show clean output
- ❌ "It compiles" (prove it)
- ❌ "No errors expected" (expectations aren't evidence)

### Bug Fix
- ✅ Test that reproduces bug → fails → fix → passes
- ❌ "I fixed the issue" (show the test)
- ❌ "Manually verified" (not reproducible)

### Regression
- ✅ Full test suite passes, not just new tests
- ❌ "New tests pass" (what about existing ones?)
- ❌ "I didn't change anything else" (prove it with tests)

## Integration with Tracker

When updating `docs/superpowers/tracker.md`:
- Only mark `✅ completed` AFTER running verification
- Paste verification evidence (command + output summary) in the task notes
- If verification fails → mark as `🔄 in progress`, not `✅ completed`

## The Bottom Line

Run the verification. Read the output. Then claim success.

**No exceptions.** Not for fatigue, not for "just this once," not for "it's obvious."

Evidence before claims, always.
