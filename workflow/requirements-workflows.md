# Requirements Workflows

> **Version**: 1.0.0
> **Created**: 2026-01-01
> **Category**: Aria Skills - Requirements Management

---

## Overview

This document defines composite workflows for requirements management in Aria Methodology. These workflows orchestrate multiple Skills to complete complex requirements-related tasks.

---

## Workflow Definitions

### 1. requirements-check

**Purpose**: Validate requirements documents before proceeding with development.

```yaml
workflow: requirements-check
description: 验证需求文档完整性
trigger:
  - manual: "/requirements-check"
  - pre-commit (optional)

steps:
  - name: validate
    skill: requirements-validator
    mode: full
    required: true

  - name: forgejo-status
    skill: forgejo-sync
    action: status-check
    required: false  # Optional: only if Forgejo configured

  - name: scan
    skill: state-scanner
    focus: requirements
    required: true

output:
  - validation_result
  - drift_report (if Forgejo enabled)
  - state_summary
```

**When to Use**:
- Before starting a new development cycle
- Before creating an OpenSpec
- As part of PR review

---

### 2. requirements-update

**Purpose**: Synchronize Story status to UPM and optionally to Forgejo.

```yaml
workflow: requirements-update
description: 同步 Story 状态到 UPM 和 Forgejo
trigger:
  - manual: "/requirements-update"
  - after: story-status-change

steps:
  - name: validate
    skill: requirements-validator
    mode: quick
    required: true

  - name: sync-upm
    skill: requirements-sync
    mode: update
    required: true

  - name: sync-forgejo
    skill: forgejo-sync
    action: bulk-sync
    required: false  # Optional: only if Forgejo configured

output:
  - sync_result
  - upm_changes
  - forgejo_changes (if enabled)
```

**When to Use**:
- After completing a Story
- After changing Story status
- During iteration retrospective

---

### 3. create-story

**Purpose**: Create a new User Story and publish to Forgejo.

```yaml
workflow: create-story
description: 创建 Story 并发布到 Forgejo
trigger:
  - manual: "/create-story"

steps:
  - name: create-file
    action: create-story-file
    template: user-story-template.md
    required: true

  - name: validate
    skill: requirements-validator
    target: new-story
    required: true

  - name: publish-issue
    skill: forgejo-sync
    action: story-to-issue
    required: false  # Optional: only if Forgejo configured

  - name: update-upm
    skill: requirements-sync
    mode: update
    required: true

output:
  - story_file_path
  - issue_url (if Forgejo enabled)
  - upm_updated
```

**When to Use**:
- Adding a new feature requirement
- Breaking down PRD into Stories

---

### 4. iteration-planning

**Purpose**: Comprehensive requirements review at iteration start.

```yaml
workflow: iteration-planning
description: 迭代开始时的需求盘点
trigger:
  - manual: "/iteration-planning"

steps:
  - name: full-validate
    skill: requirements-validator
    mode: full
    required: true

  - name: sync-upm
    skill: requirements-sync
    mode: update
    required: true

  - name: sync-forgejo
    skill: forgejo-sync
    action: bulk-sync
    required: false

  - name: generate-report
    skill: state-scanner
    focus: requirements
    output: planning-report
    required: true

output:
  - validation_report
  - coverage_analysis
  - planning_recommendations
```

**When to Use**:
- Sprint/iteration kickoff
- Weekly planning meetings
- Milestone preparation

---

### 5. publish-prd

**Purpose**: Publish approved PRD to Forgejo Wiki.

```yaml
workflow: publish-prd
description: 发布 PRD 到 Forgejo Wiki
trigger:
  - manual: "/publish-prd"
  - on: prd-status-approved (optional)

steps:
  - name: validate-prd
    skill: requirements-validator
    target: prd
    required: true

  - name: publish-wiki
    skill: forgejo-sync
    action: prd-to-wiki
    required: true

  - name: update-index
    skill: forgejo-sync
    action: prd-index
    required: false

output:
  - wiki_page_url
  - index_updated
```

**When to Use**:
- After PRD approval
- When sharing PRD with stakeholders

---

## Workflow Trigger Summary

| Workflow | Manual Command | Automatic Trigger |
|----------|----------------|-------------------|
| requirements-check | `/requirements-check` | pre-commit (opt) |
| requirements-update | `/requirements-update` | story-status-change |
| create-story | `/create-story` | - |
| iteration-planning | `/iteration-planning` | - |
| publish-prd | `/publish-prd` | prd-approved (opt) |

---

## Skill Dependencies

```
┌─────────────────────────────────────────────────────────────┐
│  requirements-check                                         │
│  ├── requirements-validator (required)                      │
│  ├── forgejo-sync (optional)                               │
│  └── state-scanner (required)                              │
├─────────────────────────────────────────────────────────────┤
│  requirements-update                                        │
│  ├── requirements-validator (required)                      │
│  ├── requirements-sync (required)                          │
│  └── forgejo-sync (optional)                               │
├─────────────────────────────────────────────────────────────┤
│  create-story                                               │
│  ├── (file creation)                                       │
│  ├── requirements-validator (required)                      │
│  ├── forgejo-sync (optional)                               │
│  └── requirements-sync (required)                          │
├─────────────────────────────────────────────────────────────┤
│  iteration-planning                                         │
│  ├── requirements-validator (required)                      │
│  ├── requirements-sync (required)                          │
│  ├── forgejo-sync (optional)                               │
│  └── state-scanner (required)                              │
├─────────────────────────────────────────────────────────────┤
│  publish-prd                                                │
│  ├── requirements-validator (required)                      │
│  └── forgejo-sync (required)                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Configuration

### Forgejo Integration (Optional)

To enable Forgejo-related steps, configure in `CLAUDE.local.md`:

```yaml
forgejo:
  url: "https://forgejo.example.com"
  api_token: "${FORGEJO_TOKEN}"
  repo: "owner/repo"
```

Without this configuration, Forgejo-related steps will be skipped.

---

## Related Documents

- **Skills**: `.claude/skills/requirements-*/`
- **UPM Extension**: `standards/core/upm/upm-requirements-extension.md`
- **Templates**: `standards/templates/`
