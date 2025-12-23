# Dual-Layer Architecture Test Scenarios

> **Test Case**: test-dual-layer
> **Purpose**: Comprehensive test scenarios for validating dual-layer task architecture
> **Last Updated**: 2025-12-22

---

## Overview

This document defines detailed test scenarios for each aspect of the dual-layer architecture, organized by testing phase and validation objective.

---

## Phase 1: Setup Test Structure

### Scenario 1.1: Test Documentation Directory Creation
**Objective**: Verify proper test documentation infrastructure

**Preconditions**:
- `standards/openspec/changes/test-dual-layer/` directory exists
- No test-docs/ subdirectory present

**Test Steps**:
1. Create test-docs/ directory
2. Create README.md with test case overview
3. Create validation-report.md template

**Expected Results**:
- ✅ Directory structure: `test-dual-layer/test-docs/` exists
- ✅ README.md contains test case overview, validation commands, success criteria
- ✅ validation-report.md template has all required sections

**Pass Criteria**: All files created with correct structure and content

---

## Phase 2: Layer 1 Testing (tasks.md)

### Scenario 2.1: Valid Numbering Format
**Objective**: Validate correct {phase}.{task} numbering format

**Preconditions**:
- tasks.md exists with standard structure

**Test Input** (tasks.md excerpt):
```markdown
## 1. Setup Test Structure

- [ ] 1.1 Create test documentation directory
- [ ] 1.2 Initialize validation test framework
- [ ] 1.3 Document test scenarios

## 2. Layer 1 Testing (tasks.md)

- [ ] 2.1 Verify proper numbering format
- [ ] 2.2 Test phase grouping
```

**Validation Command**:
```bash
openspec validate --numbering test-dual-layer
```

**Expected Output**:
```
✓ Numbering validation passed
  - Format: {phase}.{task} correct
  - Sequential: All phases sequential (1, 2, 3, 4)
  - No duplicates detected
  - 12 tasks validated
```

**Pass Criteria**: Command exits with status 0, no errors reported

---

### Scenario 2.2: Invalid Numbering - Duplicate Numbers
**Objective**: Detect duplicate task numbers

**Test Input** (tasks.md excerpt with error):
```markdown
## 1. Setup Test Structure

- [ ] 1.1 Create test documentation directory
- [ ] 1.1 Initialize validation test framework  ← DUPLICATE
- [ ] 1.3 Document test scenarios
```

**Expected Output**:
```
✗ Numbering validation failed
  - Error: Duplicate task number detected: 1.1
  - Line 5: "1.1 Create test documentation directory"
  - Line 6: "1.1 Initialize validation test framework"
  - Action required: Renumber duplicate task
```

**Pass Criteria**: Error correctly detected and reported with line numbers

---

### Scenario 2.3: Invalid Numbering - Wrong Format
**Objective**: Detect incorrect numbering format

**Test Input** (tasks.md excerpt with error):
```markdown
## 1. Setup Test Structure

- [ ] 1 Create test documentation directory    ← WRONG FORMAT
- [ ] 1.2 Initialize validation test framework
```

**Expected Output**:
```
✗ Numbering validation failed
  - Error: Invalid numbering format at line 5
  - Expected: {phase}.{task} (e.g., "1.1")
  - Found: "1"
  - Action required: Fix numbering format
```

**Pass Criteria**: Format error correctly detected

---

### Scenario 2.4: Phase Grouping Validation
**Objective**: Verify tasks are grouped under correct phase headers

**Test Input**:
```markdown
## 1. Setup Test Structure

- [ ] 1.1 Create test documentation directory
- [ ] 1.2 Initialize validation test framework
- [ ] 2.1 Verify proper numbering format      ← WRONG PHASE

## 2. Layer 1 Testing (tasks.md)

- [ ] 2.2 Test phase grouping
```

**Expected Output**:
```
⚠ Phase grouping warning
  - Warning: Task 2.1 appears under Phase 1 header
  - Expected: Task 2.1 should be under Phase 2 header
  - Location: Line 7
```

**Pass Criteria**: Grouping inconsistency detected

---

### Scenario 2.5: Checkbox Status Tracking
**Objective**: Validate checkbox format consistency

**Test Input**:
```markdown
- [ ] 1.1 Create test documentation directory
- [x] 1.2 Initialize validation test framework
- [X] 1.3 Document test scenarios              ← Uppercase X (valid variant)
- [-] 2.1 Verify proper numbering format       ← INVALID
```

**Expected Output**:
```
✗ Checkbox validation failed
  - Error: Invalid checkbox format at line 8
  - Expected: "- [ ]" or "- [x]" or "- [X]"
  - Found: "- [-]"
  - Action required: Fix checkbox format
```

**Pass Criteria**: Invalid checkbox format detected

---

## Phase 3: Layer 2 Testing (detailed-tasks.yaml)

### Scenario 3.1: Valid TASK-{NNN} ID Format
**Objective**: Validate correct TASK ID generation

**Test Input** (detailed-tasks.yaml excerpt):
```yaml
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Create test documentation directory

  - id: TASK-002
    parent: "1.2"
    title: Initialize validation test framework
```

**Validation**: Parse YAML and check ID format

**Expected Results**:
- ✅ ID format matches TASK-{NNN} with 3-digit zero-padding
- ✅ IDs are sequential (001, 002, 003...)
- ✅ No duplicate IDs

**Pass Criteria**: All IDs valid and sequential

---

### Scenario 3.2: Invalid TASK ID - Wrong Format
**Objective**: Detect incorrect TASK ID format

**Test Input** (detailed-tasks.yaml excerpt with error):
```yaml
tasks:
  - id: TASK-1                    ← WRONG: Missing zero-padding
    parent: "1.1"

  - id: TSK-002                   ← WRONG: Incorrect prefix
    parent: "1.2"
```

**Expected Output**:
```
✗ TASK ID validation failed
  - Error: Invalid ID format "TASK-1" at task index 0
    Expected: TASK-{NNN} with 3-digit zero-padding (e.g., TASK-001)
  - Error: Invalid ID format "TSK-002" at task index 1
    Expected: Prefix must be "TASK-"
```

**Pass Criteria**: Format errors correctly detected

---

### Scenario 3.3: Parent Reference Validation - Valid Links
**Objective**: Verify parent references correctly link to tasks.md

**Test Input**:

tasks.md:
```markdown
- [ ] 1.1 Create test documentation directory
- [ ] 1.2 Initialize validation test framework
```

detailed-tasks.yaml:
```yaml
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Create test documentation directory

  - id: TASK-002
    parent: "1.2"
    title: Initialize validation test framework
```

**Validation Command**:
```bash
openspec validate --sync test-dual-layer
```

**Expected Output**:
```
✓ Synchronization validated
  - All 12 tasks have valid parent references
  - Parent references match tasks.md numbering
  - No orphaned tasks detected
```

**Pass Criteria**: All parent references valid

---

### Scenario 3.4: Parent Reference Validation - Mismatched References
**Objective**: Detect parent references that don't match tasks.md

**Test Input**:

tasks.md (only has 1.1, 1.2, 1.3):
```markdown
- [ ] 1.1 Create test documentation directory
- [ ] 1.2 Initialize validation test framework
- [ ] 1.3 Document test scenarios
```

detailed-tasks.yaml (references non-existent 1.4):
```yaml
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Create test documentation directory

  - id: TASK-004
    parent: "1.4"                    ← ORPHANED: No 1.4 in tasks.md
    title: Some task
```

**Expected Output**:
```
✗ Synchronization validation failed
  - Error: Orphaned task detected
    - TASK-004 references parent "1.4"
    - No task numbered 1.4 found in tasks.md
  - Action required: Fix parent reference or add task to tasks.md
```

**Pass Criteria**: Orphaned task correctly detected

---

### Scenario 3.5: Task Metadata Completeness
**Objective**: Validate all required fields present

**Test Input** (detailed-tasks.yaml excerpt with missing fields):
```yaml
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Create test documentation directory
    # Missing: status, complexity, dependencies, agent, deliverables, verification
```

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

**Pass Criteria**: All missing fields detected

---

## Phase 4: Synchronization Testing

### Scenario 4.1: Forward Sync - tasks.md to detailed-tasks.yaml
**Objective**: Validate task-planner correctly generates detailed-tasks.yaml from tasks.md

**Preconditions**:
- tasks.md exists with proper structure
- detailed-tasks.yaml does not exist OR is older than tasks.md

**Test Steps**:
1. Create/update tasks.md with new task:
   ```markdown
   - [ ] 5.1 New task for testing
   ```
2. Run task-planner skill
3. Verify detailed-tasks.yaml generated/updated

**Expected Results**:
- ✅ New TASK-{NNN} entry created in detailed-tasks.yaml
- ✅ parent field set to "5.1"
- ✅ All metadata fields populated
- ✅ Existing tasks unchanged

**Pass Criteria**: Forward sync successful, no data loss

---

### Scenario 4.2: Backward Sync - Status Update
**Objective**: Validate progress-updater correctly syncs status from detailed-tasks.yaml to tasks.md

**Preconditions**:
- Both layers exist and in sync

**Test Steps**:
1. Mark TASK-001 as completed in detailed-tasks.yaml:
   ```yaml
   - id: TASK-001
     parent: "1.1"
     status: completed    # Changed from pending
   ```
2. Run progress-updater skill
3. Verify tasks.md checkbox updated

**Expected Results**:

Before (tasks.md):
```markdown
- [ ] 1.1 Create test documentation directory
```

After (tasks.md):
```markdown
- [x] 1.1 Create test documentation directory
```

**Pass Criteria**: Checkbox correctly updated to [x]

---

### Scenario 4.3: Conflict Detection - Numbering Change
**Objective**: Detect when tasks.md numbering is changed after detailed-tasks.yaml created

**Test Setup**:
1. Initial state - both layers synced:
   ```markdown
   # tasks.md
   - [ ] 1.1 Create test documentation directory
   - [ ] 1.2 Initialize validation test framework
   ```

   ```yaml
   # detailed-tasks.yaml
   - id: TASK-001
     parent: "1.1"
   - id: TASK-002
     parent: "1.2"
   ```

2. User manually renumbers tasks.md:
   ```markdown
   # tasks.md (MODIFIED - numbering changed)
   - [ ] 1.1 Initialize validation test framework  ← Was 1.2
   - [ ] 1.2 Create test documentation directory   ← Was 1.1
   ```

**Test Steps**:
1. Modify tasks.md numbering as shown above
2. Run validation: `openspec validate --sync test-dual-layer`

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

**Pass Criteria**: Numbering change correctly detected with clear error message

---

### Scenario 4.4: Conflict Detection - Missing Parent Reference
**Objective**: Detect when task deleted from tasks.md but still referenced in detailed-tasks.yaml

**Test Setup**:
1. Delete task 1.2 from tasks.md:
   ```markdown
   # tasks.md
   - [ ] 1.1 Create test documentation directory
   # Task 1.2 DELETED
   - [ ] 1.3 Document test scenarios
   ```

2. detailed-tasks.yaml still has reference:
   ```yaml
   - id: TASK-002
     parent: "1.2"    ← ORPHANED
   ```

**Expected Output**:
```
✗ Synchronization validation failed
  - Error: Orphaned task reference detected
    - TASK-002 references parent "1.2"
    - Task 1.2 not found in tasks.md
  - Suggestion: Either restore task 1.2 in tasks.md or remove TASK-002 from detailed-tasks.yaml
```

**Pass Criteria**: Orphaned reference detected

---

## Edge Cases and Error Scenarios

### Edge Case 1: Empty Phase
**Scenario**: Phase header exists but contains no tasks

**Test Input**:
```markdown
## 5. Future Work

(No tasks listed)
```

**Expected Behavior**: ⚠️ Warning issued but not error

---

### Edge Case 2: Non-Sequential Phase Numbers
**Scenario**: Phase numbers skip (1, 2, 4)

**Test Input**:
```markdown
## 1. Setup
## 2. Testing
## 4. Deployment  ← Skipped phase 3
```

**Expected Output**:
```
⚠ Warning: Non-sequential phase numbering detected
  - Expected phase 3, found phase 4
  - This may indicate missing content
```

**Pass Criteria**: Warning issued

---

### Edge Case 3: Complex Task Title with Special Characters
**Scenario**: Task title contains special characters that might break parsing

**Test Input**:
```markdown
- [ ] 1.1 Create "test-docs" directory & validate structure (critical!)
```

```yaml
- id: TASK-001
  parent: "1.1"
  title: Create "test-docs" directory & validate structure (critical!)
```

**Expected Behavior**: ✅ Special characters preserved correctly in both layers

**Pass Criteria**: No parsing errors, title matches exactly

---

## Performance Test Scenarios

### Performance 1: Large Spec (100+ tasks)
**Objective**: Validate sync performance with large task list

**Test Setup**: Create spec with 100 tasks across 10 phases

**Performance Targets**:
- Forward sync: < 2 seconds
- Backward sync: < 1 second
- Validation: < 3 seconds

**Pass Criteria**: All operations complete within target times

---

## Summary Table

| Scenario ID | Category | Priority | Status |
|-------------|----------|----------|--------|
| 2.1 | Layer 1 - Valid | P0 | ⏳ Pending |
| 2.2 | Layer 1 - Invalid | P0 | ⏳ Pending |
| 2.3 | Layer 1 - Invalid | P0 | ⏳ Pending |
| 2.4 | Layer 1 - Grouping | P1 | ⏳ Pending |
| 2.5 | Layer 1 - Checkbox | P1 | ⏳ Pending |
| 3.1 | Layer 2 - Valid | P0 | ⏳ Pending |
| 3.2 | Layer 2 - Invalid | P0 | ⏳ Pending |
| 3.3 | Layer 2 - Valid Sync | P0 | ⏳ Pending |
| 3.4 | Layer 2 - Invalid Sync | P0 | ⏳ Pending |
| 3.5 | Layer 2 - Metadata | P1 | ⏳ Pending |
| 4.1 | Sync - Forward | P0 | ⏳ Pending |
| 4.2 | Sync - Backward | P0 | ⏳ Pending |
| 4.3 | Conflict Detection | P0 | ⏳ Pending |
| 4.4 | Conflict Detection | P0 | ⏳ Pending |

---

**Test Coverage**: 14 primary scenarios + 3 edge cases + 1 performance test = 18 total test cases

**Next Steps**: Execute each scenario and record results in validation-report.md

---

**Last Updated**: 2025-12-22
**Maintainer**: AI-DDD Development Team
