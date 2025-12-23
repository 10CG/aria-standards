# Dual-Layer Architecture Validation Checklist

> **Test Case**: test-dual-layer
> **Purpose**: Quick validation checklist for dual-layer architecture testing
> **Last Updated**: 2025-12-22

---

## Pre-Execution Checklist

### Test Environment Setup
- [ ] Verify `standards/openspec/changes/test-dual-layer/` directory exists
- [ ] Confirm `tasks.md` file is present and readable
- [ ] Confirm `detailed-tasks.yaml` file is present and readable
- [ ] Ensure `openspec` command-line tool is installed
- [ ] Ensure `yamllint` tool is installed (for YAML validation)
- [ ] Test documentation directory `test-docs/` exists with all required files

### Test Data Verification
- [ ] tasks.md contains tasks with `{phase}.{task}` numbering
- [ ] detailed-tasks.yaml contains tasks with TASK-{NNN} IDs
- [ ] Parent references in detailed-tasks.yaml point to tasks.md numbering
- [ ] No pre-existing validation errors in test files

---

## Layer 1 Validation (tasks.md)

### Numbering Format Validation
- [ ] All tasks follow `{phase}.{task}` format (e.g., "1.1", "2.3")
- [ ] No duplicate task numbers detected
- [ ] Phase numbering is sequential (1, 2, 3, 4)
- [ ] Task numbering within phases is sequential
- [ ] Phase headers exist and are properly formatted

**Command**: `openspec validate --numbering test-dual-layer`

**Expected Result**: ✓ Numbering validation passed

### Checkbox Format Validation
- [ ] All pending tasks use `- [ ]` format
- [ ] All completed tasks use `- [x]` or `- [X]` format
- [ ] No invalid checkbox formats (e.g., `- [-]`)

### Phase Grouping Validation
- [ ] Tasks are grouped under correct phase headers
- [ ] No tasks appear under wrong phase
- [ ] Summary table (if present) matches actual task count

---

## Layer 2 Validation (detailed-tasks.yaml)

### YAML Syntax Validation
- [ ] File is valid YAML (no syntax errors)
- [ ] All required root-level fields present (`spec`, `generated_at`, `tasks`)
- [ ] Tasks array is properly formatted

**Command**: `yamllint test-dual-layer/detailed-tasks.yaml`

**Expected Result**: No errors

### TASK ID Format Validation
- [ ] All IDs follow `TASK-{NNN}` format with 3-digit zero-padding
- [ ] IDs are sequential (TASK-001, TASK-002, TASK-003, ...)
- [ ] No duplicate IDs detected
- [ ] ID prefix is consistently "TASK-"

### Parent Reference Validation
- [ ] All tasks have `parent` field
- [ ] Parent references match tasks.md numbering format
- [ ] No orphaned tasks (parent references non-existent tasks.md numbering)
- [ ] No missing parent references

**Command**: `openspec validate --sync test-dual-layer`

**Expected Result**: ✓ Synchronization validated

### Metadata Completeness Validation
- [ ] All tasks have `id` field
- [ ] All tasks have `title` field
- [ ] All tasks have `status` field (pending/in_progress/completed/blocked)
- [ ] All tasks have `complexity` field (S/M/L/XL)
- [ ] All tasks have `dependencies` field (can be empty array)
- [ ] All tasks have `agent` field
- [ ] All tasks have `deliverables` array
- [ ] All tasks have `verification` array

---

## Synchronization Validation

### Forward Sync (tasks.md → detailed-tasks.yaml)
- [ ] task-planner skill can parse tasks.md successfully
- [ ] Generated TASK-{NNN} IDs are sequential
- [ ] Parent references match tasks.md numbering exactly
- [ ] All tasks.md items are represented in detailed-tasks.yaml
- [ ] No tasks missing from detailed-tasks.yaml

**Process**: Run task-planner skill, verify output

### Backward Sync (Status Updates)
- [ ] Status change in detailed-tasks.yaml (`pending` → `completed`)
- [ ] Corresponding checkbox updated in tasks.md (`- [ ]` → `- [x]`)
- [ ] Only the specific task checkbox changed
- [ ] Other tasks remain unchanged
- [ ] Summary table (if present) reflects completion count

**Process**: Run progress-updater skill, verify tasks.md

---

## Conflict Detection Validation

### Numbering Immutability Test
- [ ] Manually renumber tasks in tasks.md
- [ ] Run `openspec validate --sync test-dual-layer`
- [ ] Verify error message: "Numbering immutability constraint violated"
- [ ] Verify error provides specific line numbers and task details
- [ ] Restore original numbering after test

### Parent Reference Mismatch Test
- [ ] Create orphaned task in detailed-tasks.yaml (parent points to non-existent task)
- [ ] Run `openspec validate --sync test-dual-layer`
- [ ] Verify error message: "Orphaned task detected"
- [ ] Verify error identifies TASK-{NNN} ID and invalid parent reference
- [ ] Remove orphaned task after test

### Duplicate ID Test
- [ ] Manually create duplicate TASK-{NNN} ID in detailed-tasks.yaml
- [ ] Run validation
- [ ] Verify error message: "Duplicate ID detected"
- [ ] Verify error identifies both occurrences
- [ ] Remove duplicate after test

---

## Edge Case Validation

### Empty Phase Test
- [ ] Phase header exists with no tasks
- [ ] Validation produces warning (not error)
- [ ] Warning is informative and actionable

### Non-Sequential Phase Numbers Test
- [ ] Phase numbers skip (e.g., 1, 2, 4)
- [ ] Validation produces warning
- [ ] Warning indicates missing phase

### Special Characters in Task Title Test
- [ ] Task title contains quotes, ampersands, parentheses
- [ ] Characters are preserved correctly in both layers
- [ ] No parsing errors occur

---

## Performance Validation

### Large Spec Test (100+ tasks)
- [ ] Create spec with 100 tasks across 10 phases
- [ ] Forward sync completes in < 2 seconds
- [ ] Backward sync completes in < 1 second
- [ ] Validation completes in < 3 seconds
- [ ] No memory issues or crashes

---

## Post-Execution Checklist

### Results Documentation
- [ ] All test scenarios executed
- [ ] Results recorded in validation-report.md
- [ ] Pass/fail status documented for each scenario
- [ ] Actual command outputs captured
- [ ] Any issues encountered are documented with severity

### Issue Tracking
- [ ] Critical issues logged with reproduction steps
- [ ] Expected vs actual behavior documented
- [ ] Resolution or workaround noted
- [ ] Related TASK-{NNN} IDs referenced

### Coverage Verification
- [ ] All P0 scenarios tested and passed
- [ ] All P1 scenarios tested and passed (or issues logged)
- [ ] Edge cases covered
- [ ] Performance benchmark met

### Final Validation
- [ ] Execute `openspec validate --sync test-dual-layer` one final time
- [ ] Execute `openspec validate --numbering test-dual-layer` one final time
- [ ] Execute `openspec show test-dual-layer` to view complete overview
- [ ] All commands execute without errors
- [ ] Test case marked as complete

---

## Common Pitfalls Checklist

### Avoid These Mistakes
- [ ] ❌ Do NOT manually edit TASK-{NNN} IDs in detailed-tasks.yaml
- [ ] ❌ Do NOT renumber tasks.md after detailed-tasks.yaml is created
- [ ] ❌ Do NOT create gaps in TASK-{NNN} sequence (e.g., TASK-001, TASK-003)
- [ ] ❌ Do NOT use incorrect checkbox format in tasks.md
- [ ] ❌ Do NOT create parent references to non-existent tasks.md numbering
- [ ] ❌ Do NOT skip required metadata fields in detailed-tasks.yaml

### Best Practices
- [ ] ✅ Always validate YAML syntax before running openspec commands
- [ ] ✅ Test forward sync before backward sync
- [ ] ✅ Create backups before running conflict detection tests
- [ ] ✅ Document actual command outputs for future reference
- [ ] ✅ Verify parent references match exactly (including whitespace)
- [ ] ✅ Use consistent status values (pending/in_progress/completed/blocked)

---

## Quick Command Reference

```bash
# Syntax validation
yamllint test-dual-layer/detailed-tasks.yaml

# Synchronization validation
openspec validate --sync test-dual-layer

# Numbering validation
openspec validate --numbering test-dual-layer

# Complete spec overview
openspec show test-dual-layer

# Forward sync (requires task-planner skill)
# (Skill execution command - depends on implementation)

# Backward sync (requires progress-updater skill)
# (Skill execution command - depends on implementation)
```

---

## Test Scenario Mapping

| Scenario ID | Checklist Section | Priority |
|-------------|-------------------|----------|
| 2.1 | Layer 1 - Numbering Format | P0 |
| 2.2 | Layer 1 - Numbering Format (Duplicate) | P0 |
| 2.3 | Layer 1 - Numbering Format (Wrong Format) | P0 |
| 2.4 | Layer 1 - Phase Grouping | P1 |
| 2.5 | Layer 1 - Checkbox Format | P1 |
| 3.1 | Layer 2 - TASK ID Format | P0 |
| 3.2 | Layer 2 - TASK ID Format (Invalid) | P0 |
| 3.3 | Layer 2 - Parent Reference (Valid) | P0 |
| 3.4 | Layer 2 - Parent Reference (Mismatch) | P0 |
| 3.5 | Layer 2 - Metadata Completeness | P1 |
| 4.1 | Synchronization - Forward Sync | P0 |
| 4.2 | Synchronization - Backward Sync | P0 |
| 4.3 | Conflict Detection - Numbering Change | P0 |
| 4.4 | Conflict Detection - Missing Parent | P0 |

---

**Last Updated**: 2025-12-22
**Maintainer**: AI-DDD Development Team
