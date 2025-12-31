# forgejo-sync Specification

> **Change**: evolve-ai-ddd-system
> **Type**: ADDED
> **Purpose**: Synchronize User Stories with Forgejo Issues

---

## ADDED Requirements

### Requirement: Story to Issue Creation

forgejo-sync Skill MUST create Forgejo Issues from User Story files.

#### Scenario: Create Issue from Story
- Given a Story file `US-001-push-notification.md`
- And Story has status "ready"
- And Story has no `Forgejo Issue` field
- When forgejo-sync creates issue
- Then it MUST call Forgejo API to create issue:
  - Title: "[US-001] Push Notification Feature"
  - Body: Story content + Acceptance Criteria
  - Labels: ["user-story", "priority:high"]
- And it MUST update Story file with `Forgejo Issue: #123`

#### Scenario: Set Issue Labels from Story
- Given a Story with Priority: HIGH
- When forgejo-sync creates issue
- Then it MUST set labels based on mapping:
  - Priority HIGH → "priority:high"
  - Priority MEDIUM → "priority:medium"
  - Priority LOW → "priority:low"
- And it MUST add status label (ready, in-progress, etc.)

#### Scenario: Set Issue Milestone
- Given a Story with `Forgejo Milestone: v2.1.0`
- When forgejo-sync creates issue
- Then it MUST set milestone on the issue
- And it MUST create milestone if not exists (optional)

---

### Requirement: Issue to Story Sync

forgejo-sync Skill MUST sync Issue status changes back to Story files.

#### Scenario: Sync Closed Issue
- Given Story US-001 has `Forgejo Issue: #123`
- And Issue #123 state is "closed"
- When forgejo-sync syncs from issue
- Then it MUST update Story status to "done"

#### Scenario: Sync Issue Labels
- Given Issue #123 has label "in-progress"
- When forgejo-sync syncs from issue
- Then it MUST update Story status to "in_progress"

#### Scenario: Handle Label Conflicts
- Given Issue has labels ["ready", "in-progress"]
- When forgejo-sync syncs from issue
- Then it MUST use priority: in-progress > ready > draft
- And it MUST log the conflict

---

### Requirement: Status Mapping

forgejo-sync Skill MUST map Story status to Issue status bidirectionally.

#### Scenario: Story to Issue Status Mapping
- When syncing Story to Issue
- Then it MUST apply mapping:
  | Story Status | Issue State | Issue Labels |
  |--------------|-------------|--------------|
  | draft        | open        | [draft]      |
  | ready        | open        | [ready]      |
  | in_progress  | open        | [in-progress]|
  | blocked      | open        | [blocked]    |
  | done         | closed      | []           |

#### Scenario: Issue to Story Status Mapping
- When syncing Issue to Story
- Then it MUST apply reverse mapping:
  | Issue State | Issue Labels    | Story Status |
  |-------------|-----------------|--------------|
  | open        | contains draft  | draft        |
  | open        | contains ready  | ready        |
  | open        | contains in-progress | in_progress |
  | open        | contains blocked | blocked     |
  | closed      | any             | done         |

---

### Requirement: Bulk Sync

forgejo-sync Skill MUST support bulk synchronization of all Stories.

#### Scenario: Bulk Create Issues
- Given multiple Story files without Forgejo Issue
- When forgejo-sync bulk-sync executes
- Then it MUST create Issues for all eligible Stories
- And it MUST update all Story files with Issue numbers
- And it MUST report created count

#### Scenario: Bulk Status Sync
- Given multiple Stories with Forgejo Issues
- When forgejo-sync bulk-sync executes
- Then it MUST sync status for all Stories
- And it MUST report updated count

#### Scenario: Rate Limiting
- Given bulk operation with 50+ Stories
- When forgejo-sync bulk-sync executes
- Then it MUST respect Forgejo API rate limits
- And it MUST use batch delays if needed

---

### Requirement: Status Check

forgejo-sync Skill MUST detect discrepancies between Story and Issue status.

#### Scenario: Detect Status Drift
- Given Story US-001 has status "ready"
- And Issue #123 has labels ["in-progress"]
- When forgejo-sync checks status
- Then it MUST report drift:
  ```yaml
  drift:
    story_id: "US-001"
    story_status: "ready"
    issue_status: "in_progress"
    suggested_sync: "issue-to-story"
  ```

#### Scenario: Suggest Sync Direction
- When drift is detected
- Then it MUST suggest sync direction based on:
  - Issue closed → Story should be "done"
  - Issue has later update → sync issue-to-story
  - Story has later update → sync story-to-issue

---

### Requirement: Configuration

forgejo-sync Skill MUST be configurable via config file.

#### Scenario: Config File Location
- When forgejo-sync initializes
- Then it MUST read config from:
  - `.claude/skills/forgejo-sync/CONFIG.md` or
  - `CLAUDE.local.md` forgejo section

#### Scenario: Required Config Fields
- Config MUST include:
  ```yaml
  forgejo:
    url: "https://forgejo.example.com"
    api_token: "${FORGEJO_TOKEN}"  # env var reference
    repo: "owner/repo"
  ```

#### Scenario: Optional Config Fields
- Config MAY include:
  ```yaml
  forgejo:
    default_labels: ["user-story"]
    auto_create_milestone: true
    sync_on_commit: false
  ```

---

### Requirement: Output Format

forgejo-sync Skill MUST output structured sync results.

#### Scenario: Sync Result Structure
- When sync completes
- Then output MUST include:
  ```yaml
  forgejo_sync_result:
    action: "story-to-issue|issue-to-story|bulk-sync|status-check"
    stories_processed: N
    issues_created: N
    issues_updated: N
    stories_updated: N
    drift_items: [...]
    errors: [...]
  ```

---

### Requirement: PRD to Wiki Publish

forgejo-sync Skill MUST support publishing PRD files to Forgejo Wiki.

#### Scenario: Publish PRD to Wiki
- Given a PRD file `docs/requirements/prd-v2.1.0-notification.md`
- And PRD has status "approved"
- When forgejo-sync publishes to wiki
- Then it MUST call Forgejo Wiki API to create/update page:
  - Page Name: "PRD-v2.1.0-notification"
  - Content: PRD markdown content
  - Footer: Source path, sync timestamp, read-only notice
- And it MUST update UPM `requirements.prd.wiki_page` field

#### Scenario: Generate Wiki Footer
- When publishing PRD to Wiki
- Then it MUST append footer:
  ```markdown
  ---
  > 📄 **Source**: `docs/requirements/prd-v2.1.0-xxx.md`
  > 🔄 **Last Synced**: 2025-12-31T10:00:00+08:00
  > ⚠️ **Note**: 此页面由 Git 自动同步，请勿直接编辑
  ```

#### Scenario: Update Existing Wiki Page
- Given PRD already has wiki page published
- And PRD content has changed
- When forgejo-sync publishes to wiki
- Then it MUST update existing page (not create duplicate)
- And it MUST update sync timestamp

#### Scenario: Generate PRD Index Page
- Given multiple PRD files have been published
- When forgejo-sync runs prd-index action
- Then it MUST create/update "PRD-Index" wiki page
- And it MUST list all published PRDs with links and status

#### Scenario: Skip Draft PRD
- Given a PRD file with status "draft"
- When forgejo-sync attempts to publish
- Then it MUST skip the file
- And it MUST log "Skipping draft PRD: {filename}"

#### Scenario: Manual Trigger
- When user runs `/prd-to-wiki` command
- Then it MUST scan all approved PRD files
- And it MUST publish each to Wiki
- And it MUST report publish count

---

### Requirement: Wiki Configuration

forgejo-sync Skill MUST support Wiki-specific configuration.

#### Scenario: Wiki Config Fields
- Config MAY include:
  ```yaml
  forgejo:
    wiki:
      enabled: true
      auto_publish_on_approve: false
      page_prefix: "PRD-"
      generate_index: true
  ```

#### Scenario: Disable Wiki Sync
- Given `forgejo.wiki.enabled: false`
- When prd-to-wiki action runs
- Then it MUST skip wiki operations
- And it MUST log "Wiki sync disabled"

---

## Cross-References

- Related: `requirements-validator` (validates stories before sync)
- Related: `requirements-sync` (updates UPM after forgejo sync)
- Related: `upm-requirements` (tracks forgejo sync status)
- External: Forgejo API documentation
- External: Forgejo Wiki API documentation
