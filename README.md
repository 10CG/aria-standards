**English** | [中文](README.zh.md)

# Aria Standards

> **Aria Methodology** (AI-DDD v3.0) — AI + Rhythm + Iteration + Automation
>
> A complete development standards system combining OpenSpec, Ten-Step Cycle, and requirements management.

## Authoritative Source

> **Single Source of Truth**: [`methodology/aria-brand-guide.md`](methodology/aria-brand-guide.md)
>
> This document defines the complete Aria methodology structure, including:
> - **Aria Core Systems**: Development cycle model, state management, requirements management, spec-driven systems
> - **Brand Structure**: Pre-Cycle, Ten-Step Cycle, Skills classification
> - **Naming Conventions**: Files, Skills, OpenSpec naming rules

---

## Core Value

This repository provides a complete AI-driven development standards system:

| Module | Description |
|--------|-------------|
| **Ten-Step Cycle** | Complete workflow combining OpenSpec + AI-DDD + branch management |
| **Unified Progress Management (UPM)** | Single source of truth for progress tracking |
| **OpenSpec** | Spec-driven development (Draft → Review → Implement → Archive) |
| **Requirements Management** | PRD / User Story + Issue tracking sync |
| **Summary File System** | Token-optimized layered context loading |

## Quick Start

### 1. Integrate into Your Project

```bash
# Using Git Submodule (recommended)
git submodule add https://github.com/10CG/aria-standards.git standards
git submodule update --init --recursive

# Or using SSH
git submodule add git@github.com:10CG/aria-standards.git standards
```

### 2. Configure CLAUDE.md

```markdown
# Project AI Configuration

## Context Loading Strategy
L0 (Always): CLAUDE.md + summaries/
L1 (On-Demand): {module}/ARCHITECTURE.md, UPM
L2 (Deep-Dive): Full spec documents

## Reference Standards
@standards/core/ten-step-cycle/           # Ten-Step Cycle
@standards/core/upm/                      # Unified Progress Management
@standards/summaries/                     # Summary files
@standards/conventions/                   # Development conventions
```

### 3. Apply the Ten-Step Cycle

See [Ten-Step Cycle Guide](core/ten-step-cycle/README.md):

| Phase | Steps | Description |
|-------|-------|-------------|
| **A** | 0-3 | Spec & Planning |
| **B** | 4-6 | Development |
| **C** | 7-8 | Commit & Integration |
| **D** | 9-10 | Closure & Archival |

## Repository Structure

```
standards/
├── core/                           # Core standards (SSOT)
│   ├── ten-step-cycle/             # Ten-Step Cycle model
│   ├── seven-step-cycle/           # Seven-Step Cycle (original)
│   ├── upm/                        # Unified Progress Management
│   ├── architecture/               # Architecture documentation methodology
│   ├── documentation/              # Product doc hierarchy, system architecture spec
│   ├── design-system/              # Design system standards
│   ├── progress-management/        # Progress management core
│   ├── state-management/           # State management
│   └── workflow/                   # Workflow standards
│
├── methodology/                    # Methodology definitions
│   ├── aria-brand-guide.md         # Aria Brand Guide
│   └── contract-driven-development.md
│
├── openspec/                       # OpenSpec spec-driven development
│   ├── project.md                  # Project configuration
│   ├── AGENTS.md                   # Agent definitions
│   ├── specs/                      # Stable specs
│   └── templates/                  # Spec templates
│
├── summaries/                      # Summary files (token-optimized)
│   ├── ten-step-cycle-summary.md
│   ├── workflow-summary.md
│   ├── conventions-summary.md
│   ├── extensions-summary.md
│   ├── upm-summary.md
│   └── requirements-skills-summary.md
│
├── templates/                      # Project templates
│   ├── prd-template.md             # PRD template
│   ├── user-story-template.md      # User Story template
│   ├── system-architecture-template.md  # System architecture template
│   ├── readme-template.md          # README template
│   ├── requirements-directory-structure.md  # Requirements dir structure
│   ├── ai-task-execution.md        # AI task execution template
│   └── claude-config/              # CLAUDE.md config templates
│
├── extensions/                     # Module extensions
│   ├── backend-ai-ddd-extension.md
│   └── mobile-ai-ddd-extension.md
│
├── conventions/                    # Coding and documentation conventions
│   ├── git-commit.md               # Git commit standards
│   ├── naming-conventions.md       # Naming conventions
│   ├── document-classification.md  # Document classification
│   ├── document-metadata.md        # Document metadata
│   ├── content-integrity.md        # Content integrity
│   ├── changelog-format.md         # Changelog format
│   ├── contract-driven.md          # Contract-driven development
│   ├── field-naming.md             # Field naming
│   ├── version-management.md       # Version management
│   └── raci.md                     # RACI matrix
│
├── workflow/                       # Workflow guides
│   ├── branch-management-guide.md
│   ├── git-submodule-workflow.md
│   ├── requirements-workflows.md   # Requirements workflow
│   └── ai-development-workflow.md
│
├── reference/                      # Reference materials
│   └── ai-ddd-glossary.md          # Glossary
│
├── governance/                     # Governance standards
│   └── raci-standard.md
│
└── tools/                          # Automation tools
    └── setup/
```

## Documentation Index

### Core Documents

| Document | Path | Description |
|----------|------|-------------|
| Ten-Step Cycle Overview | [core/ten-step-cycle/README.md](core/ten-step-cycle/README.md) | Recommended entry point |
| Phase A: Spec & Planning | [core/ten-step-cycle/phase-a-spec-planning.md](core/ten-step-cycle/phase-a-spec-planning.md) | Steps 0-3 |
| Phase B: Development | [core/ten-step-cycle/phase-b-development.md](core/ten-step-cycle/phase-b-development.md) | Steps 4-6 |
| Phase C: Commit & Integration | [core/ten-step-cycle/phase-c-integration.md](core/ten-step-cycle/phase-c-integration.md) | Steps 7-8 |
| Phase D: Closure & Archival | [core/ten-step-cycle/phase-d-closure.md](core/ten-step-cycle/phase-d-closure.md) | Steps 9-10 |

### Progress Management

| Document | Path |
|----------|------|
| UPM Spec | [core/upm/unified-progress-management-spec.md](core/upm/unified-progress-management-spec.md) |
| UPM Requirements Extension | [core/upm/upm-requirements-extension.md](core/upm/upm-requirements-extension.md) |
| Progress Management Core | [core/progress-management/ai-ddd-progress-management-core.md](core/progress-management/ai-ddd-progress-management-core.md) |

### Architecture Documentation

| Document | Path |
|----------|------|
| Architecture Methodology | [core/architecture/README.md](core/architecture/README.md) |
| Layering System | [core/architecture/layering-system.md](core/architecture/layering-system.md) |
| Document Templates | [core/architecture/document-templates.md](core/architecture/document-templates.md) |

### Methodology

| Document | Path |
|----------|------|
| Aria Brand Guide | [methodology/aria-brand-guide.md](methodology/aria-brand-guide.md) |
| Contract-Driven Development | [methodology/contract-driven-development.md](methodology/contract-driven-development.md) |

### OpenSpec

| Document | Path |
|----------|------|
| Agent Definitions | [openspec/AGENTS.md](openspec/AGENTS.md) |
| Spec Templates | [openspec/templates/](openspec/templates/) |

### Workflow

| Document | Path |
|----------|------|
| Branch Management Guide | [workflow/branch-management-guide.md](workflow/branch-management-guide.md) |
| Git Submodule Workflow | [workflow/git-submodule-workflow.md](workflow/git-submodule-workflow.md) |
| Requirements Workflow | [workflow/requirements-workflows.md](workflow/requirements-workflows.md) |
| AI Development Workflow | [workflow/ai-development-workflow.md](workflow/ai-development-workflow.md) |

### Development Conventions

| Document | Path |
|----------|------|
| Git Commit Standards | [conventions/git-commit.md](conventions/git-commit.md) |
| Naming Conventions | [conventions/naming-conventions.md](conventions/naming-conventions.md) |
| Document Classification | [conventions/document-classification.md](conventions/document-classification.md) |

### Module Extensions

| Document | Path |
|----------|------|
| Backend Extension | [extensions/backend-ai-ddd-extension.md](extensions/backend-ai-ddd-extension.md) |
| Mobile Extension | [extensions/mobile-ai-ddd-extension.md](extensions/mobile-ai-ddd-extension.md) |

### Reference

| Document | Path |
|----------|------|
| AI-DDD Glossary | [reference/ai-ddd-glossary.md](reference/ai-ddd-glossary.md) |

## Version

| Version | Description |
|---------|-------------|
| Major | Significant architecture changes |
| Minor | New standards or tools |
| Patch | Bug fixes and optimizations |

**Current Version**: 3.0.0 (Aria Methodology)

## Standalone Usage (Without aria-plugin)

You can use aria-standards independently — no Aria plugin or main project required. See the [Standalone Usage Guide](docs/STANDALONE-USAGE.md) for setup with just the standards.

## Contributing

Contributions and best practice suggestions are welcome.

## License

MIT License

---

**Last Updated**: 2026-03-21
**Maintainer**: [10CG Lab](https://github.com/10CG)
