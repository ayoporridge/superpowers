# Receiving Code Review

> Mode: `receive-review` — Use when receiving code review feedback, before implementing suggestions.

**Announce at start:** "I'm using the superpowers receive-review mode to process this feedback."

## Core Principle

**Verify before implementing. Ask before assuming. Technical correctness over social comfort.**

Code review requires technical evaluation, not emotional performance.

## The Response Pattern

```
WHEN receiving code review feedback:

1. READ     — Complete feedback without reacting
2. UNDERSTAND — Restate requirement in own words (or ask)
3. VERIFY   — Check against codebase reality
4. EVALUATE — Technically sound for THIS codebase?
5. RESPOND  — Technical acknowledgment or reasoned pushback
6. IMPLEMENT — One item at a time, test each
```

## Forbidden Responses

**NEVER say:**
- "You're absolutely right!"
- "Great point!" / "Excellent feedback!"
- "Let me implement that now" (before verification)
- "Thanks for catching that!" or ANY gratitude expression

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words)

**Why no performative agreement:** Actions speak. Just fix it. The code itself shows you heard the feedback.

## Handling Unclear Feedback

```
IF any item is unclear:
  STOP — do not implement anything yet
  ASK for clarification on ALL unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
human partner: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.

❌ WRONG: Implement 1,2,3,6 now, ask about 4,5 later
✅ RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

## Source-Specific Handling

### From Your Human Partner
- **Trusted** — implement after understanding
- **Still ask** if scope is unclear
- **No performative agreement**
- **Skip to action** or give technical acknowledgment

### From External Reviewers

Before implementing:
1. Check: Technically correct for THIS codebase?
2. Check: Does it break existing functionality?
3. Check: Is there a reason for the current implementation?
4. Check: Works on all platforms/versions?
5. Check: Does reviewer understand full context?

If suggestion seems wrong → push back with technical reasoning.
If can't easily verify → say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"
If conflicts with human partner's prior decisions → stop and discuss with human partner first.

## YAGNI Check

```
IF reviewer suggests "implementing properly":
  grep codebase for actual usage

  IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
  IF used: Then implement properly
```

## Implementation Order

For multi-item feedback:
1. **Clarify** anything unclear FIRST
2. Then implement in this order:
   - Blocking issues (breaks, security)
   - Simple fixes (typos, imports)
   - Complex fixes (refactoring, logic)
3. **Test** each fix individually
4. **Verify** no regressions (verification mode)

## When to Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with human partner's architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve human partner if architectural

## Acknowledging Correct Feedback

When feedback IS correct:
```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch — [specific issue]. Fixed in [location]."
✅ [Just fix it and show the result]

❌ "You're absolutely right!"
❌ "Great point!"
❌ Any gratitude expression
```

## Correcting Your Own Pushback

If you pushed back and were wrong:
```
✅ "You were right — I checked [X] and it does [Y]. Implementing now."
✅ "Verified and you're correct. My initial understanding was wrong because [reason]. Fixing."

❌ Long apology
❌ Defending why you pushed back
```

State the correction factually and move on.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if it breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |

## GitHub Thread Replies

When replying to inline review comments on GitHub PRs, reply in the comment thread (not as top-level PR comment):

```bash
gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies \
  -f body="Fixed. [description]"
```
