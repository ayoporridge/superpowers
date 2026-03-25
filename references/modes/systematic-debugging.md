# Systematic Debugging

> Mode: `debugging` — Use when encountering bugs, test failures, or unexpected behavior.

**Announce at start:** "I'm using the superpowers debugging mode to investigate this issue."

## Core Principle

**NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.**

Phase 1 must be completed before ANY solution attempts. Guessing is not debugging.

## The Four Phases

### Phase 1: Root Cause Investigation

**You MUST complete this phase before attempting any fix.**

1. **Read error messages carefully** — the full stack trace, not just the first line
2. **Reproduce consistently** — if you can't reproduce it, you can't verify your fix
3. **Check recent changes** — `git log`, `git diff` — what changed since it last worked?
4. **Add diagnostic instrumentation** — for multi-component systems, add logging at every boundary
5. **Trace data flow backward** — start at the error and trace back to the source

**Key questions:**
- What is the EXACT error message?
- When did this last work?
- What changed since then?
- Can I reproduce it reliably?
- Is this the actual error or a symptom of something deeper?

### Phase 2: Pattern Analysis

1. **Find similar working code** — search the codebase for analogous functionality that works
2. **Study the reference implementation** — understand every line of the working version
3. **Identify specific differences** — what's different between working and broken?
4. **Understand all dependencies** — what else does this code depend on? Are those dependencies working?

**Key questions:**
- Where does similar code work correctly?
- What's different about the broken case?
- Are all dependencies available and functioning?
- Is this a known issue pattern?

### Phase 3: Hypothesis and Testing

1. **Form a specific, written hypothesis** — "The bug is caused by X because Y"
2. **Test with minimal changes** — change ONE thing at a time
3. **Verify results** — did the change have the expected effect?
4. **If test fails, form new hypothesis** — don't keep trying the same approach

**Rules:**
- One variable at a time. Multiple changes = can't tell what fixed it
- Write the hypothesis down BEFORE testing
- If the fix doesn't match your hypothesis, understand why before moving on

### Phase 4: Implementation

1. **Write a failing test** that demonstrates the bug (TDD mode)
2. **Implement a single fix** addressing the root cause only
3. **Run all tests** — not just the new one
4. **If fix fails after 3 attempts → STOP**

## The 3-Strike Rule

After 3 failed fix attempts:

**STOP fixing. Start questioning.**

- Is your hypothesis wrong?
- Is the problem in a different component?
- Are you fixing symptoms instead of the root cause?
- Is the architecture fundamentally broken for this use case?

Escalate to your human partner. Present:
1. What you've tried
2. What you've learned
3. Why you think the approach isn't working
4. Suggested next steps

In OpenClaw, use `sessions_send` to notify your human partner if they're in a different session, or broadcast to their preferred channel.

## Red Flags — Stop and Restart Investigation

- You're guessing at solutions without understanding the cause
- You've made a fix but can't explain WHY it works
- Each fix reveals a new problem in a different area
- You're patching symptoms instead of fixing root causes
- You've been debugging for > 30 minutes without progress

## Multi-Component Debugging

For systems with multiple components (common in OpenClaw multi-agent setups):

1. **Isolate the component** — which component is actually broken?
2. **Add boundary logging** — log inputs/outputs at every component boundary
3. **Binary search** — narrow down the failing component by testing each boundary
4. **Verify assumptions** — is each component receiving what it expects?

## Debugging Techniques Reference

### Root Cause Tracing
- Start at the error, work backward through the call chain
- At each step: "Is the input correct? Is the transformation correct?"
- The root cause is where correct input produces incorrect output

### Defense in Depth
- After finding and fixing the root cause, ask: "How could we prevent this class of bug?"
- Add validation at boundaries
- Add assertions for invariants
- Improve error messages to make future debugging easier

### Condition-Based Waiting
- For timing/race condition bugs: don't add `sleep()` as a fix
- Instead: identify the condition being waited for and wait for that specific condition
- Use polling with timeout, not fixed delays

## Verification

After implementing a fix:

1. The failing test now passes
2. All other tests still pass
3. You can explain exactly WHY the fix works
4. You can explain what the root cause was
5. You've considered if similar bugs exist elsewhere
