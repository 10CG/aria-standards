# Parent Field Linking Rules Specification

> **Version**: 1.0.0
> **Status**: Draft
> **Created**: 2025-12-19
> **Related OpenSpec**: clarify-phase-a-task-pipeline

## Overview

This document defines the detailed rules for how the `parent` field in `detailed-tasks.yaml` links back to section IDs in `tasks.md`, establishing traceability between coarse-grained functional checklists and fine-grained executable tasks.

## Purpose

The parent field linking mechanism ensures:
- **Traceability**: Each TASK-{NNN} can be traced back to its originating functional requirement
- **Progress Tracking**: Backward sync knows which tasks.md checkbox to update
- **Aggregation**: Multiple TASK-{NNN} entries can map to a single tasks.md item
- **Validation**: Orphaned tasks and broken references can be detected

## Parent Field Format

### Format Specification

```yaml
parent: "{section}.{subsection}"
```

**Components**:
- `section`: Integer representing the top-level section number (≥1)
- `subsection`: Integer representing the subsection number (≥1)
- Separator: Single period character (`.`)

**Examples**:
```yaml
Valid:
  parent: "1.1"      # Section 1, subsection 1
  parent: "2.5"      # Section 2, subsection 5
  parent: "10.3"     # Section 10, subsection 3

Invalid:
  parent: "1"        # Missing subsection
  parent: "1.1.1"    # Too many levels
  parent: "A.1"      # Non-numeric section
  parent: "1-1"      # Wrong separator
  parent: 1.1        # Not a string (YAML number)
```

### Type Constraints

```yaml
Field Type: string (must be quoted in YAML)
Pattern: ^\d+\.\d+$
Minimum Section: 1
Minimum Subsection: 1
Maximum Section: No limit (but typically 1-20)
Maximum Subsection: No limit (but typically 1-50)
```

## tasks.md Section ID Format

### Standard Format

Section IDs in tasks.md must follow this format to be linkable:

```markdown
## {Section}. {Section Title}

- [ ] {Section}.{Subsection} {Task Description}
```

**Example**:
```markdown
## 1. Database Setup

- [ ] 1.1 Add OTP secret column to users table
- [ ] 1.2 Create OTP verification logs table

## 2. Backend Implementation

- [ ] 2.1 Add OTP generation endpoint
- [ ] 2.2 Modify login flow to require OTP
```

### Section ID Requirements

```yaml
Section Number:
  - Must be integer ≥ 1
  - Sequential numbering recommended but not required
  - Can skip numbers (e.g., 1, 3, 5 is valid)

Subsection Number:
  - Must be integer ≥ 1
  - Should be sequential within a section
  - Restarts at 1 for each new section

Checkbox Format:
  - Must use standard markdown: - [ ]
  - Space required after checkbox: - [ ] not -[ ]

Section ID Position:
  - Must appear immediately after checkbox
  - Before task description
  - Format: {section}.{subsection}
```

## Linking Semantics

### One-to-One Mapping

**Definition**: Single TASK-{NNN} → Single tasks.md item

```yaml
# tasks.md
- [ ] 1.1 Add OTP secret column to users table

# detailed-tasks.yaml
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Add OTP secret column to users table
```

**Characteristics**:
- Simplest case
- Direct correspondence
- Backward sync straightforward

### One-to-Many Mapping

**Definition**: Single tasks.md item → Multiple TASK-{NNN} entries

```yaml
# tasks.md
- [ ] 2.1 Implement user authentication

# detailed-tasks.yaml
tasks:
  - id: TASK-005
    parent: "2.1"
    title: Design user data model

  - id: TASK-006
    parent: "2.1"
    title: Implement JWT auth service

  - id: TASK-007
    parent: "2.1"
    title: Create auth API endpoints
```

**Characteristics**:
- Complex task decomposed into multiple atomic tasks
- All TASK-{NNN} share same parent
- Backward sync: checkbox checked only when ALL tasks complete

**Backward Sync Rule**:
```yaml
Completion Logic:
  IF all tasks with parent="2.1" are completed THEN
    Check off tasks.md item 2.1
  ELSE
    Leave unchecked
```

### Many-to-One Mapping (Not Allowed)

**Definition**: Multiple tasks.md items → Single TASK-{NNN}

**Status**: ❌ Not permitted

**Reason**:
- Violates single responsibility principle
- Ambiguous progress tracking
- Backward sync conflict (which checkbox to update?)

**Example of Violation**:
```yaml
# tasks.md
- [ ] 1.1 Create user model
- [ ] 1.2 Add user validation

# detailed-tasks.yaml - WRONG!
tasks:
  - id: TASK-001
    parent: "1.1, 1.2"  # ❌ Multiple parents not allowed
```

**Correct Approach**: Create separate TASK-{NNN} for each parent
```yaml
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Create user model

  - id: TASK-002
    parent: "1.2"
    title: Add user validation
```

## Validation Rules

### Structural Validation

```yaml
Rule: parent_field_exists
  Level: Error
  Check: Every task in detailed-tasks.yaml must have a parent field
  Message: "Task {task_id} missing required 'parent' field"

Rule: parent_field_format
  Level: Error
  Check: parent matches pattern ^\d+\.\d+$
  Message: "Task {task_id} has invalid parent format: {parent}"

Rule: parent_field_type
  Level: Error
  Check: parent is string type in YAML
  Message: "Task {task_id} parent must be quoted string"
```

### Referential Integrity Validation

```yaml
Rule: parent_references_exist
  Level: Error
  Check: parent value exists in tasks.md
  Process:
    1. Extract parent value (e.g., "1.1")
    2. Search tasks.md for "- [ ] 1.1" or "- [x] 1.1"
    3. Verify match found
  Message: "Task {task_id} references non-existent parent {parent}"

Rule: no_orphaned_tasks
  Level: Warning
  Check: All TASK-{NNN} have valid parent references
  Action: List orphaned tasks for review
  Message: "Found {count} orphaned tasks: {task_ids}"

Rule: all_sections_covered
  Level: Info
  Check: All tasks.md items have at least one TASK-{NNN}
  Action: List uncovered sections
  Message: "Sections without tasks: {section_ids}"
```

### Consistency Validation

```yaml
Rule: task_count_reasonable
  Level: Warning
  Check: One-to-many mappings have reasonable task count
  Threshold: 1-10 tasks per parent
  Message: "Parent {parent} has {count} tasks (>10)"

Rule: title_consistency
  Level: Info
  Check: TASK title relates to parent description
  Method: Manual review recommended
  Guidance: Task titles should expand on parent description
```

## Parent Field Generation

### A.2 Task Planning - task-planner Skill

**Responsibility**: Generate parent field when creating TASK-{NNN}

**Algorithm**:
```yaml
For each item in tasks.md:
  1. Extract section ID (e.g., "1.1")
  2. Analyze task complexity
  3. If task is atomic (4-8 hours):
       Create single TASK-{NNN}
       Set parent = section_id
  4. If task is complex (>8 hours):
       Decompose into N atomic tasks
       For each atomic task:
         Create TASK-{NNN}
         Set parent = section_id (same for all)
  5. Add to detailed-tasks.yaml
```

**Example Generation**:
```yaml
Input (tasks.md):
  - [ ] 1.1 Implement user authentication

Analysis:
  - Complex task (estimated 12-16 hours)
  - Decompose into 3 atomic tasks

Output (detailed-tasks.yaml):
  tasks:
    - id: TASK-001
      parent: "1.1"  # ← Generated
      title: Design user data model
      complexity: M (Medium, 2-4h)

    - id: TASK-002
      parent: "1.1"  # ← Generated
      title: Implement JWT auth service
      complexity: L (Large, 4-8h)

    - id: TASK-003
      parent: "1.1"  # ← Generated
      title: Create auth API endpoints
      complexity: M (Medium, 2-4h)
```

## Backward Sync Using Parent Field

### B.2 Execution - task-progress-updater Skill

**Responsibility**: Update tasks.md checkboxes when TASK-{NNN} completes

**Algorithm**:
```yaml
When TASK-{NNN} completes and passes verification:
  1. Read task's parent field
  2. Find all tasks with same parent
  3. Check completion status of all sibling tasks
  4. If ALL siblings completed:
       Locate parent checkbox in tasks.md
       Update: - [ ] → - [x]
       Add completion note (optional)
  5. If ANY sibling incomplete:
       Leave parent checkbox unchecked
```

**Example - Single Task**:
```yaml
Scenario: One-to-one mapping

TASK-001 completes:
  parent: "1.1"

Check siblings with parent="1.1":
  - TASK-001: completed ✓

All siblings complete → Update tasks.md:
  - [x] 1.1 Add OTP secret column to users table
```

**Example - Multiple Tasks**:
```yaml
Scenario: One-to-many mapping (3 tasks)

TASK-005 completes:
  parent: "2.1"

Check siblings with parent="2.1":
  - TASK-005: completed ✓
  - TASK-006: in_progress
  - TASK-007: pending

NOT all complete → Leave unchecked:
  - [ ] 2.1 Implement user authentication

---

TASK-006 completes later:
  parent: "2.1"

Check siblings:
  - TASK-005: completed ✓
  - TASK-006: completed ✓
  - TASK-007: pending

Still not all complete → Still unchecked

---

TASK-007 completes:
  parent: "2.1"

Check siblings:
  - TASK-005: completed ✓
  - TASK-006: completed ✓
  - TASK-007: completed ✓

ALL complete → Update tasks.md:
  - [x] 2.1 Implement user authentication
```

## Edge Cases and Error Handling

### Case 1: Parent Not Found

**Scenario**: TASK-{NNN} references non-existent parent

```yaml
tasks:
  - id: TASK-042
    parent: "5.3"  # But tasks.md has no section 5.3

Detection:
  - Validation tool scans tasks.md
  - Section "5.3" not found

Resolution Options:
  Option A - Fix parent field:
    - Identify correct parent from task title
    - Update parent field

  Option B - Add section to tasks.md:
    - If task is valid but tasks.md incomplete
    - Add missing section 5.3

  Option C - Remove orphaned task:
    - If task is invalid
    - Delete TASK-042
```

### Case 2: Duplicate Parent Sections

**Scenario**: tasks.md has duplicate section IDs

```yaml
tasks.md (WRONG):
  ## 1. Database Setup
  - [ ] 1.1 Add column

  ## 2. API Implementation
  - [ ] 1.1 Create endpoint  # ← Duplicate ID!

Detection:
  - Validation tool scans tasks.md
  - Finds multiple "1.1" sections

Resolution:
  - Renumber duplicate sections
  - Update parent fields in detailed-tasks.yaml accordingly
  - Recommended: Use sequential numbering (1.1, 1.2, 2.1, 2.2...)
```

### Case 3: Section Renumbering

**Scenario**: tasks.md sections are renumbered

```yaml
Before:
  tasks.md:
    - [ ] 1.1 Task A
    - [ ] 1.2 Task B
    - [ ] 2.1 Task C

  detailed-tasks.yaml:
    - id: TASK-001
      parent: "1.1"

After Renumbering:
  tasks.md:
    - [ ] 1.1 Task A
    - [ ] 2.1 Task B  # ← Was 1.2, now 2.1
    - [ ] 3.1 Task C  # ← Was 2.1, now 3.1

Impact:
  - TASK-001 still valid (1.1 unchanged)
  - Tasks with parent="1.2" now orphaned
  - Tasks with parent="2.1" reference wrong section

Prevention:
  - Avoid renumbering after A.2 completion
  - If renumbering needed:
    1. Update tasks.md
    2. Update parent fields in detailed-tasks.yaml
    3. Re-validate referential integrity
```

### Case 4: Missing Subsection Numbers

**Scenario**: tasks.md uses section-only format

```yaml
tasks.md (Non-standard):
  ## 1. Database Setup
  - [ ] Add OTP column       # ← No section ID!
  - [ ] Create logs table    # ← No section ID!

Problem:
  - Cannot generate parent field
  - No unique identifier for linking

Resolution:
  - Add subsection numbers to tasks.md:
    - [ ] 1.1 Add OTP column
    - [ ] 1.2 Create logs table
  - Then generate parent fields:
    parent: "1.1"
    parent: "1.2"
```

## Validation Tool Specification

### Required Checks

```yaml
Check 1: Format Validation
  - Verify all parent fields match ^\d+\.\d+$
  - Verify all parent fields are strings

Check 2: Reference Validation
  - Verify all parent values exist in tasks.md
  - Report orphaned tasks

Check 3: Coverage Validation
  - List tasks.md items without TASK-{NNN}
  - Report as informational

Check 4: Duplicate Detection
  - Detect duplicate section IDs in tasks.md
  - Report as error

Check 5: Consistency Check
  - Verify task titles relate to parent description
  - Report as informational
```

### Validation Output Format

```yaml
Validation Report:

  ✅ Format Validation: PASSED
     All 15 tasks have valid parent format

  ✅ Reference Validation: PASSED
     All parent references exist in tasks.md

  ⚠️  Coverage Validation: WARNING
     3 tasks.md items have no TASK-{NNN}:
       - Section 3.2: Document API changes
       - Section 4.1: Create integration tests
       - Section 4.3: Update deployment guide

  ❌ Duplicate Detection: ERROR
     Duplicate section ID found:
       - "2.1" appears at lines 15 and 42

  ℹ️  Consistency Check: INFO
     Review recommended for:
       - TASK-007 title doesn't clearly relate to parent "1.3"
```

## Related Documents

- [Detailed Tasks YAML Format](./detailed-tasks-yaml-format.md) - Full field specification
- [Task Synchronization Mechanism](./task-synchronization-spec.md) - Forward and backward sync
- [Phase A: Planning](../../core/ten-step-cycle/phase-a-spec-planning.md) - Context for A.2 task planning
- [Phase B: Development](../../core/ten-step-cycle/phase-b-development.md) - Context for B.2 execution

---

**Version**: 1.0.0
**Created**: 2025-12-19
**Maintainer**: AI-DDD Development Team
