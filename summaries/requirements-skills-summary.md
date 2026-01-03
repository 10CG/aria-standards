# Requirements Skills Summary (Aria v3.0)

> **Sources**: `.claude/skills/requirements-*/`, `.claude/skills/forgejo-sync/`, `.claude/skills/arch-*/`
> **Updated**: 2026-01-04

## Overview

Aria v3.0 introduces Requirements Management Skills for PRD/User Story/System Architecture tracking and optional Forgejo integration.

## Skill Hierarchy

```yaml
Layer 3 (Entry):
  - state-scanner (v2.1): Detects requirements status, architecture chain, recommends workflows

Layer 2 (Business):
  - requirements-validator (v2.1): PRD/Story/Architecture validation + chain verification
  - requirements-sync (v1.1): Story/Architecture ↔ UPM synchronization
  - forgejo-sync: Story ↔ Issue, PRD → Wiki
  - arch-scaffolder (v1.0): Generate architecture skeleton from PRD

Layer 1 (Atomic):
  - validate-docs: Document format validation
  - progress-updater: UPM updates
```

## Skills Quick Reference

| Skill | Version | Purpose | Trigger |
|-------|---------|---------|---------|
| **requirements-validator** | v2.1 | Validate PRD/Story/Architecture + chain | `/requirements-check` |
| **requirements-sync** | v1.1 | Sync Story/Architecture to UPM | `/requirements-update` |
| **forgejo-sync** | v1.0 | Sync with Forgejo Issues/Wiki | `/forgejo-sync` |
| **arch-scaffolder** | v1.0 | Generate architecture from PRD | `/arch-scaffolder` |

## Requirements Validator (v2.1)

```yaml
Functions:
  validate-prd: Check PRD format, required fields
  validate-story: Check Story format, status validity
  check-associations: Verify PRD ↔ Story links
  coverage-analysis: Calculate Story coverage
  chain-validation: Verify PRD → Architecture → Stories chain (v2.1 NEW)

Modes:
  full: Complete validation
  quick: Format only
  check: Status report (no errors)
  chain: Chain integrity only (v2.1 NEW)

Chain Validation (v2.1):
  prd_to_architecture:
    - Architecture references parent PRD
    - Architecture created after PRD
  architecture_to_stories:
    - Stories created after Architecture
    - Module boundaries match
  chain_status:
    - All statuses consistent
    - OpenSpec linked to Stories
```

## Requirements Sync (v1.1)

```yaml
Functions:
  scan-stories: Find all Story files
  scan-architecture: Find System Architecture (v1.1 NEW)
  update-upm: Sync Story/Architecture status to UPM
  detect-drift: Find discrepancies (includes architecture)

Modes:
  full: Complete sync
  update: UPM only
  report: Dry-run

Architecture Sync (v1.1):
  scan_paths:
    primary: "docs/architecture/system-architecture.md"
    fallback: "{module}/docs/ARCHITECTURE.md"
  output:
    architecture_status:
      exists: true/false
      path: "..."
      status: draft/active/outdated
      last_updated: "ISO8601"
      parent_prd: "prd-xxx"
```

## Arch Scaffolder (v1.0) - NEW

```yaml
Functions:
  analyze-prd: Extract architecture info from PRD
  generate-skeleton: Create architecture document skeleton
  suggest-decisions: Recommend technology decisions
  validate-output: Verify generated skeleton

Phases:
  1. PRD定位与验证: Locate and validate PRD
  2. PRD内容分析: Extract goals, scope, constraints
  3. 架构骨架生成: Generate 10-section template
  4. 智能建议: Suggest tech decisions and next steps

Output:
  path: "docs/architecture/system-architecture.md"
  template: "standards/templates/system-architecture-template.md"
```

## Forgejo Sync

```yaml
Functions:
  story-to-issue: Create/update Issue from Story
  issue-to-story: Update Story from Issue
  bulk-sync: Sync all Stories
  prd-to-wiki: Publish PRD to Wiki (one-way)

Configuration: See .claude/skills/forgejo-sync/CONFIG.md
```

## Status Mapping

| Story Status | Forgejo Issue |
|--------------|---------------|
| draft | (no issue) |
| ready | open |
| in_progress | open + "in-progress" label |
| done | closed |
| blocked | open + "blocked" label |

## Composite Workflows

| Workflow | Skills Used | Trigger |
|----------|-------------|---------|
| requirements-check | validator → forgejo-sync → state-scanner | `/requirements-check` |
| requirements-update | validator → sync → forgejo-sync | `/requirements-update` |
| iteration-planning | validator → sync → forgejo-sync → state-scanner | `/iteration-planning` |
| publish-prd | validator → forgejo-sync | `/publish-prd` |

## Configuration

Requirements tracking is **optional**. Enable by:

1. Create `docs/requirements/` directory
2. Add `requirements:` section to UPM (optional)
3. Configure Forgejo in `CLAUDE.local.md` (optional)

---
*For details: `.claude/skills/requirements-*/`, `.claude/skills/arch-scaffolder/`, `standards/workflow/requirements-workflows.md`*
