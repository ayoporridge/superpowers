# Brainstorming

> Mode: `brainstorming` — Use before any creative work, feature design, or new project.

**Announce at start:** "I'm using the superpowers brainstorming mode to design this properly before implementation."

## Hard Gate

**Do NOT write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it.**

There is NO "too simple" exception. Even todo lists and config changes need design approval. Unexamined assumptions cause the most wasted work on "simple" projects.

## The Process

### Task 1: Explore Context

Read existing project files, documentation, and codebase to understand:
- Current architecture
- Existing patterns
- Constraints and dependencies

### Task 2: Visual Companion (Optional)

If the design would benefit from visual mockups, diagrams, or UI wireframes, offer this as a **separate message**:

> "Would a visual companion help here? I can create diagrams/mockups for [specific aspect]."

Decision is per-question, not per-session. Some questions benefit from visuals, others don't.

### Task 3: Clarifying Questions

Ask questions **one at a time** to understand:
- **Purpose**: What problem does this solve?
- **Constraints**: What are the hard requirements?
- **Success criteria**: How will we know it works?
- **Scope**: What's explicitly out of scope?

**Rules:**
- ONE question per message
- Prefer multiple-choice format when possible
- Don't overwhelm — ask the most important question first

### Task 4: Propose Approaches

Present **2-3 approaches** with clear trade-offs:

For each approach:
- Name and brief description
- Pros
- Cons
- Complexity estimate (Low / Medium / High)
- Recommended: Yes / No (with reasoning)

### Task 5: Design Sections

Present the design iteratively, section by section:
- Scale detail to complexity (few sentences → 300 words per section)
- Get approval on each section before moving on
- Break multi-subsystem designs into isolated, well-bounded units

**Scope detection:** If the design spans multiple independent subsystems, flag it:
> "This looks like it covers multiple independent subsystems: [X, Y, Z]. I recommend decomposing into sub-projects. Should we focus on [X] first?"

### Task 6: Write Design Document

Write the approved design to:
```
docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md
```

Use the template from `assets/spec-template.md`.

### Task 7: Spec Review Loop

Dispatch a spec review (max 3 iterations):

**Using coding-agent:**
```
coding-agent background:false prompt:"[spec-document-reviewer prompt from references/prompts/spec-document-reviewer-prompt.md]"
```

**Using sessions_send (if reviewer agent available):**
```
sessions_send to:reviewer message:"Review this spec: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md"
```

**Review loop:**
1. Send spec for review
2. If issues found → fix and re-submit (max 3 iterations)
3. If approved → proceed to Task 8

### Task 8: User Review

Present the written spec to the user for final approval.

**OpenClaw enhancement:** If user is on a different channel, use `sessions_send` with `announce:true` to notify them the spec is ready for review.

### Task 9: Transition to Planning (Terminal State)

The ONLY next step after brainstorming is **writing-plans** mode.

> "The design is approved. I'm transitioning to the writing-plans mode to create an implementation plan."

Load `references/modes/writing-plans.md` and proceed.

**Do NOT invoke any other mode or start implementation from brainstorming.**

## Anti-Patterns

- ❌ Skipping design for "simple" projects
- ❌ Asking 5 questions at once
- ❌ Starting code before spec approval
- ❌ Going directly to implementation without a plan
- ❌ Treating brainstorming as optional
