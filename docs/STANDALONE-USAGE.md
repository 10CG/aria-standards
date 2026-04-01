**English** | [中文](STANDALONE-USAGE.zh.md)

# Using aria-standards Without aria-plugin

aria-standards is a standalone methodology library. You can use it without installing the Aria plugin or the Aria main project. This guide explains how.

## What You Get

aria-standards provides **methodology definitions** — documents that tell your AI assistant how to work:

| What | Where | Purpose |
|------|-------|---------|
| Ten-Step Cycle | `core/ten-step-cycle/` | Structured development workflow |
| OpenSpec | `openspec/templates/` | Spec-driven requirements format |
| Conventions | `conventions/` | Git commits, naming, versioning |
| Templates | `templates/` | PRD, User Story, Architecture docs |
| Progress Management | `core/upm/` | Unified progress tracking |

## Installation

```bash
cd your-project
git submodule add https://github.com/10CG/aria-standards.git standards
```

## Minimal Setup

The only thing you need is a `CLAUDE.md` (or equivalent AI config) that references the standards:

```markdown
# Project AI Configuration

## Workflow
Follow the Ten-Step Cycle: @standards/core/ten-step-cycle/README.md

## Conventions
- Git commits: @standards/conventions/git-commit.md
- Naming: @standards/conventions/naming-conventions.md

## Specs
Use OpenSpec for requirements: @standards/openspec/templates/
```

That's it. Your AI assistant reads `CLAUDE.md`, follows the links, and applies the standards.

## Pick What You Need

You don't have to use everything. Common combinations:

### Just the Workflow
```markdown
## Workflow
@standards/core/ten-step-cycle/README.md
@standards/summaries/ten-step-cycle-summary.md
```

### Just the Spec Format
```markdown
## Requirements
Use OpenSpec Level 2 for features: @standards/openspec/templates/
Archive completed specs in openspec/archive/
```

### Just the Conventions
```markdown
## Conventions
@standards/conventions/git-commit.md
@standards/conventions/naming-conventions.md
@standards/conventions/changelog-format.md
```

### Workflow + Conventions (Recommended Minimum)
```markdown
## Workflow
@standards/summaries/ten-step-cycle-summary.md

## Conventions
@standards/conventions/git-commit.md

## Specs
OpenSpec Level 2 for features, Level 1 for bug fixes.
Templates: @standards/openspec/templates/
```

## Token Optimization

For AI assistants with limited context, use the summary files instead of full documents:

| Full Document | Summary Alternative |
|--------------|-------------------|
| `core/ten-step-cycle/README.md` (long) | `summaries/ten-step-cycle-summary.md` (short) |
| `core/upm/` (long) | `summaries/upm-summary.md` (short) |
| All conventions | `summaries/conventions-summary.md` |

Reference in your CLAUDE.md:
```markdown
## Context Loading
L0 (Always): summaries/ten-step-cycle-summary.md, summaries/conventions-summary.md
L1 (On-Demand): Full documents when deep-diving into a topic
```

## Differences from Using with aria-plugin

| Feature | Standards Only | With aria-plugin |
|---------|--------------|-----------------|
| Ten-Step Cycle definition | Manual reference | Automated by Skills |
| OpenSpec templates | Manual copy | `/aria:spec-drafter` |
| Git commit format | Manual adherence | `/aria:commit-msg-generator` |
| State scanning | N/A | `/aria:state-scanner` |
| Task planning | Manual | `/aria:task-planner` |
| Code review | Manual | `/aria:requesting-code-review` |

Standards-only is great for teams that want the methodology without the Claude Code plugin automation layer.

## Updating

```bash
git submodule update --remote standards
```

## Compatibility

- Works with any AI assistant that reads project documentation
- No dependencies on Claude Code, aria-plugin, or the Aria main project
- Plain Markdown files — no runtime, no build step
