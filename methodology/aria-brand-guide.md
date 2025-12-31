# Aria Methodology Brand Guide

> **Version**: 1.0.0
> **Status**: Active
> **Created**: 2026-01-01

---

## Overview

**Aria** is the brand name for the AI-DDD (AI-Driven Domain Development) methodology system. This guide defines the brand structure, naming conventions, and application rules.

---

## Brand Name

### Etymology

**Aria** = **A**I + **R**hythm + **I**teration + **A**utomation

| Component | Meaning |
|-----------|---------|
| **AI** | AI-driven development at the core |
| **Rhythm** | Rhythmic development cycles (Ten-Step Cycle) |
| **Iteration** | Continuous improvement through iterations |
| **Automation** | Automated validation and workflow execution |

### Musical Metaphor

In music, an "aria" is a self-contained piece for one voice, typically in an opera. Similarly, Aria Methodology provides a unified voice for AI-assisted software development, bringing harmony to the development process through structured cycles and automated assistance.

---

## Brand Structure

```
Aria Methodology v3.0
├── Aria Core
│   ├── Ten-Step Cycle       # Development workflow (唯一活跃版本)
│   ├── UPM                  # Unified Progress Management
│   ├── OpenSpec             # Specification-driven development
│   └── Validation Gates     # Quality checkpoints
│
├── Aria Skills
│   ├── Entry Skills         # User-facing entry points
│   │   ├── state-scanner
│   │   └── workflow-runner
│   ├── Requirements Skills  # Requirements management
│   │   ├── requirements-validator
│   │   ├── requirements-sync
│   │   └── forgejo-sync
│   ├── Commit Skills        # Git commit management
│   │   ├── commit-msg-generator
│   │   └── strategic-commit-orchestrator
│   └── Spec Skills          # Specification management
│       ├── spec-drafter
│       └── validate-docs
│
├── Aria Specs
│   └── OpenSpec Framework   # Change management system
│
└── Aria Extensions
    ├── Mobile Extension     # Flutter/mobile specific
    └── Backend Extension    # Python/FastAPI specific
```

---

## Skill Hierarchy

### Layer 3: Entry Skills (用户直接调用)

| Skill | Purpose | Invokes |
|-------|---------|---------|
| `state-scanner` | Project state analysis and recommendations | Layer 2 Skills |
| `workflow-runner` | Workflow orchestration and execution | Layer 2 Skills |

### Layer 2: Business Skills (可组合，可独立调用)

| Skill | Purpose | Category |
|-------|---------|----------|
| `requirements-validator` | PRD/Story format and association validation | Requirements |
| `requirements-sync` | Story ↔ UPM synchronization | Requirements |
| `forgejo-sync` | Story ↔ Issue, PRD ↔ Wiki synchronization | Requirements |
| `commit-msg-generator` | Single commit message generation | Commit |
| `strategic-commit-orchestrator` | Multi-commit batch orchestration | Commit |
| `spec-drafter` | OpenSpec change drafting | Spec |

### Layer 1: Atomic Skills / External APIs

| Skill/API | Purpose |
|-----------|---------|
| `validate-docs` | Reference integrity checking |
| `progress-updater` | UPM status updates |
| Forgejo REST API | Issue/Wiki CRUD operations |

---

## Naming Conventions

### File Naming

| Document Type | Pattern | Example |
|---------------|---------|---------|
| Brand Guide | `aria-*.md` | `aria-brand-guide.md` |
| Core Spec | `{feature}-spec.md` | `unified-progress-management-spec.md` |
| Extension | `{platform}-ai-ddd-extension.md` | `mobile-ai-ddd-extension.md` |
| Summary | `{topic}-summary.md` | `workflow-summary.md` |

### Skill Naming

| Category | Pattern | Examples |
|----------|---------|----------|
| Entry | `{action}-{target}` | `state-scanner`, `workflow-runner` |
| Requirements | `requirements-{action}` | `requirements-validator`, `requirements-sync` |
| Commit | `{type}-{scope}` | `commit-msg-generator`, `strategic-commit-orchestrator` |
| External Sync | `{platform}-sync` | `forgejo-sync` |

### OpenSpec Naming

| Type | Pattern | Example |
|------|---------|---------|
| Change ID | `{verb}-{feature}` | `evolve-ai-ddd-system`, `simplify-doc-format` |
| Spec Path | `specs/{capability}/spec.md` | `specs/requirements-validator/spec.md` |

---

## Usage Guidelines

### When to Use "Aria"

- **DO**: Use "Aria Methodology" when referring to the complete system
- **DO**: Use "Aria Skills" when discussing the skill ecosystem
- **DO**: Use "Aria Core" when referring to fundamental concepts

### When to Use "AI-DDD"

- **DO**: Use "AI-DDD" as a technical descriptor in documentation
- **DO**: Use "AI-DDD v3.0" for version references
- **DO**: Use "AI-DDD Extension" for platform-specific guides

### Avoid

- **DON'T**: Mix "Aria" and "AI-DDD" in the same sentence unnecessarily
- **DON'T**: Use "Aria" for internal technical identifiers (use ai-ddd)
- **DON'T**: Create new brand terms without updating this guide

---

## Brand Application Examples

### Documentation Headers

```markdown
# Feature Name

> **Methodology**: Aria v3.0
> **Phase**: Implementation
```

### README References

```markdown
This project follows the [Aria Methodology](standards/methodology/aria-brand-guide.md)
for AI-assisted development.
```

### Commit Messages

```
docs(aria): add brand guide for AI-DDD methodology
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-01 | Initial brand guide |

---

## Related Documents

- `standards/core/ten-step-cycle/README.md` - Ten-Step Cycle specification
- `standards/core/upm/unified-progress-management-spec.md` - UPM specification
- `openspec/project.md` - OpenSpec project configuration
