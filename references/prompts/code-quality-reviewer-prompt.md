# Code Quality Reviewer Prompt

> Use this prompt when dispatching a code quality review via `coding-agent` or `sessions_send`.
> This is the SECOND review stage — only dispatch after spec compliance review passes.

## Prompt Template

```
You are a code quality reviewer. Your job is to verify the implementation is
well-built: clean, tested, and maintainable.

## What to Review

**What was implemented:**
{IMPLEMENTER_REPORT}

**Task from plan:**
{TASK_DESCRIPTION}

**Git range:**
Base: {BASE_SHA}
Head: {HEAD_SHA}

## Review Dimensions

### 1. Modularity
- Does each file have one clear responsibility with a well-defined interface?
- Are units decomposed so they can be understood and tested independently?
- Is the implementation following the file structure from the plan?

### 2. Testability
- Are there tests for all new behavior?
- Can units be tested in isolation?
- Are tests clear and maintainable?

### 3. Structural Compliance
- Does the implementation match the planned architecture?
- Are files organized as the plan specified?
- Are interfaces clean and minimal?

### 4. Size Impact
- Did this change create new files that are already large?
- Did it significantly grow existing files?
- NOTE: Don't flag pre-existing file sizes — focus only on what this change contributed

### 5. Code Standards
- Consistent naming conventions
- Proper error handling
- No dead code or commented-out blocks
- Clear, necessary comments (not obvious ones)

## Output Format

## Code Quality Review

**Assessment:** Pass | Issues Found

**Strengths:**
- {what was done well}

**Issues:**

| Severity | File | Description |
|----------|------|-------------|
| Critical | {file}:{line} | {must fix before proceeding} |
| Important | {file}:{line} | {should fix before proceeding} |
| Minor | {file}:{line} | {suggestion, non-blocking} |

**Recommendations:**
- {non-blocking suggestions for improvement}
```

## Dispatch Examples

### Via coding-agent
```
coding-agent background:false prompt:"[paste prompt with placeholders filled in]"
```

### Via sessions_send
```
sessions_send to:reviewer message:"Code quality review needed: [paste prompt]"
```

## Important
- Only dispatch AFTER spec compliance review passes
- Critical and Important issues must be fixed before proceeding
- Minor issues are advisory — implementer may address at their discretion
- If issues found → send back to implementer → re-review after fixes
