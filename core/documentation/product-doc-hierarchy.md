# Product Documentation Hierarchy Specification

> **Version**: 1.2.0
> **Status**: Active
> **Created**: 2026-01-02
> **Last Updated**: 2026-01-04
> **Methodology**: Aria (AI-DDD v3.0)

---

## 1. Overview

This specification defines the documentation hierarchy for Aria methodology projects, establishing clear layers, reference rules, and validation criteria for product and technical documentation.

### 1.1 Purpose

- Establish consistent documentation structure across projects
- Define clear ownership and reference relationships
- Enable automated validation of documentation integrity
- Support AI agents in navigating project documentation

### 1.2 Scope

This specification applies to:
- Product requirements documents (PRD)
- System architecture documents
- Module-level documentation
- API contracts and specifications

---

## 2. Documentation Layers

### 2.1 Layer Definition

```
L0 - Product Requirements Layer
    ├── Primary: docs/requirements/prd-{project}.md
    │
    │   Defines: Product vision, user value, feature scope
    │
    ↓
L1 - System Architecture Layer
    ├── Primary: docs/architecture/system-architecture.md
    │
    │   Defines: System-level architecture, module boundaries, key decisions
    │
    ↓
L2 - Module Requirements/Architecture Layer
    ├── {module}/docs/requirements/prd-{module}.md
    ├── {module}/docs/ARCHITECTURE.md
    │
    │   Defines: Module-specific requirements and technical design
    │
    ↓
L3 - Detailed Design Layer
    ├── {module}/docs/architecture/*.md
    ├── shared/contracts/*.yaml
    │
    │   Defines: Implementation details, API contracts
    │
    ↓
L4 - Implementation Documentation
    ├── Code comments and docstrings
    ├── {module}/docs/api/*.md
    ├── {module}/docs/guides/*.md
```

### 2.2 Layer Responsibilities

| Layer | Owner | Content | Update Frequency |
|-------|-------|---------|------------------|
| L0 | Product Owner | Vision, goals, feature scope | Per major release |
| L1 | Tech Lead | Architecture decisions, boundaries | Per phase change |
| L2 | Module Lead | Module requirements, design | Per feature |
| L3 | Developer | Detailed specs, contracts | Per implementation |
| L4 | Developer | Code docs, guides | Continuous |

### 2.3 User Stories Position

User Stories are **not a documentation layer** but rather **implementable requirement units** derived from PRD (L0) and constrained by System Architecture (L1):

```
L0 PRD → L1 System Architecture → User Stories
                                       ↓
                             (ready for Ten-Step Cycle)
```

| Aspect | Description |
|--------|-------------|
| **Location** | `docs/requirements/stories/` |
| **Purpose** | Fine-grained, implementable requirement units |
| **Owner** | Product Owner + Development Team |
| **Input** | PRD goals, Architecture constraints |
| **Output** | Ready stories for Ten-Step Cycle |
| **Phase** | Pre-Cycle (requirements management) |

---

## 3. Document Types

### 3.1 PRD (Product Requirements Document)

```yaml
Purpose: Define business requirements and user value
Perspective: Product/Business
Audience: Product managers, stakeholders, development team
Location:
  - Project: docs/requirements/prd-{project}.md
  - Module: {module}/docs/requirements/prd-{module}.md

Required Sections:
  - Executive Summary
  - Problem Statement
  - User Stories / Requirements
  - Success Metrics
  - Version Roadmap
```

### 3.2 System Architecture

```yaml
Purpose: Define technical architecture and system design
Perspective: Technical/Architectural
Audience: Architects, tech leads, developers
Location: docs/architecture/system-architecture.md

Required Sections:
  - System Overview
  - Architecture Diagram
  - Module Boundaries
  - Technology Decisions
  - Cross-Cutting Concerns
  - Evolution Roadmap

Note: Replaces former "RPD" terminology
```

### 3.3 Module Architecture

```yaml
Purpose: Define module-specific technical design
Perspective: Module technical design
Audience: Module developers, integrators
Location: {module}/docs/ARCHITECTURE.md

Required Sections:
  - Module Overview
  - Layer Structure
  - Key Components
  - Data Flow
  - Integration Points
```

### 3.4 API Contracts

```yaml
Purpose: Define interface specifications
Perspective: Interface/Contract
Audience: Frontend/Backend developers
Location: shared/contracts/*.yaml

Format: OpenAPI 3.0 specification
```

### 3.5 UPM (Unified Progress Management)

```yaml
Purpose: Track development progress
Perspective: Project management
Audience: Project managers, team leads
Location: {module}/docs/project-planning/unified-progress-management.md

Specification: standards/core/upm/unified-progress-management-spec.md
```

---

## 4. Reference Rules

### 4.1 Upward Reference (Required)

Lower-layer documents MUST reference their parent documents:

```markdown
> **Parent Document**: `docs/requirements/prd-{project}.md`
> **Parent Architecture**: `docs/architecture/system-architecture.md`
```

### 4.2 Downward Reference (Recommended)

Higher-layer documents SHOULD list their child documents:

```markdown
## Related Documents

| Module | Document | Description |
|--------|----------|-------------|
| Backend | `backend/docs/requirements/prd-backend.md` | Backend requirements |
| Mobile | `mobile/docs/ARCHITECTURE.md` | Mobile architecture |
```

### 4.3 Peer Reference (As Needed)

Same-layer documents MAY reference each other with clear relationship:

```markdown
> **Related**: `mobile/docs/ARCHITECTURE.md` (Mobile implementation)
```

### 4.4 Circular Reference (Prohibited)

Document references MUST NOT form cycles:
- A → B → C → A (Prohibited)

### 4.5 Reference Validation

```bash
# Validate all references point to existing files
# No orphan documents (every doc must be referenced)
# No circular references detected
```

---

## 5. Document Lifecycle

### 5.1 Status Definitions

| Status | Meaning |
|--------|---------|
| `Draft` | Under development, not finalized |
| `Review` | Ready for review, pending approval |
| `Active` | Approved and current |
| `Deprecated` | Superseded, kept for reference |
| `Archived` | No longer maintained |

### 5.2 Version Header (Required)

All documents MUST include:

```markdown
> **Version**: X.Y.Z
> **Status**: Draft | Review | Active | Deprecated | Archived
> **Created**: YYYY-MM-DD
> **Last Updated**: YYYY-MM-DD
```

### 5.3 Version History (Required for L0-L2)

```markdown
## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-01-02 | Initial version | Author |
```

---

## 6. Naming Conventions

### 6.1 File Naming

| Type | Pattern | Example |
|------|---------|---------|
| PRD | `prd-{scope}.md` | `prd-backend.md` |
| System Architecture | `system-architecture.md` | `system-architecture.md` |
| Module Architecture | `ARCHITECTURE.md` | `ARCHITECTURE.md` |
| Feature Design | `{feature}-design.md` | `ai-memory-design.md` |
| Contract | `{resource}.yaml` | `tasks.yaml` |

### 6.2 Directory Structure

```
{project}/
├── docs/
│   ├── requirements/        # L0: Product requirements
│   │   └── prd-{project}.md
│   ├── architecture/        # L1: System architecture
│   │   └── system-architecture.md
│   └── DOC_HIERARCHY.md     # Optional: Project-specific overrides
│
├── {module}/
│   └── docs/
│       ├── requirements/    # L2: Module requirements (optional)
│       │   └── prd-{module}.md
│       ├── ARCHITECTURE.md  # L2: Module architecture (REQUIRED)
│       ├── architecture/    # L3: Detailed design
│       └── project-planning/
│           └── unified-progress-management.md
│
└── shared/
    └── contracts/           # L3: API contracts
```

### 6.3 Module Structure Standard (REQUIRED)

All modules (backend, mobile, etc.) MUST follow this structure:

```
{module}/
├── CLAUDE.md                    # AI agent configuration (REQUIRED)
└── docs/
    ├── ARCHITECTURE.md          # Module architecture entry (REQUIRED)
    ├── requirements/            # Module PRD (optional, if has business logic)
    │   └── prd-{module}.md
    ├── architecture/            # Detailed design documents
    │   └── {feature}-design.md
    ├── project-planning/        # Project management
    │   └── unified-progress-management.md
    └── guides/                  # Implementation guides (optional)
```

#### Required Files

| File | Purpose | When Required |
|------|---------|---------------|
| `CLAUDE.md` | AI agent entry point | Always |
| `docs/ARCHITECTURE.md` | Module architecture overview | Always |
| `docs/project-planning/unified-progress-management.md` | Progress tracking | When module has active development |

#### Optional Files

| File | Purpose | When to Create |
|------|---------|----------------|
| `docs/requirements/prd-{module}.md` | Module-specific PRD | When module has distinct business requirements |
| `docs/architecture/*.md` | Detailed designs | When complex features need separate documentation |
| `docs/guides/*.md` | Developer guides | When onboarding or reference guides are needed |

#### Special Module: shared

The `shared/` module has a simplified structure as it primarily contains contracts:

```
shared/
├── README.md                    # Module overview (serves as ARCHITECTURE.md)
├── contracts/                   # API contracts (OpenAPI specs)
│   └── {resource}.yaml
└── models/                      # Shared data models (optional)
```

### 6.4 Anti-Patterns (Avoid)

| Anti-Pattern | Problem | Correct Approach |
|--------------|---------|------------------|
| `docs/project-planning/architecture/` | Duplicates `docs/architecture/` | Use `docs/architecture/` only |
| `docs/{random-category}/` | Inconsistent organization | Use standard directories |
| Module-specific prefixes like `mo-*.md` | Namespace pollution | Plain descriptive names |
| Multiple architecture entry points | Confusion about source of truth | Single `ARCHITECTURE.md` |

---

## 7. Validation Rules

### 7.1 Automated Checks

| Rule | Description | Severity |
|------|-------------|----------|
| VERSION_HEADER | Document has version header | Error |
| UPWARD_REF | L1+ documents reference parent | Error |
| FILE_EXISTS | All referenced files exist | Error |
| NO_ORPHANS | All docs are referenced | Warning |
| NO_CYCLES | No circular references | Error |
| NAMING | Follows naming conventions | Warning |

### 7.2 Validation Checklist

- [ ] Document contains version header
- [ ] Document is in correct directory layer
- [ ] Upward references are complete and valid
- [ ] No orphan documents
- [ ] No circular references
- [ ] Naming follows conventions
- [ ] Status is valid and current

---

## 8. Migration Guide

### 8.1 When to Migrate

- Content belongs to different layer
- Module boundary changes
- Consolidation or splitting of documents

### 8.2 Migration Process

1. Create new document in target location
2. Copy/restructure relevant content
3. Add migration notice to source document
4. Update all referencing documents
5. Validate reference integrity

### 8.3 Migration Notice Template

```markdown
## Migration Notice

The following content has been migrated:

| Content | Target Document | Date |
|---------|-----------------|------|
| §X Section Name | `path/to/new-doc.md` | YYYY-MM-DD |

> **See**: `path/to/new-doc.md` for current content
```

---

## 9. Integration with Aria Methodology

### 9.1 Development Cycle Integration

Aria 将开发活动分为两个阶段：

#### Pre-Cycle: Requirements Management (需求管理 - 十步循环之前)

| Activity | Output | Owner |
|----------|--------|-------|
| Product requirements definition | PRD (L0) | Product Owner |
| System architecture design | System Architecture (L1) | Tech Lead |
| Requirements refinement | User Stories (ready status) | Product Owner + Dev |

> **Important**: PRD and System Architecture creation is a Pre-Cycle activity, NOT Phase A responsibility.

#### Ten-Step Cycle: Implementation (实现周期)

| Phase | Documentation Actions |
|-------|----------------------|
| Phase A | Select ready User Story, create OpenSpec (proposal.md, tasks.md) |
| Phase B | Create Module PRD/Architecture as needed |
| Phase C | Create detailed design, contracts |
| Phase D | Update version history, status |

### 9.2 Document Flow Relationship

```
PRD (L0) → System Architecture (L1) → User Stories → OpenSpec
产品需求     系统架构设计              可实现需求单元   技术实现方案
```

| Document | Purpose | Phase |
|----------|---------|-------|
| **PRD** | Business requirements and user value (What & Why) | Pre-Cycle |
| **System Architecture** | Technical design and decisions (How - System Level) | Pre-Cycle |
| **User Stories** | Fine-grained implementable requirement units | Pre-Cycle |
| **OpenSpec Specs** | Implementation requirements and scenarios (How - Implementation Level) | Ten-Step Cycle |

---

## 10. Related Documents

| Document | Path | Description |
|----------|------|-------------|
| System Architecture Spec | `standards/core/documentation/system-architecture-spec.md` | System Architecture document specification |
| UPM Spec | `standards/core/upm/unified-progress-management-spec.md` | Progress management specification |
| Ten-Step Cycle | `standards/core/ten-step-cycle/README.md` | Development cycle reference |

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.2.0 | 2026-01-04 | Added Pre-Cycle concept (§9.1), User Stories position (§2.3), fixed document flow (§9.2) | AI Assistant |
| 1.1.0 | 2026-01-03 | Added Module Structure Standard (§6.3), Required/Optional files, Anti-Patterns (§6.4) | AI Assistant |
| 1.0.0 | 2026-01-02 | Initial version - migrated from project DOC_HIERARCHY.md | AI Assistant |
