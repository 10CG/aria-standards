# OpenSpec Validation Commands Guide

> **Version**: 1.0.0
> **Created**: 2025-12-20
> **Purpose**: Guide for validating OpenSpec dual-layer architecture consistency

## Overview

OpenSpec provides validation commands to ensure the integrity and consistency of the dual-layer task architecture (tasks.md + detailed-tasks.yaml). These commands help detect and prevent synchronization issues between the human-readable Layer 1 and the AI-executable Layer 2.

## Validation Commands

### 1. --sync: Check Dual-Layer Consistency

Verifies that tasks.md and detailed-tasks.yaml are properly synchronized.

```bash
openspec validate --sync {feature-name}
```

#### What it checks:
1. **Parent Reference Validity**
   - Every TASK-{NNN} has a valid parent reference in tasks.md
   - Parent format matches pattern: `{phase}.{task}` (e.g., "1.1", "2.3")

2. **Task Status Synchronization**
   - Completed tasks in detailed-tasks.yaml have corresponding checkboxes checked in tasks.md
   - In-progress tasks in detailed-tasks.yaml have unchecked checkboxes in tasks.md

3. **Title Consistency**
   - Task titles match between layers (with tolerance for minor edits)
   - Flags significant title mismatches for manual review

4. **Completeness**
   - All tasks.md items have corresponding detailed-tasks.yaml entries
   - All detailed-tasks.yaml entries have corresponding tasks.md items

#### Example Output:

```bash
$ openspec validate --sync user-authentication

✅ OpenSpec Validation: user-authentication

📊 Summary:
  Total tasks in tasks.md: 8
  Total tasks in detailed-tasks.yaml: 8
  Synchronized tasks: 7
  Desynchronized tasks: 1

⚠️  Issues Found:
  1. TASK-004 status mismatch
     - detailed-tasks.yaml: completed
     - tasks.md: [ ] 1.4 (unchecked)
     - Suggestion: Run 'openspec sync user-authentication' to fix

✅ Parent references: Valid
⚠️  Title similarity: 87% (acceptable)
```

### 2. --numbering: Verify Numbering Integrity

Ensures tasks.md follows proper numbering conventions and immutability rules.

```bash
openspec validate --numbering {feature-name}
```

#### What it checks:
1. **Number Format**
   - Valid format: `{phase}.{task}` where both are positive integers
   - No gaps in numbering within each phase
   - No duplicate numbering

2. **Phase Organization**
   - Tasks are properly grouped under phase headings
   - Phase numbering is sequential (1, 2, 3...)

3. **Immutability Compliance**
   - Warns if numbering changes are detected (compared to previous version)
   - Checks for renumbering that would break parent references

#### Example Output:

```bash
$ openspec validate --numbering user-authentication

✅ Numbering Validation: user-authentication

📊 Structure Analysis:
  Phase 1: Database Setup (3 tasks: 1.1 - 1.3)
  Phase 2: API Implementation (3 tasks: 2.1 - 2.3)
  Phase 3: Testing (2 tasks: 3.1 - 3.2)

✅ Number format: Valid
✅ No gaps detected
✅ No duplicates found
✅ Sequential phase numbering

📈 Numbering Health Score: 100%
```

### 3. show: Display Complete Overview

Shows a comprehensive view of both layers and their relationships.

```bash
openspec show {feature-name}
```

#### Example Output:

```bash
$ openspec show user-authentication

📋 OpenSpec Overview: user-authentication
==========================================

Layer 1: tasks.md (Human-readable)
--------------------------------
## 1. Database Setup
- [x] 1.1 Add OTP column to users table
- [x] 1.2 Create verification logs table
- [x] 1.3 Add indexes for performance

## 2. API Implementation
- [x] 2.1 Generate OTP endpoint
- [x] 2.2 Verify OTP endpoint
- [ ] 2.3 Refresh token endpoint

Layer 2: detailed-tasks.yaml (AI-executable)
-------------------------------------------
TASK-001 (parent: 1.1)
  ├─ Status: completed
  ├─ Agent: backend-architect
  └─ Deliverable: migrations/add_otp_column.sql

TASK-002 (parent: 1.2)
  ├─ Status: completed
  ├─ Agent: backend-architect
  └─ Deliverable: migrations/create_logs_table.sql

TASK-005 (parent: 2.3)
  ├─ Status: pending
  ├─ Agent: backend-architect
  ├─ Dependencies: [TASK-004]
  └─ Deliverable: backend/src/routes/auth.py

📊 Progress Summary:
- Completed: 5/8 (62.5%)
- In Progress: 0
- Pending: 3
- Blocked: 0
```

## Advanced Usage

### Combining Validations

Run multiple validations in sequence:

```bash
# Full validation suite
for feature in user-authentication api-versioning; do
  echo "=== Validating $feature ==="
  openspec validate --sync $feature
  openspec validate --numbering $feature
  echo ""
done
```

### CI/CD Integration

Add to your CI pipeline:

```yaml
# .github/workflows/openspec-validate.yml
name: OpenSpec Validation

on:
  push:
    paths:
      - 'standards/openspec/changes/**'
  pull_request:
    paths:
      - 'standards/openspec/changes/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup OpenSpec CLI
        run: npm install -g @openspec/cli
      - name: Validate all active specs
        run: |
          for spec in standards/openspec/changes/*/; do
            if [ -f "$spec/proposal.md" ]; then
              feature=$(basename "$spec")
              openspec validate --sync "$feature"
              openspec validate --numbering "$feature"
            fi
          done
```

### Automated Fixing

The `--fix` flag can automatically fix common issues:

```bash
# Auto-sync completed tasks
openspec validate --sync user-authentication --fix

# This will:
# - Check off completed tasks in tasks.md
# - Update detailed-tasks.yaml timestamps
# - Recalculate stateToken
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Parent Reference Not Found

```
Error: TASK-003.parent "1.4" not found in tasks.md
```

**Solution**:
- Check if the task was deleted or renumbered in tasks.md
- Update the parent reference in detailed-tasks.yaml
- Or restore the missing task in tasks.md

#### 2. Status Mismatch

```
Warning: TASK-002 marked as completed but 1.2 is unchecked
```

**Solution**:
- Run `openspec validate --sync {feature} --fix` to auto-sync
- Or manually update the checkbox in tasks.md

#### 3. Numbering Gaps Detected

```
Error: Gap detected in Phase 1: missing 1.2
```

**Solution**:
- Add the missing task with numbering 1.2
- Or renumber existing tasks (not recommended if already linked)

#### 4. Duplicate Numbers

```
Error: Duplicate number "2.1" found in tasks.md
```

**Solution**:
- Renumber one of the duplicate tasks
- Ensure each number is unique within its phase

## Best Practices

### 1. Regular Validation

- Run validation after each task completion
- Include validation in CI/CD pipeline
- Validate before major milestones

### 2. Consistent Updates

- Always update both layers together
- Use progress-updater skill for automatic synchronization
- Avoid manual editing of parent references

### 3. Version Control

- Commit both layers together
- Include validation output in commit messages
- Tag major milestones

### 4. Documentation

- Document any numbering exceptions
- Record reasons for task cancellations
- Keep change logs for major restructuring

## Integration with Skills

### task-planner

```yaml
# After generating detailed-tasks.yaml
task-planner automatically runs:
  openspec validate --numbering {feature}
```

### progress-updater

```yaml
# After updating task status
progress-updater automatically runs:
  openspec validate --sync {feature} --fix
```

### spec-drafter

```yaml
# After creating tasks.md
spec-drafter automatically runs:
  openspec validate --numbering {feature}
```

## Reference

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success, no issues |
| 1 | Validation failed |
| 2 | Feature not found |
| 3 | Invalid command usage |

### Configuration File

Create `.openspec/config.yaml` for default settings:

```yaml
validation:
  auto_fix: false
  title_similarity_threshold: 0.8
  strict_numbering: true
  ignore_warnings: []
```

---

**Version**: 1.0.0
**Last Updated**: 2025-12-20
**Related Documents**:
- [OpenSpec Templates](templates/README.md)
- [Dual-Layer Architecture](changes/optimize-phase-a-with-dual-layer-architecture/proposal.md)