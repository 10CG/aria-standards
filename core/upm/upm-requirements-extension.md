# UPM Requirements Extension

> **Version**: 1.0.0
> **Status**: Active
> **Created**: 2026-01-01
> **Parent**: unified-progress-management-spec.md

---

## Overview

This extension defines the optional `requirements` section for UPM, enabling requirements tracking and synchronization with external systems like Forgejo.

---

## Schema Definition

### Full Schema (Large Projects)

```yaml
requirements:
  prd:
    id: "prd-{version}-{feature}"        # Required: PRD identifier
    status: draft | approved | superseded # Required: PRD status
    path: "docs/requirements/prd-*.md"    # Required: File path
    wiki_page: "PRD-{version}-{feature}"  # Optional: Forgejo Wiki page name
    wiki_synced_at: "ISO8601 timestamp"   # Optional: Last wiki sync time
  user_stories:
    total: {number}                       # Required: Total story count
    draft: {number}                       # Optional: Draft stories (default: 0)
    ready: {number}                       # Required: Ready for implementation
    in_progress: {number}                 # Required: Currently in development
    done: {number}                        # Required: Completed stories
    blocked: {number}                     # Optional: Blocked stories (default: 0)
  forgejo:
    enabled: true | false                 # Optional: Forgejo integration enabled
    milestone: "{version}"                # Optional: Associated milestone
    synced_at: "ISO8601 timestamp"        # Optional: Last sync time
```

### Simplified Schema (Small Projects)

```yaml
requirements:
  current_prd: "docs/requirements/prd-*.md"  # Path to current PRD
  pending_stories: {number}                   # Stories not yet completed
```

---

## Field Definitions

### PRD Section

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique PRD identifier, pattern: `prd-{version}-{feature}` |
| `status` | enum | Yes | One of: `draft`, `approved`, `superseded` |
| `path` | string | Yes | Relative path to PRD file |
| `wiki_page` | string | No | Forgejo Wiki page name if published |
| `wiki_synced_at` | string | No | ISO8601 timestamp of last wiki sync |

### User Stories Section

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `total` | number | Yes | - | Total number of user stories |
| `draft` | number | No | 0 | Stories in draft status |
| `ready` | number | Yes | - | Stories ready for implementation |
| `in_progress` | number | Yes | - | Stories currently being implemented |
| `done` | number | Yes | - | Completed stories |
| `blocked` | number | No | 0 | Blocked stories |

**Constraint**: `draft + ready + in_progress + done + blocked = total`

### Forgejo Section

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `enabled` | boolean | No | false | Whether Forgejo integration is active |
| `milestone` | string | No | - | Associated Forgejo milestone |
| `synced_at` | string | No | - | Last Forgejo sync timestamp |

---

## Status Definitions

### PRD Status

| Status | Meaning | Allowed Actions |
|--------|---------|-----------------|
| `draft` | PRD is being written | Edit PRD, add stories |
| `approved` | PRD is finalized | Create OpenSpec, start implementation |
| `superseded` | Newer version exists | Reference only, no new work |

### User Story Status

| Status | Meaning | Allowed Actions |
|--------|---------|-----------------|
| `draft` | Story being refined | Edit story, not ready for dev |
| `ready` | Story approved for implementation | Create OpenSpec, start coding |
| `in_progress` | Active development | Continue development, update progress |
| `done` | Implementation complete | Close, archive |
| `blocked` | Cannot proceed | Resolve blocker, escalate |

---

## Usage Examples

### Example 1: Full Requirements Tracking

```yaml
# In UPM file header
---
currentPhase: Implementation
currentCycle: 5
requirements:
  prd:
    id: "prd-v2.1.0-notification"
    status: approved
    path: "docs/requirements/prd-v2.1.0-notification.md"
    wiki_page: "PRD-v2.1.0-notification"
    wiki_synced_at: "2026-01-01T10:00:00+08:00"
  user_stories:
    total: 8
    draft: 1
    ready: 3
    in_progress: 2
    done: 2
    blocked: 0
  forgejo:
    enabled: true
    milestone: "v2.1.0"
    synced_at: "2026-01-01T10:30:00+08:00"
---
```

### Example 2: Simplified Tracking

```yaml
# In UPM file header
---
currentPhase: Planning
currentCycle: 1
requirements:
  current_prd: "docs/requirements/prd-v2.1.0.md"
  pending_stories: 5
---
```

### Example 3: No Requirements (Optional)

```yaml
# In UPM file header - requirements section omitted
---
currentPhase: Implementation
currentCycle: 3
---
```

---

## Backward Compatibility

The `requirements` section is **optional**. Existing UPM files without this section will continue to work normally. Tools MUST handle missing requirements gracefully:

```python
# Example handling
requirements = upm.get('requirements', {})
if not requirements:
    # No requirements tracking configured
    return RequirementsStatus(configured=False)
```

---

## Validation Rules

### Rule 1: Status Consistency

If `prd.status` is `draft`, user stories SHOULD NOT be `in_progress` or `done`.

### Rule 2: Count Integrity

Sum of all status counts MUST equal `total`:
```
draft + ready + in_progress + done + blocked == total
```

### Rule 3: Forgejo Sync Dependency

If `forgejo.enabled` is `true`, user stories with `ready` or higher status SHOULD have associated Forgejo Issues.

---

## Related Skills

| Skill | Interaction |
|-------|-------------|
| `requirements-validator` | Validates requirements section structure |
| `requirements-sync` | Updates user_stories counts from files |
| `forgejo-sync` | Updates forgejo section, wiki_page fields |
| `state-scanner` | Reads requirements for recommendations |

---

## Related Documents

- `standards/core/upm/unified-progress-management-spec.md` - Parent UPM spec
- `standards/templates/prd-template.md` - PRD template
- `standards/templates/user-story-template.md` - User Story template
- `openspec/changes/evolve-ai-ddd-system/specs/upm-requirements/spec.md` - OpenSpec delta
