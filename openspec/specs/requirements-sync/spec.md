# requirements-sync Specification

> **Version**: 1.0.0
> **Status**: Active
> **Created**: 2026-01-01
> **Layer**: Layer 2 (Business Skill)
> **Category**: Requirements Skills

---

## Overview

The `requirements-sync` Skill synchronizes User Story status from files to UPM requirements section, detects drift, and maintains status consistency.

---

## Requirements

### Requirement: Story Scanning

requirements-sync Skill MUST scan User Story files and extract status information.

#### Scenario: Scan Story Directory
- Given `docs/requirements/user-stories/` directory exists
- When requirements-sync scans stories
- Then it MUST find all `US-*.md` files
- And it MUST parse each file's header for status field

#### Scenario: Extract Story Status
- Given a Story file with header `> **Status**: ready`
- When requirements-sync parses the file
- Then it MUST extract status value "ready"
- And it MUST handle all valid status values:
  - draft, ready, in_progress, done, blocked

#### Scenario: Handle Missing Status
- Given a Story file without Status field
- When requirements-sync parses the file
- Then it MUST default to status "draft"
- And it MUST log a warning

---

### Requirement: UPM Update

requirements-sync Skill MUST update UPM requirements section with scanned data.

#### Scenario: Update Story Counts
- Given scanned Stories with status distribution
- When requirements-sync updates UPM
- Then it MUST update `requirements.user_stories`:
  ```yaml
  user_stories:
    total: 8
    draft: 1
    ready: 3
    in_progress: 2
    done: 2
    blocked: 0
  ```

#### Scenario: Update PRD Reference
- Given a current PRD file exists
- When requirements-sync updates UPM
- Then it MUST update `requirements.prd`:
  ```yaml
  prd:
    id: "prd-v2.1.0-xxx"
    status: approved
    path: "docs/requirements/prd-v2.1.0-xxx.md"
  ```

#### Scenario: Preserve Other UPM Fields
- Given UPM has other fields (currentPhase, currentCycle, etc.)
- When requirements-sync updates UPM
- Then it MUST NOT modify non-requirements fields
- And it MUST preserve existing structure

---

### Requirement: Drift Detection

requirements-sync Skill MUST detect discrepancies between UPM and actual Story status.

#### Scenario: Detect Count Mismatch
- Given UPM shows `user_stories.total: 5`
- And actual Story files count is 8
- When requirements-sync detects drift
- Then it MUST report drift item:
  ```yaml
  drift:
    field: "user_stories.total"
    upm_value: 5
    actual_value: 8
  ```

#### Scenario: Detect Status Distribution Mismatch
- Given UPM shows `user_stories.ready: 3`
- And actual ready Stories count is 5
- When requirements-sync detects drift
- Then it MUST report the discrepancy

#### Scenario: Generate Drift Report
- When drift detection completes
- Then it MUST output:
  ```yaml
  drift_detected: true/false
  drift_items:
    - field: "..."
      upm_value: X
      actual_value: Y
      suggested_action: "update"
  ```

---

### Requirement: Sync Modes

requirements-sync Skill MUST support multiple sync modes.

#### Scenario: Check Mode
- Given mode is "check"
- When requirements-sync executes
- Then it MUST scan stories and detect drift
- And it MUST NOT modify any files
- And it MUST output drift report only

#### Scenario: Update Mode
- Given mode is "update"
- When requirements-sync executes
- Then it MUST scan stories
- And it MUST update UPM requirements section
- And it MUST report what was changed

#### Scenario: Interactive Mode
- Given mode is "interactive"
- When drift is detected
- Then it MUST prompt user for each drift item:
  - "Update UPM field X from Y to Z? [y/n]"
- And it MUST apply only confirmed changes

---

### Requirement: Output Format

requirements-sync Skill MUST output structured sync results.

#### Scenario: Sync Result Structure
- When sync completes
- Then output MUST include:
  ```yaml
  sync_result:
    mode: "check|update|interactive"
    scanned_stories: N
    status_distribution:
      draft: N
      ready: N
      in_progress: N
      done: N
      blocked: N
    drift_detected: true/false
    drift_items: [...]
    upm_updated: true/false
    changes_made: [...]
  ```

---

## Cross-References

- Related: `requirements-validator` - Should run before sync
- Related: `upm-requirements` - Target of sync
- Related: `forgejo-sync` - Can run after sync
- Depends: UPM spec at `standards/core/upm/unified-progress-management-spec.md`

---

## Implementation Notes

### Skill Location
`.claude/skills/requirements-sync/`

### Files
- `SKILL.md` - Skill definition and instructions

### Integration
This skill is invoked by:
1. `state-scanner` - For requirements status updates
2. `workflow-runner` - As part of requirements-update workflow
3. Direct user invocation - `/requirements-sync`
