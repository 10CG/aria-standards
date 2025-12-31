# Requirements Skills Summary (Aria v3.0)

> **Sources**: `.claude/skills/requirements-*/`, `.claude/skills/forgejo-sync/`

## Overview

Aria v3.0 introduces Requirements Management Skills for PRD/User Story tracking and optional Forgejo integration.

## Skill Hierarchy

```yaml
Layer 3 (Entry):
  - state-scanner: Detects requirements status, recommends workflows

Layer 2 (Business):
  - requirements-validator: PRD/Story validation
  - requirements-sync: Story ↔ UPM synchronization
  - forgejo-sync: Story ↔ Issue, PRD → Wiki

Layer 1 (Atomic):
  - validate-docs: Document format validation
  - progress-updater: UPM updates
```

## Skills Quick Reference

| Skill | Purpose | Trigger |
|-------|---------|---------|
| **requirements-validator** | Validate PRD/Story format | `/requirements-check` |
| **requirements-sync** | Sync Story status to UPM | `/requirements-update` |
| **forgejo-sync** | Sync with Forgejo Issues/Wiki | `/forgejo-sync` |

## Requirements Validator

```yaml
Functions:
  validate-prd: Check PRD format, required fields
  validate-story: Check Story format, status validity
  check-associations: Verify PRD ↔ Story links
  coverage-analysis: Calculate Story coverage

Modes:
  full: Complete validation
  quick: Format only
  check: Status report (no errors)
```

## Requirements Sync

```yaml
Functions:
  scan-stories: Find all Story files
  update-upm: Sync Story status to UPM
  detect-drift: Find discrepancies

Modes:
  full: Complete sync
  update: UPM only
  report: Dry-run
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
*For details: `.claude/skills/requirements-*/`, `standards/workflow/requirements-workflows.md`*
