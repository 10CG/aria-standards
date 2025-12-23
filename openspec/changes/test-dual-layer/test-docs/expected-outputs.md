# Expected Outputs Reference

> **Test Case**: test-dual-layer
> **Purpose**: Centralized reference for expected validation command outputs
> **Last Updated**: 2025-12-22

---

## Overview

This document consolidates all expected command outputs for the dual-layer architecture test case, providing a quick reference for validation execution and result verification.

---

## Validation Commands

### 1. Numbering Validation (Success)

**Command**: `openspec validate --numbering test-dual-layer`

**Expected Output**:
```
✓ Numbering validation passed
  - Format: {phase}.{task} correct
  - Sequential: All phases sequential (1, 2, 3, 4)
  - No duplicates detected
  - 12 tasks validated
```

**Context**: Valid tasks.md with proper `{phase}.{task}` numbering format

---

### 2. Numbering Validation (Duplicate Numbers)

**Command**: `openspec validate --numbering test-dual-layer`

**Expected Output**:
```
✗ Numbering validation failed
  - Error: Duplicate task number detected: 1.1
  - Line 5: "1.1 Create test documentation directory"
  - Line 6: "1.1 Initialize validation test framework"
  - Action required: Renumber duplicate task
```

**Context**: tasks.md with duplicate numbering (1.1 appears twice)

---

### 3. Numbering Validation (Wrong Format)

**Command**: `openspec validate --numbering test-dual-layer`

**Expected Output**:
```
✗ Numbering validation failed
  - Error: Invalid numbering format at line 5
  - Expected: {phase}.{task} (e.g., "1.1")
  - Found: "1"
  - Action required: Fix numbering format
```

**Context**: tasks.md with incorrect numbering format (missing task number)

---

### 4. Phase Grouping Warning

**Command**: `openspec validate --numbering test-dual-layer`

**Expected Output**:
```
⚠ Phase grouping warning
  - Warning: Task 2.1 appears under Phase 1 header
  - Expected: Task 2.1 should be under Phase 2 header
  - Location: Line 7
```

**Context**: Task with Phase 2 numbering appears under Phase 1 header

---

### 5. Checkbox Format Error

**Command**: `openspec validate --numbering test-dual-layer`

**Expected Output**:
```
✗ Checkbox validation failed
  - Error: Invalid checkbox format at line 8
  - Expected: "- [ ]" or "- [x]" or "- [X]"
  - Found: "- [-]"
  - Action required: Fix checkbox format
```

**Context**: tasks.md with invalid checkbox format `- [-]`

---

## Layer 2 Validation

### 6. YAML Syntax Validation (Success)

**Command**: `yamllint test-dual-layer/detailed-tasks.yaml`

**Expected Output**:
```
(No output - indicates no errors)
```

**Context**: Valid YAML file with correct syntax

---

### 7. TASK ID Format Validation (Invalid)

**Command**: `openspec validate --sync test-dual-layer`

**Expected Output**:
```
✗ TASK ID validation failed
  - Error: Invalid ID format "TASK-1" at task index 0
    Expected: TASK-{NNN} with 3-digit zero-padding (e.g., TASK-001)
  - Error: Invalid ID format "TSK-002" at task index 1
    Expected: Prefix must be "TASK-"
```

**Context**: detailed-tasks.yaml with incorrect ID formats (TASK-1, TSK-002)

---

### 8. Parent Reference Validation (Success)

**Command**: `openspec validate --sync test-dual-layer`

**Expected Output**:
```
✓ Synchronization validated
  - All 12 tasks have valid parent references
  - Parent references match tasks.md numbering
  - No orphaned tasks detected
```

**Context**: All parent references in detailed-tasks.yaml correctly match tasks.md

---

### 9. Parent Reference Validation (Orphaned Task)

**Command**: `openspec validate --sync test-dual-layer`

**Expected Output**:
```
✗ Synchronization validation failed
  - Error: Orphaned task detected
    - TASK-004 references parent "1.4"
    - No task numbered 1.4 found in tasks.md
  - Action required: Fix parent reference or add task to tasks.md
```

**Context**: TASK-004 has parent "1.4" but no 1.4 exists in tasks.md

---

### 10. Metadata Completeness Validation (Missing Fields)

**Command**: `openspec validate --sync test-dual-layer`

**Expected Output**:
```
✗ Metadata validation failed
  - Error: TASK-001 missing required fields:
    - status (required)
    - complexity (required)
    - dependencies (required, can be empty array)
    - agent (required)
    - deliverables (required)
    - verification (required)
```

**Context**: TASK-001 missing required metadata fields

---

## Synchronization Validation

### 11. Forward Sync Success

**Command**: Task-planner skill execution

**Expected Output**:
```
✓ Forward sync completed
  - Parsed 12 tasks from tasks.md
  - Generated 12 TASK-{NNN} entries
  - All parent references valid
  - No errors detected
```

**Context**: task-planner successfully generates detailed-tasks.yaml from tasks.md

---

### 12. Backward Sync Success

**Command**: Progress-updater skill execution

**Expected Output**:
```
✓ Backward sync completed
  - Updated 1 checkbox in tasks.md
  - TASK-001 marked as completed → 1.1 checkbox set to [x]
  - No errors detected
```

**Context**: progress-updater successfully syncs completion status to tasks.md

**tasks.md Before**:
```markdown
- [ ] 1.1 Create test documentation directory
```

**tasks.md After**:
```markdown
- [x] 1.1 Create test documentation directory
```

---

### 13. Numbering Immutability Conflict

**Command**: `openspec validate --sync test-dual-layer`

**Expected Output**:
```
✗ Synchronization validation failed
  - Error: Numbering immutability constraint violated
    - TASK-001 parent reference "1.1" points to different task
    - Expected title: "Create test documentation directory"
    - Found title: "Initialize validation test framework"
  - Error: Parent reference mismatch detected for TASK-002
  - Action required: Restore original numbering or regenerate detailed-tasks.yaml
```

**Context**: tasks.md numbering was changed after detailed-tasks.yaml creation

**Original tasks.md**:
```markdown
- [ ] 1.1 Create test documentation directory
- [ ] 1.2 Initialize validation test framework
```

**Modified tasks.md (INCORRECT)**:
```markdown
- [ ] 1.1 Initialize validation test framework  ← Was 1.2
- [ ] 1.2 Create test documentation directory   ← Was 1.1
```

---

### 14. Missing Parent Reference

**Command**: `openspec validate --sync test-dual-layer`

**Expected Output**:
```
✗ Synchronization validation failed
  - Error: Orphaned task reference detected
    - TASK-002 references parent "1.2"
    - Task 1.2 not found in tasks.md
  - Suggestion: Either restore task 1.2 in tasks.md or remove TASK-002 from detailed-tasks.yaml
```

**Context**: Task 1.2 deleted from tasks.md but TASK-002 still references it

---

## Edge Case Validation

### 15. Empty Phase Warning

**Command**: `openspec validate --numbering test-dual-layer`

**Expected Output**:
```
⚠ Warning: Empty phase detected
  - Phase 5 header exists but contains no tasks
  - This may indicate incomplete planning
```

**Context**: Phase 5 header exists without any task items

---

### 16. Non-Sequential Phase Numbers Warning

**Command**: `openspec validate --numbering test-dual-layer`

**Expected Output**:
```
⚠ Warning: Non-sequential phase numbering detected
  - Expected phase 3, found phase 4
  - This may indicate missing content
```

**Context**: Phase numbering skips from 2 to 4

---

### 17. Special Characters Preserved

**Command**: `openspec validate --sync test-dual-layer`

**Expected Output**:
```
✓ Synchronization validated
  - Special characters preserved in task titles
  - No parsing errors detected
```

**Context**: Task titles with quotes, ampersands, parentheses correctly handled

**Example task.md**:
```markdown
- [ ] 1.1 Create "test-docs" directory & validate structure (critical!)
```

**Corresponding detailed-tasks.yaml**:
```yaml
- id: TASK-001
  parent: "1.1"
  title: Create "test-docs" directory & validate structure (critical!)
```

---

## Complete Spec Overview

### 18. Spec Overview Display

**Command**: `openspec show test-dual-layer`

**Expected Output**:
```
╔══════════════════════════════════════════════════════════════╗
║            Spec: test-dual-layer                             ║
╚══════════════════════════════════════════════════════════════╝

📋 Basic Information
────────────────────────────────────────────────────────────────
Spec Name:    test-dual-layer
Level:        Full (Level 3)
Status:       Approved
Created:      2025-12-18
Module:       standards/openspec

📊 Task Summary
────────────────────────────────────────────────────────────────
Total Tasks:  12
Completed:    0
In Progress:  0
Pending:      12
Blocked:      0

Progress:     [                              ] 0%

🎯 Phase Breakdown
────────────────────────────────────────────────────────────────
Phase 1 - Setup Test Structure                    0/3  (0%)
Phase 2 - Layer 1 Testing (tasks.md)              0/3  (0%)
Phase 3 - Layer 2 Testing (detailed-tasks.yaml)   0/3  (0%)
Phase 4 - Synchronization Testing                 0/3  (0%)

✅ Validation Status
────────────────────────────────────────────────────────────────
Numbering:    ✓ Valid
Sync:         ✓ Valid
Metadata:     ✓ Complete

📁 Key Files
────────────────────────────────────────────────────────────────
Proposal:     standards/openspec/changes/test-dual-layer/proposal.md
Tasks (L1):   standards/openspec/changes/test-dual-layer/tasks.md
Tasks (L2):   standards/openspec/changes/test-dual-layer/detailed-tasks.yaml
Test Docs:    standards/openspec/changes/test-dual-layer/test-docs/
```

**Context**: Complete overview of test-dual-layer spec showing all metadata

---

## Performance Benchmark Outputs

### 19. Large Spec Forward Sync (100 tasks)

**Command**: Task-planner skill execution on 100-task spec

**Expected Output**:
```
✓ Forward sync completed in 1.45 seconds
  - Parsed 100 tasks from tasks.md
  - Generated 100 TASK-{NNN} entries
  - All parent references valid
  - Performance: ✓ Under 2 second target
```

**Context**: 100-task spec with 10 phases

---

### 20. Large Spec Backward Sync (100 tasks)

**Command**: Progress-updater skill execution on 100-task spec

**Expected Output**:
```
✓ Backward sync completed in 0.68 seconds
  - Updated 1 checkbox in tasks.md
  - TASK-042 marked as completed → 5.2 checkbox set to [x]
  - Performance: ✓ Under 1 second target
```

**Context**: Single task completion update in 100-task spec

---

### 21. Large Spec Validation (100 tasks)

**Command**: `openspec validate --sync test-dual-layer-large`

**Expected Output**:
```
✓ Synchronization validated in 2.31 seconds
  - All 100 tasks have valid parent references
  - Parent references match tasks.md numbering
  - No orphaned tasks detected
  - Performance: ✓ Under 3 second target
```

**Context**: Full validation of 100-task spec

---

## Quick Reference Matrix

| Scenario | Command | Success Output | Failure Output |
|----------|---------|----------------|----------------|
| Valid numbering | `validate --numbering` | ✓ passed | ✗ failed + line numbers |
| Valid sync | `validate --sync` | ✓ validated | ✗ failed + details |
| YAML syntax | `yamllint` | (no output) | Error messages |
| Spec overview | `show {spec}` | Full display | Error if spec not found |
| Forward sync | task-planner | ✓ completed | ✗ errors + details |
| Backward sync | progress-updater | ✓ completed | ✗ errors + details |

---

## Error Message Components

All error messages should include:

1. **Status Symbol**: ✗ (failure) or ⚠ (warning)
2. **Error Type**: Validation failed / orphaned task / invalid format
3. **Specific Details**: Line numbers, field names, found vs expected values
4. **Action Required**: Clear next steps for resolution

**Example Structure**:
```
✗ {Validation Type} failed
  - Error: {Specific error description}
  - {Context information with line numbers/values}
  - Action required: {Clear resolution steps}
```

---

**Last Updated**: 2025-12-22
**Maintainer**: AI-DDD Development Team
