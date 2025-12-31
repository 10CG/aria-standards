# upm-requirements Specification

> **Change**: evolve-ai-ddd-system
> **Type**: ADDED
> **Purpose**: Define requirements tracking extension for UPM

---

## ADDED Requirements

### Requirement: Requirements Section Schema

UPM YAML header MAY include a `requirements` section to track PRD and User Story status.

#### Scenario: Full Requirements Section
- Given a project tracking requirements in UPM
- When UPM file is parsed
- Then the `requirements` section MUST follow this schema:
  ```yaml
  requirements:
    prd:
      id: "prd-{version}-{feature}"      # Required
      status: draft | approved | superseded  # Required
      path: "docs/requirements/prd-*.md"     # Required
      wiki_page: "PRD-{version}-{feature}"   # Optional: Forgejo Wiki page name
      wiki_synced_at: "ISO8601 timestamp"    # Optional: Last wiki sync time
    user_stories:
      total: {number}       # Required
      ready: {number}       # Required (can start implementation)
      in_progress: {number} # Required
      done: {number}        # Required
      blocked: {number}     # Optional, default 0
  ```

#### Scenario: Simplified Requirements Section
- Given a small project preferring minimal tracking
- When UPM file is parsed
- Then the `requirements` section MAY use simplified format:
  ```yaml
  requirements:
    current_prd: "docs/requirements/prd-*.md"
    pending_stories: {number}
  ```

#### Scenario: No Requirements Section
- Given a project not using requirements tracking
- When UPM file is parsed
- Then the absence of `requirements` section MUST be valid
- And tools MUST NOT fail when section is missing

---

### Requirement: PRD Status Values

PRD status field MUST use defined status values with clear semantics.

#### Scenario: PRD Status Draft
- Given a PRD with status `draft`
- Then it indicates PRD is being written
- And User Stories SHOULD NOT be marked as `ready`

#### Scenario: PRD Status Approved
- Given a PRD with status `approved`
- Then it indicates PRD is finalized
- And User Stories MAY be marked as `ready` for implementation

#### Scenario: PRD Status Superseded
- Given a PRD with status `superseded`
- Then it indicates a newer version exists
- And the new PRD SHOULD be referenced in place

#### Scenario: PRD Wiki Fields
- Given a PRD published to Forgejo Wiki
- Then `wiki_page` field SHOULD contain the Wiki page name
- And `wiki_synced_at` field SHOULD contain ISO8601 timestamp
- And these fields are optional (only set after wiki publish)

---

### Requirement: User Story Status Tracking

User Story counts in UPM MUST reflect actual status distribution.

#### Scenario: Story Count Accuracy
- Given User Story files in `docs/requirements/user-stories/`
- When UPM `user_stories` counts are updated
- Then the sum of ready + in_progress + done + blocked MUST equal total

#### Scenario: Ready Stories
- Given stories with status `ready`
- Then they are eligible for OpenSpec creation and implementation
- And state-scanner MAY recommend starting implementation

#### Scenario: In Progress Stories
- Given stories with status `in_progress`
- Then they have active OpenSpec or development work
- And they SHOULD be linked to an OpenSpec change

---

### Requirement: Requirements Directory Structure

Projects using requirements tracking SHOULD organize files in a standard structure.

#### Scenario: Standard Directory Layout
- Given a project with requirements tracking
- Then the directory structure SHOULD be:
  ```
  {module}/docs/requirements/
  ├── prd-{version}-{feature}.md
  └── user-stories/
      ├── US-001-{title}.md
      ├── US-002-{title}.md
      └── ...
  ```

#### Scenario: PRD File Naming
- Given a PRD file
- Then it SHOULD follow pattern: `prd-{version}-{feature-slug}.md`
- Example: `prd-v2.1.0-notification-system.md`

#### Scenario: User Story File Naming
- Given a User Story file
- Then it SHOULD follow pattern: `US-{NNN}-{title-slug}.md`
- Example: `US-001-push-notification.md`

---

## Cross-References

- Related: `intelligent-state-scanner` (uses this spec for requirements detection)
- Related: `forgejo-sync` (updates wiki_page and wiki_synced_at fields)
- Depends: PRD template at `standards/templates/prd-template.md`
- Depends: User Story template at `standards/templates/user-story-template.md`
