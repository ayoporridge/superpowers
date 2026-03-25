# Writing Skills

> Mode: `writing-skills` — Use when creating or editing an OpenClaw skill.

**Announce at start:** "I'm using the superpowers writing-skills mode to create/edit this skill."

## OpenClaw Skill Structure

An OpenClaw skill is a directory with a `SKILL.md` file as the core:

```
skill-name/
├── SKILL.md              # Required: frontmatter + markdown body
├── references/           # Optional: supporting documents
├── scripts/              # Optional: executable scripts
└── assets/               # Optional: templates, output formats
```

### SKILL.md Format

```markdown
---
name: skill-name
description: >-
  One paragraph describing what the skill does and when to use it.
  This is what the agent sees when deciding whether to activate the skill.
version: 1.0.0
tags:
  - relevant
  - tags
---

# Skill Title

## Overview
What this skill does and why.

## When to Use
Trigger conditions — be specific about what user requests activate this.

## When NOT to Use
Anti-patterns — when this skill is the wrong choice.

## The Process
Step-by-step workflow.

## Integration
How this skill connects to other skills or OpenClaw features.
```

## Skill Design Principles

### 1. Minimize Context Window Impact

Every token in SKILL.md costs context window space. Be concise:
- **Good**: Actionable instructions, decision trees, templates
- **Bad**: Lengthy explanations, background reading, edge case encyclopedias

### 2. Progressive Disclosure (3 Layers)

1. **SKILL.md** — always loaded when skill activates. Keep lean.
2. **references/** — loaded on demand when deeper context needed
3. **scripts/** + **assets/** — loaded only when executing specific actions

### 3. Match Specificity to Fragility

- **Flexible workflows** → text instructions ("ask clarifying questions")
- **Preferred patterns** → pseudocode or decision trees
- **Error-prone operations** → exact scripts or commands

### 4. Description is Critical

The `description` field in frontmatter is what the agent uses to decide whether to activate the skill. Make it:
- Specific about trigger conditions
- Clear about what the skill provides
- Honest about what it doesn't do

## Creating a New Skill

### Step 1: Understand

Start with concrete examples:
- "Show me 3 real scenarios where you'd use this skill"
- "What's the input? What's the output?"
- "What goes wrong without this skill?"

### Step 2: Plan

Decide what goes where:
- What must be in SKILL.md? (always-loaded context)
- What can go in references/? (on-demand context)
- What should be a script? (error-prone operations)
- What needs a template? (structured outputs)

### Step 3: Write SKILL.md

Start with the frontmatter, then the body. Keep it under 200 lines if possible. Move supporting content to `references/`.

### Step 4: Add Supporting Files

Create `references/`, `scripts/`, `assets/` only as needed. Each file should have a clear purpose.

### Step 5: Test

1. Install the skill: `cp -r skill-name/ ~/.openclaw/skills/`
2. Verify it appears: check that OpenClaw discovers the skill
3. Test trigger: send messages that should activate the skill
4. Test non-trigger: send messages that should NOT activate it
5. Test the workflow: walk through the full process

### Step 6: Iterate

Use the skill in real work. Note where it fails or feels awkward. Refine.

## Skill Installation Paths

| Path | Priority | Use Case |
|------|----------|----------|
| `<workspace>/skills/` | Highest | Agent-specific skills |
| `~/.openclaw/skills/` | Medium | Shared across all agents |
| Bundled (built-in) | Lowest | Default OpenClaw skills |

Higher priority paths override lower ones (same skill name).

## Distribution

### Via Copy
```bash
cp -r superpowers/ ~/.openclaw/skills/superpowers/
```

### Via ClawHub (when available)
```bash
openclaw skills install superpowers
```

### Via Git
```bash
git clone https://github.com/you/your-skill.git ~/.openclaw/skills/your-skill/
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| SKILL.md too long (500+ lines) | Move content to references/ |
| Vague description | Be specific about triggers |
| No "When NOT to use" | Always define boundaries |
| Hardcoded paths/credentials | Use environment variables |
| No testing instructions | Add verification steps |
