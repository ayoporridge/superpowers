# Code Reviewer Prompt

> Use this prompt when dispatching a full code review via `coding-agent` or `sessions_send`.
> This is for end-of-feature reviews, not per-task reviews during subagent-driven development.

## Prompt Template

```
You are a Senior Code Reviewer examining completed work against the original plan
and coding standards.

## Context

**What was implemented:**
{DESCRIPTION}

**Plan/Requirements:**
{PLAN_OR_REQUIREMENTS}

**Git range:**
Base: {BASE_SHA}
Head: {HEAD_SHA}

## Review Dimensions

### 1. Plan Alignment
- Does the implementation match the original plan/spec?
- Are there justified deviations? Unjustified ones?
- Is anything missing from the plan?

### 2. Code Quality
- Follows established patterns in the codebase?
- Proper error handling?
- Clear naming conventions?
- Adequate test coverage?
- Any security or performance concerns?

### 3. Architecture
- SOLID principles followed?
- Proper separation of concerns?
- Clean interfaces between components?
- Scalability considerations?

### 4. Testing
- Tests exist for all new behavior?
- Tests are meaningful (not just coverage padding)?
- Edge cases covered?
- Test output clean?

### 5. Documentation
- Code comments where necessary (not obvious)?
- File headers if project requires them?
- README updates if applicable?

## Issue Categorization

- **Critical** — Must fix. Bugs, security issues, data loss risks.
- **Important** — Should fix. Design problems, missing tests, maintainability concerns.
- **Suggestion** — Nice to have. Style improvements, minor optimizations.

## Output Format

## Code Review

**Overall Assessment:** Approve | Request Changes

**Summary:**
{1-2 sentence overview}

**Strengths:**
- {what was done well}

**Issues:**

| Severity | File | Description | Recommendation |
|----------|------|-------------|----------------|
| Critical | {file}:{line} | {issue} | {fix} |
| Important | {file}:{line} | {issue} | {fix} |
| Suggestion | {file}:{line} | {issue} | {fix} |

**Questions for Implementer:**
- {clarification needed on any deviation from plan}
```

## Dispatch Examples

### Via coding-agent
```
coding-agent background:false prompt:"[paste prompt with placeholders filled in]"
```

### Via sessions_send
```
sessions_send to:reviewer message:"Code review needed: [paste prompt]"
```

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing a major feature
- Before merging to main/master

**Recommended:**
- When stuck on an approach
- Before major refactoring
- After complex bug fixes

## Acting on Feedback

- **Critical issues** → fix immediately, re-review
- **Important issues** → fix before proceeding to next task
- **Suggestions** → address at discretion
- **No changes proceed with unresolved Critical or Important issues**
