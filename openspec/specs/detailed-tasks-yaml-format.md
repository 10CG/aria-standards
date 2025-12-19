# detailed-tasks.yaml Format Specification

> **Version**: 1.0.0
> **Status**: Draft
> **Created**: 2025-12-19
> **Related OpenSpec**: clarify-phase-a-task-pipeline

## Overview

This document defines the formal specification for `detailed-tasks.yaml`, the fine-grained executable task document generated in Phase A Step 2 (A.2 Task Planning) of the AI-DDD Ten-Step Cycle.

## Purpose

The `detailed-tasks.yaml` file serves as:
- **AI execution basis**: Single source of truth for task implementation
- **Scheduling foundation**: Enables dependency-based scheduling and parallel execution
- **Progress tracking**: Provides granular task status and completion tracking
- **Traceability**: Links back to coarse-grained tasks.md via parent field

## File Location

```
standards/openspec/changes/{feature}/detailed-tasks.yaml
```

## Format

### Root Structure

```yaml
# Optional metadata
metadata:
  feature: string              # Feature name
  created: YYYY-MM-DD         # Creation date
  updated: YYYY-MM-DD         # Last update date
  spec: string                # Path to proposal.md

# Required task list
tasks:
  - id: string                # TASK-{NNN} format
    parent: string            # Section ID from tasks.md
    title: string             # Task title
    complexity: string        # S/M/L/XL with hour range
    dependencies: array       # List of TASK-{NNN} IDs
    deliverables: array       # File paths
    agent: string             # Agent type (A.3 adds this)
    reason: string            # Assignment rationale (A.3 adds this)
    verification: array       # Verification criteria (A.3 adds this)
```

## Field Specifications

### Required Fields (A.2 Output)

#### `id`
- **Type**: `string`
- **Format**: `TASK-{NNN}` where NNN is zero-padded 3-digit number
- **Example**: `TASK-001`, `TASK-042`
- **Constraint**: Must be unique within the file
- **Purpose**: Unique task identifier for dependency tracking

#### `parent`
- **Type**: `string`
- **Format**: `"{section}.{subsection}"` matching tasks.md numbering
- **Example**: `"1.1"`, `"2.3"`
- **Constraint**: Must reference valid section in tasks.md
- **Purpose**: Links detailed task back to coarse-grained checklist item

#### `title`
- **Type**: `string`
- **Format**: Imperative sentence describing the task
- **Example**: `"Add OTP secret column to users table"`
- **Constraint**: Should be clear and actionable
- **Purpose**: Human-readable task description

#### `complexity`
- **Type**: `string`
- **Format**: `"{SIZE} ({Label}, {range}h)"`
- **Valid Sizes**:
  - `S` (Small, 1-2h)
  - `M` (Medium, 2-4h)
  - `L` (Large, 4-8h)
  - `XL` (Extra Large, 8+ hours, should be split)
- **Example**: `"M (Medium, 2-4h)"`
- **Constraint**: XL tasks should be decomposed
- **Purpose**: Time estimation and capacity planning

#### `dependencies`
- **Type**: `array of string`
- **Format**: List of TASK-{NNN} IDs
- **Example**: `[TASK-001, TASK-002]` or `[]` for no dependencies
- **Constraint**:
  - Must reference valid task IDs in same file
  - No circular dependencies
  - Forms a Directed Acyclic Graph (DAG)
- **Purpose**: Defines execution order and enables parallel scheduling

#### `deliverables`
- **Type**: `array of string`
- **Format**: File paths relative to repository root
- **Example**:
  ```yaml
  deliverables:
    - backend/migrations/add_otp_secret_column.sql
    - backend/src/models/user.py
  ```
- **Constraint**: Paths should be precise file-level specifications
- **Purpose**: Defines tangible outputs and enables file-based progress tracking

### Enhanced Fields (A.3 Output)

#### `agent`
- **Type**: `string`
- **Format**: Agent type identifier
- **Valid Values**:
  - `backend-architect`
  - `mobile-developer`
  - `qa-engineer`
  - `api-documenter`
  - `knowledge-manager`
  - `tech-lead`
  - `ui-ux-designer`
- **Example**: `"backend-architect"`
- **Added By**: A.3 (Agent Assignment)
- **Purpose**: Specifies which specialized agent should execute the task

#### `reason`
- **Type**: `string`
- **Format**: Brief explanation of agent assignment
- **Example**: `"Database schema design expertise, migration management"`
- **Added By**: A.3 (Agent Assignment)
- **Purpose**: Provides rationale for agent selection based on required expertise

#### `verification`
- **Type**: `array of string`
- **Format**: List of verification criteria
- **Example**:
  ```yaml
  verification:
    - Migration runs successfully
    - Column exists in schema with correct type
    - User model updated and tests pass
  ```
- **Added By**: A.3 (Agent Assignment)
- **Purpose**: Defines task-specific quality gates and completion criteria

## Complete Example

```yaml
metadata:
  feature: user-authentication-otp
  created: 2025-12-19
  updated: 2025-12-19
  spec: standards/openspec/changes/user-auth-otp/proposal.md

tasks:
  - id: TASK-001
    parent: "1.1"
    title: Add OTP secret column to users table
    complexity: M (Medium, 2-4h)
    dependencies: []
    deliverables:
      - backend/migrations/add_otp_secret_column.sql
      - backend/src/models/user.py
    agent: backend-architect
    reason: Database schema design expertise, migration management
    verification:
      - Migration runs successfully
      - Column exists in schema with correct type
      - User model updated and tests pass

  - id: TASK-002
    parent: "2.1"
    title: Create OTP generation endpoint
    complexity: L (Large, 4-8h)
    dependencies: [TASK-001]
    deliverables:
      - backend/src/routes/otp_routes.py
      - backend/src/services/otp_service.py
    agent: backend-architect
    reason: API design, security, and authentication expertise
    verification:
      - Unit tests pass with >85% coverage
      - No security warnings from linter
      - OpenAPI spec generated correctly

  - id: TASK-003
    parent: "2.2"
    title: Implement token validation middleware
    complexity: M (Medium, 2-4h)
    dependencies: [TASK-002]
    deliverables:
      - backend/src/middleware/auth_middleware.py
    agent: backend-architect
    reason: Middleware implementation, security patterns
    verification:
      - Middleware intercepts requests correctly
      - Token validation logic tested
      - Error handling covers edge cases

  - id: TASK-004
    parent: "3.1"
    title: Add unit tests for authentication
    complexity: M (Medium, 2-4h)
    dependencies: [TASK-003]
    deliverables:
      - backend/tests/test_auth_routes.py
      - backend/tests/test_auth_service.py
    agent: qa-engineer
    reason: Test coverage optimization, quality assurance
    verification:
      - Coverage >= 85% for auth module
      - All edge cases covered
      - Integration tests pass
```

## Validation Rules

### Structural Validation

1. **File Format**: Must be valid YAML
2. **Required Keys**: `tasks` array must exist
3. **Task ID Uniqueness**: All `id` values must be unique
4. **Dependency Validity**: All referenced task IDs in `dependencies` must exist
5. **No Cycles**: Dependency graph must be acyclic (DAG)

### Field Validation

1. **ID Format**: Must match `^TASK-\d{3}$` regex
2. **Parent Format**: Must match `^\d+\.\d+$` regex (section.subsection)
3. **Complexity Format**: Must be one of `S (Small, 1-2h)`, `M (Medium, 2-4h)`, `L (Large, 4-8h)`
4. **Dependencies**: Must be array (can be empty)
5. **Deliverables**: Must be non-empty array of strings

### Semantic Validation

1. **Parent Linkage**: Each `parent` value should reference an existing section in tasks.md
2. **Complexity Appropriateness**: Tasks >8h should be flagged for decomposition
3. **Deliverable Realism**: File paths should follow project structure conventions
4. **Agent Suitability**: Agent type should match task domain (validated in A.3)

## Lifecycle

### A.2 Generation

The `task-planner` skill generates this file during Phase A Step 2:

1. Reads coarse-grained tasks.md
2. Transforms each checklist item into one or more TASK-{NNN} entries
3. Assigns TASK-{NNN} IDs sequentially
4. Sets `parent` field to link back to tasks.md section
5. Estimates `complexity` based on task analysis
6. Determines `dependencies` from task relationships
7. Specifies file-level `deliverables`

### A.3 Enhancement

Phase A Step 3 enhances the file with agent assignment:

1. Reads detailed-tasks.yaml generated by A.2
2. Analyzes task type, domain, and complexity
3. Adds `agent` field with suitable agent type
4. Adds `reason` field explaining assignment rationale
5. Adds `verification` field with task-specific quality gates

### B.2 Execution Tracking

During Phase B Step 2 (执行验证):

1. Tasks are executed based on dependency order
2. Status tracked externally (not in this file)
3. When TASK-{NNN} completes, corresponding tasks.md item checked off
4. Deliverables verified against specification

## Related Documents

- [Phase A: Planning (规划)](../../core/ten-step-cycle/phase-a-spec-planning.md) - Context for A.2 and A.3
- [tasks.md Format](./tasks-md-format.md) - Coarse-grained checklist format
- [Synchronization Mechanism](./task-synchronization-spec.md) - Forward and backward sync rules
- [Parent Field Linking Rules](./parent-field-linking-spec.md) - Detailed linking specification

---

**Version**: 1.0.0
**Created**: 2025-12-19
**Maintainer**: AI-DDD Development Team
