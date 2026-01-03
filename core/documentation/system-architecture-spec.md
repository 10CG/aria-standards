# System Architecture Document Specification

> **Version**: 1.1.0
> **Status**: Active
> **Created**: 2026-01-02
> **Last Updated**: 2026-01-04
> **Methodology**: Aria (AI-DDD v3.0)

---

## 1. Overview

This specification defines the structure, content, and validation rules for System Architecture documents in Aria methodology projects.

### 1.1 Purpose

A System Architecture document:
- Bridges product requirements (PRD) and implementation specifications (OpenSpec)
- Defines technical architecture at the system level
- Documents key technology decisions and trade-offs
- Establishes module boundaries and integration patterns

### 1.2 Positioning

```
┌─────────────────────────────────────────────────────────────┐
│  L0: PRD (Product Requirements)                             │
│      "WHAT we build and WHY"                                │
│      - Business goals, user value, feature scope            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  L1: System Architecture                                    │
│      "HOW the system is organized"                          │
│      - Technical architecture, module boundaries            │
│      - Technology decisions, cross-cutting concerns         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  L2-L3: Module Architecture + OpenSpec Specs                │
│      "HOW each part is implemented"                         │
│      - Module design, API contracts, implementation specs   │
└─────────────────────────────────────────────────────────────┘
```

### 1.3 Terminology Note

This document type replaces the former "RPD (Requirements Planning Document)" terminology. The new name better reflects its purpose as a technical architecture document rather than a requirements document.

### 1.4 Development Phase

System Architecture creation is a **Pre-Cycle** activity in Aria methodology:

| Aspect | Description |
|--------|-------------|
| **Phase** | Pre-Cycle (before Ten-Step Cycle) |
| **NOT** | Phase A (Phase A focuses on OpenSpec for specific features) |
| **Purpose** | Establish technical constraints for User Stories and OpenSpec |
| **Update Frequency** | Per major release or significant architecture change |

> **Important**: System Architecture is created BEFORE entering Ten-Step Cycle, not during Phase A.

---

## 2. Document Location

### 2.1 Standard Location

```
{project}/
└── docs/
    └── architecture/
        └── system-architecture.md    # Primary system architecture
```

### 2.2 File Naming

| Level | Pattern | Example |
|-------|---------|---------|
| System | `system-architecture.md` | `system-architecture.md` |
| Domain | `{domain}-architecture.md` | `ai-memory-architecture.md` |

---

## 3. Required Sections

### 3.1 Document Structure

```markdown
# {Project Name} System Architecture

> **Version**: X.Y.Z
> **Status**: Active
> **Created**: YYYY-MM-DD
> **Parent Document**: `docs/requirements/prd-{project}.md`

---

## 1. Executive Summary
## 2. System Overview
## 3. Architecture Diagram
## 4. Module Boundaries
## 5. Technology Decisions
## 6. Cross-Cutting Concerns
## 7. Data Architecture
## 8. Integration Patterns
## 9. Evolution Roadmap
## 10. Related Documents

---

## Version History
```

### 3.2 Section Details

#### 3.2.1 Executive Summary

```yaml
Purpose: One-page overview for quick understanding
Length: 200-500 words
Content:
  - System purpose (link to PRD)
  - Core architecture pattern
  - Key technology choices
  - Module overview
```

#### 3.2.2 System Overview

```yaml
Purpose: High-level system description
Content:
  - System goals and constraints
  - Key stakeholders
  - Quality attributes (performance, security, etc.)
  - Assumptions and dependencies
```

#### 3.2.3 Architecture Diagram

```yaml
Purpose: Visual representation of system structure
Required Diagrams:
  - System context diagram (C4 Level 1)
  - Container diagram (C4 Level 2)
Format: ASCII art or Mermaid (for version control)
```

Example:
```
┌─────────────────────────────────────────────────────────────┐
│                        System Name                           │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────────────────┐  │
│  │  Mobile  │◄──►│  Backend │◄──►│  External Services   │  │
│  └──────────┘    └──────────┘    └──────────────────────┘  │
│       ↑              ↑                    ↑                 │
│       └──────────────┴────────────────────┘                 │
│                    Shared Contracts                          │
└─────────────────────────────────────────────────────────────┘
```

#### 3.2.4 Module Boundaries

```yaml
Purpose: Define clear module responsibilities
Content:
  - Module list with responsibilities
  - Boundary definitions (what belongs where)
  - Inter-module communication patterns
  - Shared components location
```

Format:
```markdown
| Module | Responsibility | Owns | Uses |
|--------|----------------|------|------|
| Mobile | UI, offline-first | User interaction | Backend API |
| Backend | API, data storage | Business logic | External APIs |
| Shared | Contracts | API specs | - |
```

#### 3.2.5 Technology Decisions

```yaml
Purpose: Document and justify technology choices
Format: ADR-lite (Architecture Decision Record)
Content:
  - Decision ID
  - Context
  - Decision
  - Rationale
  - Consequences
```

Example:
```markdown
### TD-001: AI Memory Framework Selection

**Context**: Need AI memory management for user context
**Decision**: Mem0 + Zep + HippoRAG + Triplex + pgvector
**Rationale**:
- Mem0: Memory coordination
- Zep: Temporal knowledge graph
- HippoRAG: Multi-hop retrieval
**Consequences**: Requires self-hosted deployment
```

#### 3.2.6 Cross-Cutting Concerns

```yaml
Purpose: Document system-wide patterns
Topics:
  - Authentication & Authorization
  - Logging & Monitoring
  - Error Handling
  - Security (encryption, privacy)
  - Performance requirements
  - Deployment architecture
```

#### 3.2.7 Data Architecture

```yaml
Purpose: Define data management approach
Content:
  - Data stores (databases, caches)
  - Data flow diagrams
  - Data ownership
  - Synchronization strategy
  - Privacy and compliance
```

#### 3.2.8 Integration Patterns

```yaml
Purpose: Define how modules communicate
Content:
  - API patterns (REST, GraphQL, gRPC)
  - Event-driven patterns
  - Sync vs async communication
  - Contract location (shared/contracts/)
```

#### 3.2.9 Evolution Roadmap

```yaml
Purpose: Planned architecture evolution
Content:
  - Phase definitions aligned with PRD
  - Architecture milestones
  - Technology migration plans
  - Scalability considerations
```

#### 3.2.10 Related Documents

```yaml
Purpose: Navigation to related documentation
Required References:
  - Parent PRD
  - Module architectures
  - OpenSpec changes
  - API contracts
```

---

## 4. Validation Rules

### 4.1 Required Elements

| Element | Validation | Severity |
|---------|------------|----------|
| Version Header | Must include Version, Status, Created | Error |
| Parent Reference | Must reference PRD | Error |
| Architecture Diagram | At least one diagram present | Error |
| Module Boundaries | Must list all modules | Warning |
| Technology Decisions | At least one decision documented | Warning |

### 4.2 Content Rules

| Rule | Description |
|------|-------------|
| ARCH_DIAGRAM | Contains at least one ASCII/Mermaid diagram |
| TECH_DECISIONS | Contains Technology Decisions section |
| MODULE_LIST | Lists all project modules |
| PARENT_REF | References parent PRD |
| VERSION_HEADER | Has complete version header |

### 4.3 Validation Checklist

```markdown
## System Architecture Validation Checklist

### Structure
- [ ] Version header complete (Version, Status, Created)
- [ ] Parent document reference present
- [ ] All required sections present
- [ ] Version history maintained

### Content
- [ ] Executive summary is concise (<500 words)
- [ ] At least one architecture diagram included
- [ ] All modules listed with clear boundaries
- [ ] Technology decisions documented with rationale
- [ ] Cross-cutting concerns addressed

### References
- [ ] Parent PRD exists and is linked
- [ ] Related module architectures linked
- [ ] No broken references
```

---

## 5. Relationship to Other Documents

### 5.1 Upstream: PRD

```yaml
System Architecture MUST:
  - Reference parent PRD
  - Align with PRD goals and scope
  - Support PRD version roadmap

System Architecture MUST NOT:
  - Define business requirements (that's PRD)
  - Change scope without PRD update
```

### 5.2 Downstream: Module Architecture

```yaml
Module Architecture MUST:
  - Reference parent System Architecture
  - Align with module boundaries defined here
  - Use technology decisions from here

Module Architecture MAY:
  - Extend with module-specific decisions
  - Add detail within boundaries
```

### 5.3 Peer: OpenSpec Specs

```yaml
Relationship: Complementary, not overlapping

System Architecture:
  - Defines HOW the system is organized
  - Documents DECISIONS and their rationale
  - Static structure, evolves slowly

OpenSpec Specs:
  - Defines WHAT to implement (requirements, scenarios)
  - Documents SPECIFICATIONS for features
  - Active during development, archived after
```

### 5.4 Output: User Stories

```yaml
Relationship: System Architecture constrains User Stories

System Architecture provides:
  - Technical boundaries for story scope
  - Module assignment for implementation
  - Non-functional requirements as acceptance criteria

User Stories MUST:
  - Respect module boundaries defined here
  - Reference architectural constraints when relevant
  - Be created during Pre-Cycle phase
```

---

## 6. Examples

### 6.1 Good Example Structure

```markdown
# Chunfeng Xuntiansi System Architecture

> **Version**: 1.1.0
> **Status**: Active
> **Created**: 2026-01-02
> **Last Updated**: 2026-01-04
> **Parent Document**: `docs/requirements/prd-todo-app-v1.md`

## 1. Executive Summary

Chunfeng Xuntiansi is a personal productivity system with AI-powered memory...
[200-500 words overview]

## 2. System Overview
[Quality attributes, constraints, stakeholders]

## 3. Architecture Diagram
[ASCII/Mermaid diagrams]

## 4. Module Boundaries
[Table of modules and responsibilities]

## 5. Technology Decisions
[TD-001, TD-002, etc.]

## 6. Cross-Cutting Concerns
[Security, logging, error handling]

## 7. Data Architecture
[Data stores, flow, privacy]

## 8. Integration Patterns
[API patterns, contracts]

## 9. Evolution Roadmap
[Phase 1-4 architecture evolution]

## 10. Related Documents
[Links to module docs, PRD, contracts]

---

## Version History
| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-01-02 | Initial version | Team |
```

---

## 7. Anti-Patterns

### 7.1 Avoid These

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| PRD content in Architecture | Mixing business and technical concerns | Keep requirements in PRD |
| No diagrams | Hard to understand structure | Always include diagrams |
| Technology without rationale | Decisions seem arbitrary | Document context and reasoning |
| Stale version | Misleading information | Update with changes |
| Module boundary violations | Unclear ownership | Enforce boundaries strictly |

---

## 8. Related Documents

| Document | Path | Description |
|----------|------|-------------|
| Product Doc Hierarchy | `standards/core/documentation/product-doc-hierarchy.md` | Documentation layers |
| Ten-Step Cycle | `standards/core/ten-step-cycle/README.md` | Development cycle |
| Phase A Spec Planning | `standards/core/ten-step-cycle/phase-a-spec-planning.md` | Planning phase |

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.1.0 | 2026-01-04 | Added Pre-Cycle concept (§1.4), User Stories relationship (§5.4) | AI Assistant |
| 1.0.0 | 2026-01-02 | Initial version | AI Assistant |
