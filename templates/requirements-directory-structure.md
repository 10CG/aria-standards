# Requirements Directory Structure

> **Version**: 1.0.0
> **Created**: 2026-01-01
> **Related**: prd-template.md, user-story-template.md

---

## Overview

This document defines the standard directory structure for requirements documents in Aria Methodology projects.

---

## Directory Structure

```
{module}/docs/requirements/
├── prd-{version}-{feature}.md       # PRD 文档
├── user-stories/                     # User Story 目录
│   ├── US-001-{title}.md
│   ├── US-002-{title}.md
│   └── ...
└── README.md                         # 需求目录说明 (可选)
```

---

## File Naming Conventions

### PRD Files

**Pattern**: `prd-{version}-{feature-slug}.md`

| Component | Format | Example |
|-----------|--------|---------|
| version | `v{major}.{minor}.{patch}` | v2.1.0 |
| feature-slug | kebab-case | notification-system |

**Examples**:
```
prd-v2.1.0-notification-system.md
prd-v1.0.0-user-authentication.md
prd-v3.0.0-payment-integration.md
```

### User Story Files

**Pattern**: `US-{NNN}-{title-slug}.md`

| Component | Format | Example |
|-----------|--------|---------|
| NNN | 3-digit number | 001, 042, 123 |
| title-slug | kebab-case | push-notification |

**Examples**:
```
US-001-push-notification.md
US-002-notification-settings.md
US-003-notification-history.md
```

---

## Module Paths

Different modules may have slightly different paths based on their structure:

| Module | Requirements Path |
|--------|-------------------|
| Mobile | `mobile/docs/requirements/` |
| Backend | `backend/docs/requirements/` |
| Shared | `shared/docs/requirements/` |

---

## Example Directory

```
mobile/docs/requirements/
├── prd-v2.1.0-notification.md
├── prd-v2.0.0-task-management.md   # Previous version (superseded)
├── user-stories/
│   ├── US-001-push-notification.md
│   ├── US-002-notification-settings.md
│   ├── US-003-notification-history.md
│   ├── US-004-task-creation.md
│   ├── US-005-task-editing.md
│   └── US-006-task-deletion.md
└── README.md
```

---

## README.md Template

```markdown
# Requirements Documentation

## Current PRD

- [PRD v2.1.0 - Notification System](./prd-v2.1.0-notification.md) - **approved**

## User Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| US-001 | Push Notification | in_progress | HIGH |
| US-002 | Notification Settings | ready | MEDIUM |
| US-003 | Notification History | draft | LOW |

## Archived PRDs

- [PRD v2.0.0 - Task Management](./prd-v2.0.0-task-management.md) - superseded
```

---

## Integration with UPM

The requirements directory is tracked in UPM's `requirements` section:

```yaml
requirements:
  prd:
    id: "prd-v2.1.0-notification"
    status: approved
    path: "mobile/docs/requirements/prd-v2.1.0-notification.md"
  user_stories:
    total: 6
    ready: 2
    in_progress: 1
    done: 0
```

---

## Integration with Forgejo

When Forgejo integration is enabled:

1. **User Stories** sync to **Issues**
   - Story file → Issue (bidirectional sync)
   - Status mapping: ready → open, done → closed

2. **PRD** publishes to **Wiki** (optional)
   - PRD file → Wiki page (one-way publish)
   - Only approved PRDs are published

---

## Related Templates

- [PRD Template](./prd-template.md)
- [User Story Template](./user-story-template.md)

---

## Related Skills

| Skill | Function |
|-------|----------|
| `requirements-validator` | Validates file naming and structure |
| `requirements-sync` | Syncs story status to UPM |
| `forgejo-sync` | Syncs stories to Issues, PRD to Wiki |
