# Dual-Layer Architecture Test Framework

> **Test Case**: test-dual-layer
> **Purpose**: Validation methodology and approach for dual-layer architecture testing
> **Created**: 2025-12-22

---

## Overview

This document defines the systematic validation approach for testing the OpenSpec dual-layer task architecture, ensuring comprehensive coverage of all components and their interactions.

---

## Validation Methodology

### Three-Layer Validation Approach

```
┌─────────────────────────────────────────────────────────────────┐
│                    Validation Layer Model                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Layer 1: Format Validation                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ • Syntax validation (YAML, Markdown)                      │  │
│  │ • Numbering format ({phase}.{task})                       │  │
│  │ • ID format (TASK-{NNN})                                  │  │
│  │ • Required field presence                                 │  │
│  └───────────────────────────────────────────────────────────┘  │
│                           │                                     │
│                           ▼                                     │
│  Layer 2: Semantic Validation                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ • Parent reference correctness                            │  │
│  │ • Dependency chain validity                               │  │
│  │ • Phase grouping consistency                              │  │
│  │ • Task metadata completeness                              │  │
│  └───────────────────────────────────────────────────────────┘  │
│                           │                                     │
│                           ▼                                     │
│  Layer 3: Integration Validation                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ • Forward synchronization (tasks.md → detailed-tasks.yaml)│  │
│  │ • Backward synchronization (status updates)               │  │
│  │ • Conflict detection mechanisms                           │  │
│  │ • Numbering immutability enforcement                      │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Validation Principles

1. **Isolation**: Each test scenario validates a single aspect
2. **Repeatability**: Tests produce consistent results
3. **Clarity**: Expected outcomes are explicitly defined
4. **Coverage**: All architectural components are tested

---

## Test Categories

### Category 1: Layer 1 Validation (tasks.md)

**Focus**: Human-readable task list correctness

**Aspects Tested**:
- Numbering format compliance (`{phase}.{task}`)
- Sequential numbering within phases
- Duplicate number detection
- Phase header structure
- Checkbox format validation
- Phase grouping organization

**Validation Commands**:
```bash
openspec validate --numbering test-dual-layer
```

**Success Criteria**:
- All tasks follow `{phase}.{task}` format
- No duplicate numbers
- Phases are sequential (1, 2, 3, 4)
- Checkboxes use standard format (`- [ ]` or `- [x]`)

---

### Category 2: Layer 2 Validation (detailed-tasks.yaml)

**Focus**: Machine-readable task metadata correctness

**Aspects Tested**:
- TASK-{NNN} ID format (3-digit zero-padding)
- Sequential ID assignment
- Parent reference format
- Required field presence
- Metadata completeness

**Validation Commands**:
```bash
# YAML syntax validation
yamllint detailed-tasks.yaml

# Semantic validation
openspec validate --sync test-dual-layer
```

**Success Criteria**:
- All IDs follow TASK-{NNN} format
- IDs are unique and sequential
- All required fields present
- Parent references use correct format

---

### Category 3: Synchronization Validation

**Focus**: Dual-layer consistency and synchronization

**Aspects Tested**:

#### Forward Sync (A.2: tasks.md → detailed-tasks.yaml)
- Task-planner correctly parses tasks.md
- TASK-{NNN} IDs generated sequentially
- Parent references match tasks.md numbering
- All tasks.md items represented in YAML

#### Backward Sync (B.2: Status Updates)
- Status changes in YAML update tasks.md checkboxes
- Checkbox updates: `- [ ]` → `- [x]`
- Only corresponding tasks are updated
- Other tasks remain unchanged

**Validation Commands**:
```bash
openspec validate --sync test-dual-layer
```

**Success Criteria**:
- All parent references valid
- No orphaned tasks
- Status synchronization bidirectional
- No data loss during sync

---

### Category 4: Conflict Detection

**Focus**: Error detection and prevention

**Aspects Tested**:
- Numbering immutability constraint
- Parent reference mismatch detection
- Orphaned task detection
- Duplicate ID detection

**Test Scenarios**:
1. **Numbering Change After Sync**: Manually renumber tasks.md after detailed-tasks.yaml creation
2. **Orphaned References**: Delete task from tasks.md while reference exists in YAML
3. **Duplicate IDs**: Manually create duplicate TASK-{NNN} IDs

**Expected Behavior**:
- Clear error messages
- Specific line number references
- Actionable resolution suggestions

---

## Test Execution Workflow

### Phase 1: Setup
```bash
# 1. Verify test case structure exists
ls standards/openspec/changes/test-dual-layer/

# 2. Validate prerequisite files
ls test-dual-layer/tasks.md
ls test-dual-layer/detailed-tasks.yaml
```

### Phase 2: Execute Layer 1 Tests
```bash
# Run numbering validation
openspec validate --numbering test-dual-layer

# Document results in validation-report.md
```

### Phase 3: Execute Layer 2 Tests
```bash
# Run YAML syntax validation
yamllint test-dual-layer/detailed-tasks.yaml

# Run semantic validation
openspec validate --sync test-dual-layer
```

### Phase 4: Execute Synchronization Tests
```bash
# Test forward sync
# (Requires task-planner skill execution)

# Test backward sync
# (Requires progress-updater skill execution)

# Validate sync results
openspec validate --sync test-dual-layer
```

### Phase 5: Execute Conflict Detection Tests
```bash
# Introduce deliberate conflicts based on test scenarios
# Run validation and verify error detection
openspec validate --sync test-dual-layer
openspec validate --numbering test-dual-layer
```

---

## Validation Tools

### Primary Tools

| Tool | Purpose | Command |
|------|---------|---------|
| `openspec validate --sync` | Validate synchronization between layers | `openspec validate --sync {spec}` |
| `openspec validate --numbering` | Validate numbering format and immutability | `openspec validate --numbering {spec}` |
| `openspec show` | Display complete spec overview | `openspec show {spec}` |
| `yamllint` | YAML syntax validation | `yamllint {file}` |

### Supporting Tools

| Tool | Purpose |
|------|---------|
| `task-planner` skill | Forward sync execution |
| `progress-updater` skill | Backward sync execution |
| `diff` | Manual comparison of layers |

---

## Test Data Management

### Valid Test Data

Location: `test-dual-layer/tasks.md` and `test-dual-layer/detailed-tasks.yaml`

**Characteristics**:
- Follows all format rules
- Consistent parent references
- Complete metadata
- No conflicts

### Invalid Test Data

Created temporarily for error detection tests:

**Approach**:
1. Create backup of valid files
2. Introduce specific errors per test scenario
3. Run validation
4. Restore from backup

**Error Types to Test**:
- Missing parent references
- Invalid numbering formats
- Duplicate IDs
- Orphaned references
- Numbering changes

---

## Success Metrics

### Coverage Metrics

```yaml
Target Coverage:
  Layer 1 Tests: 100% of tasks.md features
  Layer 2 Tests: 100% of detailed-tasks.yaml features
  Sync Tests: All sync directions (forward, backward)
  Conflict Tests: All defined conflict scenarios

Actual Coverage:
  Total Scenarios: 18
  - Layer 1: 5 scenarios
  - Layer 2: 5 scenarios
  - Sync: 4 scenarios
  - Edge Cases: 3 scenarios
  - Performance: 1 scenario
```

### Quality Metrics

```yaml
Pass Criteria:
  - All P0 scenarios pass: Required
  - All P1 scenarios pass: Strongly recommended
  - Zero false positives: Required
  - Clear error messages: Required

Acceptance:
  - All validation commands execute successfully
  - Error scenarios produce expected error messages
  - No unexpected failures
```

---

## Test Maintenance

### When to Update Tests

- Architecture specification changes
- New validation rules added
- Discovered edge cases
- Tool updates (openspec, task-planner, progress-updater)

### Test Review Schedule

- **Before Release**: All tests must pass
- **Monthly**: Review test coverage completeness
- **Quarterly**: Review and update test scenarios

---

## Related Documentation

- [Test Scenarios](./test-scenarios.md) - Detailed test case definitions
- [Validation Report Template](./validation-report.md) - Test execution recording
- [Expected Outputs](./expected-outputs.md) - Expected command outputs
- [Validation Checklist](./validation-checklist.md) - Quick validation checklist

---

**Last Updated**: 2025-12-22
**Maintainer**: AI-DDD Development Team
