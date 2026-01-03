# Aria Methodology Brand Guide

> **Version**: 2.0.0
> **Status**: Active
> **Created**: 2026-01-01
> **Updated**: 2026-01-04

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

## Aria Core Systems

Aria 方法论由四个核心系统组成，形成完整的 AI 驱动开发框架。

### Development Cycle Model (开发周期模型)

Aria 将开发活动分为两个阶段：

```
┌─────────────────────────────────────────────────────────────────┐
│           Pre-Cycle: 需求管理 (十步循环之前)                     │
│                                                                  │
│   PRD (L0) ──▶ System Architecture (L1) ──▶ User Stories        │
│   产品需求      系统架构设计                 可实现需求单元       │
│                                                                  │
│   Tools: requirements-validator, requirements-sync, arch-*      │
└──────────────────────────┬──────────────────────────────────────┘
                           │ 选择 ready 状态的 Story
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│           Ten-Step Cycle: 实现周期                               │
│                                                                  │
│   Phase A: 规划 ──▶ Phase B: 开发 ──▶ Phase C: 集成 ──▶ Phase D │
│   (OpenSpec)       (验证)           (提交)           (收尾)     │
│                                                                  │
│   Tools: state-scanner, spec-drafter, progress-updater          │
└─────────────────────────────────────────────────────────────────┘
```

**Document Flow (文档流转链路)**:
```
PRD (L0) → System Architecture (L1) → User Stories → OpenSpec
产品需求     系统架构设计              可实现需求       技术方案
```

### State Management System (状态管理系统)

| Component | Purpose | Location |
|-----------|---------|----------|
| **UPM** | Unified Progress Management | `{module}/docs/project-planning/unified-progress-management.md` |
| **UPMv2-STATE** | Ten-Step Cycle state tracking | Embedded in UPM |
| **requirements section** | Requirements status tracking | `upm-requirements-extension.md` |

### Requirements Management System (需求管理系统)

| Layer | Document | Purpose |
|-------|----------|---------|
| L0 | PRD | Product vision, feature scope, success criteria |
| L1 | System Architecture | System-level technical design, module boundaries |
| - | User Stories | Fine-grained implementable requirement units |

### Specification-Driven System (规范驱动系统)

**OpenSpec Framework** provides structured change management:

```
Change Proposals → Technical Designs → Task Lists → Implementation
提案              技术设计            任务列表       实现
```

---

## Brand Structure

```
Aria Methodology v3.0
├── Aria Core
│   ├── Pre-Cycle            # Requirements management (NEW)
│   │   ├── PRD Management
│   │   ├── System Architecture
│   │   └── User Stories
│   ├── Ten-Step Cycle       # Development workflow
│   │   ├── Phase A: Planning (OpenSpec)
│   │   ├── Phase B: Development
│   │   ├── Phase C: Integration
│   │   └── Phase D: Closure
│   ├── UPM                  # Unified Progress Management
│   ├── OpenSpec             # Specification-driven development
│   └── Validation Gates     # Quality checkpoints
│
├── Aria Skills
│   ├── Entry Skills         # User-facing entry points
│   │   ├── state-scanner
│   │   └── workflow-runner
│   ├── Pre-Cycle Skills     # Requirements management (NEW)
│   │   ├── requirements-validator
│   │   ├── requirements-sync
│   │   └── forgejo-sync
│   ├── Architecture Skills  # Architecture management (NEW)
│   │   ├── arch-common
│   │   ├── arch-search
│   │   └── arch-update
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

| Skill | Purpose | Phase | Invokes |
|-------|---------|-------|---------|
| `state-scanner` | Project state analysis and recommendations | Both | Layer 2 Skills |
| `workflow-runner` | Workflow orchestration and execution | Both | Layer 2 Skills |

### Layer 2: Business Skills (可组合，可独立调用)

#### Pre-Cycle Skills (需求管理阶段)

| Skill | Purpose | Phase |
|-------|---------|-------|
| `requirements-validator` | PRD/Story format and association validation | Pre-Cycle |
| `requirements-sync` | Story ↔ UPM synchronization | Pre-Cycle |
| `forgejo-sync` | Story ↔ Issue, PRD ↔ Wiki synchronization | Pre-Cycle |

#### Architecture Skills (架构管理)

| Skill | Purpose | Phase |
|-------|---------|-------|
| `arch-common` | Shared architecture tool components | Pre-Cycle / Ten-Step |
| `arch-search` | Architecture document search | Pre-Cycle / Ten-Step |
| `arch-update` | Architecture document updates | Pre-Cycle |
| `arch-scaffolder` | Generate architecture skeleton from PRD | Pre-Cycle |

#### Ten-Step Cycle Skills (开发实现阶段)

| Skill | Purpose | Phase |
|-------|---------|-------|
| `spec-drafter` | OpenSpec change drafting | Phase A |
| `commit-msg-generator` | Single commit message generation | Phase C |
| `strategic-commit-orchestrator` | Multi-commit batch orchestration | Phase C |
| `progress-updater` | UPM status updates | Phase D |

### Layer 1: Atomic Skills / External APIs

| Skill/API | Purpose | Phase |
|-----------|---------|-------|
| `validate-docs` | Reference integrity checking | Both |
| Forgejo REST API | Issue/Wiki CRUD operations | Pre-Cycle |

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
| 2.0.0 | 2026-01-04 | Added Aria Core Systems, Pre-Cycle concept, Architecture Skills |
| 1.0.0 | 2026-01-01 | Initial brand guide |

---

## Related Documents

### System-Level Documents
- `CLAUDE.md` - AI configuration entry point (contains development cycle model)
- `docs/architecture/system-architecture.md` - System Architecture (L1)
- `docs/requirements/prd-*.md` - Product Requirements Documents (L0)

### Core Specifications
- `standards/core/ten-step-cycle/README.md` - Ten-Step Cycle specification
- `standards/core/upm/unified-progress-management-spec.md` - UPM specification
- `standards/core/documentation/product-doc-hierarchy.md` - Document hierarchy
- `openspec/project.md` - OpenSpec project configuration

### Extensions
- `standards/extensions/mobile-ai-ddd-extension.md` - Mobile (Flutter) extension
- `standards/extensions/backend-ai-ddd-extension.md` - Backend (Python/FastAPI) extension
