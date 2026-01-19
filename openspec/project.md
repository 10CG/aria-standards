# OpenSpec - Project Definition

> **Version**: 2.0.0
> **Status**: Active
> **Purpose**: Methodology Definition Repository

## Purpose

This repository defines the **OpenSpec format** - a standardized specification format for AI-driven development projects using the Aria methodology.

OpenSpec is the specification format used by the Aria AI-DDD (AI-Assisted Domain-Driven Design) methodology.

## What is OpenSpec?

OpenSpec is a Markdown-based specification format that enables:

- **Structured requirements capture** - proposal.md and tasks.md templates
- **AI-readable specifications** - Optimized for Claude Code and other AI assistants
- **Traceable development** - From PRD → System Architecture → Implementation

## Repository Structure

```
openspec/
├── project.md        # This file - OpenSpec format definition
├── templates/        # Specification templates
│   ├── proposal-minimal.md    # Level 2 Spec template
│   └── tasks.md                # Task breakdown template
├── specs/            # Current active specifications
├── VALIDATION.md     # Validation rules for OpenSpec documents
└── AGENTS.md         # Agent capability definitions
```

## Usage in Projects

### Projects Using OpenSpec

Each project should maintain its own `openspec/` directory:

```
your-project/
├── openspec/
│   ├── changes/          # Proposed changes (Draft/Review)
│   │   └── {feature}/
│   │       ├── proposal.md
│   │       └── tasks.md
│   └── archive/          # Completed changes
│       └── {date}-{feature}/
└── ...
```

### Integration with aria-standards

Projects include aria-standards as a Git submodule:

```bash
# In your project
git submodule add ssh://forgejo@forgejo.10cg.pub/10CG/aria-standards.git standards
```

This provides:
- OpenSpec format definitions
- Template files for creating new specs
- Validation rules
- Aria methodology documentation

## OpenSpec Levels

| Level | Name | When to Use | Output |
|-------|------|-------------|--------|
| 1 | Skip | Simple fixes, typos | No spec needed |
| 2 | Minimal | Medium features (1-3 days) | proposal.md |
| 3 | Full | Architecture changes | proposal.md + tasks.md |

## Specification Lifecycle

```
Draft → Review → Approved → Implementing → Implemented → Archived
                                                           ↓
                                              Move to archive/
```

## Related Resources

- **Aria Methodology**: https://forgejo.10cg.pub/10CG/Aria
- **OpenSpec Validation**: VALIDATION.md
- **Agent Capabilities**: AGENTS.md

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-01-19 | Restructured as methodology definition only |
| 1.0.0 | 2025-12-17 | Initial version |

---

**Maintained By**: 10CG Lab
**Repository**: https://forgejo@forgejo.10cg.pub/10CG/aria-standards.git
