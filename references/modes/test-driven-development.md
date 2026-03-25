# Test-Driven Development (TDD)

> Mode: `tdd` — Use when implementing any feature or bugfix, before writing implementation code.

**Announce at start:** "I'm using the superpowers TDD mode for this implementation."

## The Iron Law

**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.**

If you wrote code before the test → delete it. Start fresh. No exceptions for "keeping it as reference" or "adapting it."

## When to Use

**Always**, for:
- New features
- Bug fixes
- Refactoring that changes behavior
- Any behavior changes

**Exceptions** (require explicit human partner approval):
- Throwaway prototypes
- Generated code
- Configuration-only files

## Red-Green-Refactor Cycle

```
  ┌─────────┐
  │  RED     │  Write ONE minimal failing test
  │  (fail)  │  showing desired behavior
  └────┬─────┘
       │
  ┌────▼─────┐
  │  GREEN   │  Write SIMPLEST code
  │  (pass)  │  that passes the test
  └────┬─────┘
       │
  ┌────▼─────┐
  │ REFACTOR │  Clean up while
  │  (clean) │  keeping tests green
  └────┬─────┘
       │
       └──→ Next test
```

### RED Phase
1. Write one test that captures one specific behavior
2. Run it — it MUST fail
3. Confirm it fails for the EXPECTED reason
4. If it passes → your test doesn't test what you think. Delete and rethink.

### GREEN Phase
1. Write the absolute minimum code to make the test pass
2. No extra features, no "while I'm here" additions
3. Run ALL tests — they must all pass
4. If other tests break → your change has unintended side effects

### REFACTOR Phase
1. Clean up duplication, naming, structure
2. Run tests after EVERY change
3. If tests break → undo immediately
4. Do NOT add new behavior during refactor

## What Makes a Good Test

- **Minimal**: Tests one thing only
- **Clear**: Name describes the behavior being tested
- **Real**: Uses actual code paths, not mocks (when possible)
- **Intent-revealing**: Shows WHY, not just WHAT

## Why Order Matters

**Tests written after code:**
- Pass immediately → proves nothing
- You don't know if they catch the bug they're supposed to catch
- Confirmation bias: you write tests that match your code, not your requirements

**Manual testing:**
- Not reproducible
- Not systematic
- Doesn't catch regressions

## Common Rationalizations (all wrong)

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code has simple tests. Still write them. |
| "I'll write tests after" | Tests after prove nothing. See above. |
| "I already tested manually" | Manual ≠ reproducible ≠ systematic |
| "TDD is too dogmatic" | TDD is a discipline. Discipline prevents mistakes. |
| "Just this once" | That's how every bad habit starts. |
| "I know this works" | Then the test will pass quickly. Write it anyway. |

## Red Flags — STOP and Restart with TDD

- You wrote production code before any test
- A new test passes immediately on first run
- You can't explain why a test should fail
- You're thinking "just this once"
- You have untested code and are adding more

**What to do:** Delete the untested code. Write the test. Watch it fail. Then implement.

## Bug Fix Workflow

1. **Reproduce**: Write a test that demonstrates the bug (RED)
2. **Verify**: Confirm the test fails for the right reason
3. **Fix**: Write minimal fix (GREEN)
4. **Confirm**: All tests pass, including the new one
5. **Prevent**: Consider if edge case tests are needed

## Verification Checklist

Before claiming any implementation is done:

- [ ] Every new function/method has at least one test
- [ ] Each test was watched failing first
- [ ] Minimal code was written to pass each test
- [ ] All tests pass (full suite, not just new ones)
- [ ] Test output is clean (no warnings, no skipped tests)
- [ ] Tests use real code, not excessive mocks
- [ ] Edge cases are covered

## The Final Rule

**Production code exists → a test exists that failed first.**

Otherwise → it's not TDD and it needs to be redone.

No exceptions without explicit human partner permission.
