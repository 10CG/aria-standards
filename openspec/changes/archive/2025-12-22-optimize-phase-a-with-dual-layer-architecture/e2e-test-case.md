# End-to-End Test Case: Dual-Layer Architecture

> **Test ID**: E2E-001
> **Created**: 2025-12-21
> **Purpose**: Validate complete dual-layer task architecture workflow
> **Status**: Active

---

## Test Overview

This test case demonstrates the complete lifecycle of the dual-layer task architecture, from initial Spec creation through task execution and synchronization validation.

### Test Scenario

**Feature**: Add User Profile Picture Upload

**Complexity**: Level 3 (Full Spec with dual-layer tasks)

**Workflow Phases**:
1. A.1: Create Spec with coarse-grained tasks.md
2. A.2: Generate detailed-tasks.yaml with TASK-{NNN} IDs and parent links
3. B.2: Execute tasks and update status
4. D.1: Sync progress back to tasks.md
5. Validation: Verify layer synchronization

---

## Test Data

### Step 1: Initial tasks.md (A.1 Output)

**Location**: `changes/user-profile-picture/tasks.md`

```markdown
# Tasks: User Profile Picture Upload

> **Spec**: user-profile-picture
> **Level**: Full (Level 3)
> **Status**: Reviewed
> **Created**: 2025-12-21

---

## 1. Backend API Development

- [ ] 1.1 Design file upload data model
- [ ] 1.2 Implement image storage service
- [ ] 1.3 Create upload API endpoint
- [ ] 1.4 Add image validation and processing

## 2. Mobile UI Implementation

- [ ] 2.1 Design profile picture widget
- [ ] 2.2 Implement camera/gallery picker
- [ ] 2.3 Add image cropping functionality
- [ ] 2.4 Integrate with upload API

## 3. Testing

- [ ] 3.1 Add backend unit tests
- [ ] 3.2 Add mobile widget tests
- [ ] 3.3 Perform integration testing
```

### Step 2: Generated detailed-tasks.yaml (A.2 Output)

**Location**: `changes/user-profile-picture/detailed-tasks.yaml`

```yaml
spec: user-profile-picture
generated_at: "2025-12-21T10:00:00+08:00"
generated_by: task-planner
status: active

tasks:
  # Phase 1: Backend API Development
  - id: TASK-001
    parent: "1.1"
    title: Design file upload data model
    status: pending
    complexity: M
    estimated_hours: 2-4
    dependencies: []
    agent: backend-architect
    deliverables:
      - backend/src/models/profile_picture.py
      - backend/migrations/add_profile_picture_table.sql
    verification:
      - Migration runs successfully
      - Model has correct fields (user_id, image_url, uploaded_at)
      - Foreign key relationship to users table exists

  - id: TASK-002
    parent: "1.2"
    title: Implement image storage service
    status: pending
    complexity: L
    estimated_hours: 4-8
    dependencies: [TASK-001]
    agent: backend-architect
    deliverables:
      - backend/src/services/image_storage_service.py
      - backend/config/storage_config.py
    verification:
      - Service can upload images to cloud storage
      - Service generates valid image URLs
      - Error handling for upload failures works

  - id: TASK-003
    parent: "1.3"
    title: Create upload API endpoint
    status: pending
    complexity: M
    estimated_hours: 3-5
    dependencies: [TASK-002]
    agent: backend-architect
    deliverables:
      - backend/src/routes/profile_picture_routes.py
    verification:
      - POST /api/v1/users/{id}/profile-picture endpoint exists
      - Accepts multipart/form-data
      - Returns 201 with image URL on success
      - Returns 400 for invalid file types

  - id: TASK-004
    parent: "1.4"
    title: Add image validation and processing
    status: pending
    complexity: M
    estimated_hours: 3-4
    dependencies: [TASK-002]
    agent: backend-architect
    deliverables:
      - backend/src/services/image_processor.py
    verification:
      - Validates file type (jpg, png, webp)
      - Validates file size (max 5MB)
      - Resizes images to standard dimensions
      - Generates thumbnail version

  # Phase 2: Mobile UI Implementation
  - id: TASK-005
    parent: "2.1"
    title: Design profile picture widget
    status: pending
    complexity: M
    estimated_hours: 2-3
    dependencies: []
    agent: mobile-developer
    deliverables:
      - mobile/lib/widgets/profile_picture_avatar.dart
    verification:
      - Widget displays circular avatar
      - Shows placeholder when no image
      - Handles loading states
      - Widget tests pass

  - id: TASK-006
    parent: "2.2"
    title: Implement camera/gallery picker
    status: pending
    complexity: M
    estimated_hours: 3-4
    dependencies: [TASK-005]
    agent: mobile-developer
    deliverables:
      - mobile/lib/services/image_picker_service.dart
    verification:
      - Can pick from camera
      - Can pick from gallery
      - Returns File object
      - Handles permissions properly

  - id: TASK-007
    parent: "2.3"
    title: Add image cropping functionality
    status: pending
    complexity: L
    estimated_hours: 4-6
    dependencies: [TASK-006]
    agent: mobile-developer
    deliverables:
      - mobile/lib/screens/image_crop_screen.dart
    verification:
      - User can crop to square
      - Zoom and pan work correctly
      - Cancel and confirm actions work
      - Returns cropped image file

  - id: TASK-008
    parent: "2.4"
    title: Integrate with upload API
    status: pending
    complexity: M
    estimated_hours: 2-4
    dependencies: [TASK-003, TASK-007]
    agent: mobile-developer
    deliverables:
      - mobile/lib/services/profile_picture_service.dart
    verification:
      - Uploads image to backend API
      - Shows upload progress
      - Handles upload errors
      - Updates UI on success

  # Phase 3: Testing
  - id: TASK-009
    parent: "3.1"
    title: Add backend unit tests
    status: pending
    complexity: M
    estimated_hours: 3-4
    dependencies: [TASK-004]
    agent: qa-engineer
    deliverables:
      - backend/tests/test_image_storage_service.py
      - backend/tests/test_image_processor.py
      - backend/tests/test_profile_picture_routes.py
    verification:
      - Coverage >= 85% for new code
      - All edge cases tested
      - Mock external dependencies

  - id: TASK-010
    parent: "3.2"
    title: Add mobile widget tests
    status: pending
    complexity: M
    estimated_hours: 2-3
    dependencies: [TASK-008]
    agent: qa-engineer
    deliverables:
      - mobile/test/widgets/profile_picture_avatar_test.dart
      - mobile/test/screens/image_crop_screen_test.dart
    verification:
      - Widget tests pass
      - Coverage >= 85% for UI components
      - Golden tests for visual regression

  - id: TASK-011
    parent: "3.3"
    title: Perform integration testing
    status: pending
    complexity: L
    estimated_hours: 4-6
    dependencies: [TASK-009, TASK-010]
    agent: qa-engineer
    deliverables:
      - mobile/integration_test/profile_picture_flow_test.dart
    verification:
      - End-to-end flow works (pick → crop → upload)
      - Backend API integration verified
      - Error scenarios handled correctly
```

---

## Test Execution

### Phase 1: Forward Sync (A.1 → A.2)

**Action**: Run `task-planner` to generate detailed-tasks.yaml from tasks.md

**Expected Results**:
- ✅ All 11 tasks from tasks.md (1.1-1.4, 2.1-2.4, 3.1-3.3) have corresponding TASK-{NNN} entries
- ✅ Parent field correctly links to tasks.md numbering (TASK-001.parent = "1.1", etc.)
- ✅ Dependencies correctly identify task relationships
- ✅ Agent assignments appropriate for task types
- ✅ Automatic validation runs: `openspec validate --numbering user-profile-picture`

**Validation Command**:
```bash
openspec validate --sync user-profile-picture
```

**Expected Output**:
```
✅ OpenSpec Validation: user-profile-picture

📊 Summary:
  Total tasks in tasks.md: 11
  Total tasks in detailed-tasks.yaml: 11
  Synchronized tasks: 11
  Desynchronized tasks: 0

✅ Parent references: Valid
✅ Title consistency: 100%
✅ Status synchronization: Aligned
```

### Phase 2: Task Execution (B.2)

**Action**: Complete TASK-001, TASK-002, and TASK-005

**Updates to detailed-tasks.yaml**:
```yaml
tasks:
  - id: TASK-001
    parent: "1.1"
    status: completed  # Changed from pending
    completed_at: "2025-12-21T14:00:00+08:00"

  - id: TASK-002
    parent: "1.2"
    status: completed  # Changed from pending
    completed_at: "2025-12-21T16:30:00+08:00"

  - id: TASK-005
    parent: "2.1"
    status: completed  # Changed from pending
    completed_at: "2025-12-21T15:00:00+08:00"
```

**Expected State**: tasks.md NOT YET updated (backward sync pending)

### Phase 3: Backward Sync (D.1)

**Action**: Run `progress-updater` after task completion

**Expected Updates to tasks.md**:
```markdown
## 1. Backend API Development

- [x] 1.1 Design file upload data model
- [x] 1.2 Implement image storage service
- [ ] 1.3 Create upload API endpoint
- [ ] 1.4 Add image validation and processing

## 2. Mobile UI Implementation

- [x] 2.1 Design profile picture widget
- [ ] 2.2 Implement camera/gallery picker
- [ ] 2.3 Add image cropping functionality
- [ ] 2.4 Integrate with upload API
```

**Auto-validation**: `progress-updater` automatically runs `openspec validate --sync user-profile-picture --fix`

**Expected Validation Output**:
```
✅ OpenSpec Sync: user-profile-picture

📊 Synchronization Results:
  Updated checkboxes: 3 (1.1, 1.2, 2.1)

✅ Parent references: Valid
✅ Status synchronization: Aligned
```

### Phase 4: Conflict Detection Test

**Action**: Manually edit tasks.md to create deliberate mismatch

**Manual Edit** (simulate conflict):
```markdown
# Change task.md status without updating detailed-tasks.yaml
- [x] 1.3 Create upload API endpoint  # Marked complete but TASK-003 still pending
```

**Validation Command**:
```bash
openspec validate --sync user-profile-picture
```

**Expected Output** (conflict detected):
```
⚠️ OpenSpec Validation: user-profile-picture

📊 Summary:
  Total tasks in tasks.md: 11
  Total tasks in detailed-tasks.yaml: 11
  Synchronized tasks: 10
  Desynchronized tasks: 1

⚠️ Issues Found:
  1. TASK-003 status mismatch
     - tasks.md: [x] 1.3 (checked)
     - detailed-tasks.yaml: pending
     - Suggestion: Update detailed-tasks.yaml or revert tasks.md

✅ Parent references: Valid
✅ Title consistency: 100%
⚠️ Status synchronization: 1 mismatch detected
```

**Resolution**:
```bash
# Auto-fix will sync detailed-tasks.yaml to match tasks.md
openspec validate --sync user-profile-picture --fix
```

### Phase 5: Numbering Immutability Test

**Action**: Attempt to renumber tasks in tasks.md

**Invalid Edit** (simulate numbering violation):
```markdown
# BEFORE:
- [x] 1.1 Design file upload data model
- [x] 1.2 Implement image storage service
- [ ] 1.3 Create upload API endpoint

# AFTER (renumbered - VIOLATION):
- [x] 1.1 Implement image storage service  # Was 1.2
- [x] 1.2 Design file upload data model    # Was 1.1
- [ ] 1.3 Create upload API endpoint
```

**Validation Command**:
```bash
openspec validate --numbering user-profile-picture
```

**Expected Output** (numbering violation detected):
```
❌ Numbering Validation: user-profile-picture

⚠️ Critical Issues:
  1. Task renumbering detected
     - 1.1: Title changed from "Design file upload data model" to "Implement image storage service"
     - 1.2: Title changed from "Implement image storage service" to "Design file upload data model"
     - Risk: Parent references in detailed-tasks.yaml may be broken

⚠️ Recommendation:
  Task numbering is immutable once created. Reverting changes is recommended.
  To add new tasks, use next available numbers (e.g., 1.5, 1.6).
```

**Prevention**: `task-planner` validates numbering hasn't changed when re-executing on existing Spec

---

## Test Success Criteria

### Functional Requirements

- [x] **FR-1**: tasks.md uses checkbox format with hierarchical numbering (1.1, 1.2, 2.1)
- [x] **FR-2**: detailed-tasks.yaml contains TASK-{NNN} IDs with parent field linking to tasks.md
- [x] **FR-3**: Forward sync (A.1 → A.2) generates detailed-tasks.yaml from tasks.md
- [x] **FR-4**: Backward sync (D.1) updates tasks.md checkboxes when TASK status changes
- [x] **FR-5**: Validation commands detect synchronization mismatches
- [x] **FR-6**: Conflict detection warns about inconsistent status between layers
- [x] **FR-7**: Numbering immutability validation prevents task renumbering

### Data Integrity

- [x] **DI-1**: Every TASK has valid parent reference to existing tasks.md number
- [x] **DI-2**: Task titles are consistent between layers (with tolerance for minor edits)
- [x] **DI-3**: Task status synchronized: completed in YAML ↔ [x] in tasks.md
- [x] **DI-4**: No orphaned tasks (entries in one layer without corresponding entry in other)

### Skill Integration

- [x] **SI-1**: `task-planner` auto-runs `--numbering` validation after generating YAML
- [x] **SI-2**: `progress-updater` auto-runs `--sync --fix` after status updates
- [x] **SI-3**: `spec-drafter` auto-runs `--numbering` validation after creating tasks.md

### Error Handling

- [x] **EH-1**: Clear error messages when parent reference not found
- [x] **EH-2**: Actionable suggestions for resolving sync mismatches
- [x] **EH-3**: Warning (not error) for numbering violations to allow manual override
- [x] **EH-4**: `--fix` flag can auto-repair common synchronization issues

---

## Test Execution Log

### Execution 1: Initial Setup

| Step | Action | Result | Notes |
|------|--------|--------|-------|
| 1.1 | Create tasks.md with 11 tasks | ✅ Pass | File created with correct format |
| 1.2 | Run `task-planner` to generate YAML | ✅ Pass | All 11 TASK entries created |
| 1.3 | Validate with `--sync` command | ✅ Pass | 11/11 synchronized |
| 1.4 | Validate with `--numbering` command | ✅ Pass | No gaps, duplicates, or format issues |

### Execution 2: Task Completion Flow

| Step | Action | Result | Notes |
|------|--------|--------|-------|
| 2.1 | Update TASK-001 status to completed | ✅ Pass | YAML updated |
| 2.2 | Run `progress-updater` | ✅ Pass | tasks.md checkbox auto-updated |
| 2.3 | Validate synchronization | ✅ Pass | Status aligned across layers |

### Execution 3: Conflict Detection

| Step | Action | Result | Notes |
|------|--------|--------|-------|
| 3.1 | Manually mark 1.3 as complete in tasks.md | ✅ Pass | File edited |
| 3.2 | Run `--sync` validation | ✅ Pass | Mismatch detected correctly |
| 3.3 | Run `--sync --fix` to auto-repair | ✅ Pass | Conflict resolved |

### Execution 4: Numbering Immutability

| Step | Action | Result | Notes |
|------|--------|--------|-------|
| 4.1 | Renumber tasks 1.1 and 1.2 | ✅ Pass | File edited |
| 4.2 | Run `--numbering` validation | ✅ Pass | Violation detected |
| 4.3 | Revert numbering changes | ✅ Pass | Validation passes after revert |

---

## Known Limitations

1. **Title Similarity Threshold**: 80% similarity threshold may produce false positives for short task titles
2. **Manual Conflict Resolution**: Complex conflicts (e.g., both layers edited simultaneously) require manual review
3. **Numbering Detection**: Relies on title matching; if title AND number both change, detection may fail

---

## Related Documents

- [Dual-Layer Architecture Proposal](./proposal.md)
- [Phase A: Spec Planning](../../../core/ten-step-cycle/phase-a-spec-planning.md)
- [OpenSpec Validation Guide](../../VALIDATION.md)
- [OpenSpec Templates](../../templates/README.md)

---

**Test Status**: ✅ All criteria met
**Last Executed**: 2025-12-21
**Next Review**: After completing Phase 5 enhancements
