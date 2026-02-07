# forgejo-sync Specification

> **Version**: 1.0.0
> **Status**: Active
> **Created**: 2026-01-01
> **Layer**: Layer 2 (Business Skill)
> **Category**: Requirements Skills

---

## Overview

The `forgejo-sync` Skill synchronizes User Stories with Forgejo Issues and optionally publishes PRD to Forgejo Wiki. It provides bidirectional sync for Stories and one-way publish for PRD.

---

## Requirements

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
  > **Source**: `docs/requirements/prd-v2.1.0-xxx.md`
  > **Last Synced**: 2026-01-01T10:00:00+08:00
  > **Note**: This page is auto-synced from Git. Do not edit directly.
  ```

#### Scenario: Skip Draft PRD
- Given a PRD file with status "draft"
- When forgejo-sync attempts to publish
- Then it MUST skip the file
- And it MUST log "Skipping draft PRD: {filename}"

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
    wiki:
      enabled: true
      page_prefix: "PRD-"

    # Cloudflare Access support (v1.1.0+)
    cloudflare_access:
      enabled: false  # default
      client_id_env: "CF_ACCESS_CLIENT_ID"
      client_secret_env: "CF_ACCESS_CLIENT_SECRET"
  ```

---

### Requirement: Cloudflare Access Support

> **Added**: v1.1.0

forgejo-sync Skill MUST support Cloudflare Access protected Forgejo instances.

#### Scenario: Detect Cloudflare Access Before API Call
- Given forgejo API call is about to be executed
- When AI prepares the API call
- Then it MUST check `forgejo.cloudflare_access.enabled`:
  - If `enabled == true`: Add CF Access headers to all API calls
  - If `enabled == false/undefined`: Use standard authentication

#### Scenario: Cloudflare Access Headers
- Given `cloudflare_access.enabled == true`
- When forgejo-sync calls Forgejo API
- Then it MUST add the following headers:
  ```yaml
  required_headers:
    - "CF-Access-Client-Id: ${CF_ACCESS_CLIENT_ID}"
    - "CF-Access-Client-Secret: ${CF_ACCESS_CLIENT_SECRET}"
  ```

#### Scenario: Auto-Detect Cloudflare Access on Failure
- Given API call returns 403
- And response contains "cloudflare" OR "challenge"
- When AI detects the error
- Then it MUST output configuration prompt:
  ```yaml
  auto_prompt:
    message: "⚠️ 检测到 Cloudflare Access 保护"
    suggestion: "设置 cloudflare_access.enabled = true"
    config_template: |
      forgejo:
        cloudflare_access:
          enabled: true
          client_id_env: "CF_ACCESS_CLIENT_ID"
          client_secret_env: "CF_ACCESS_CLIENT_SECRET"
  ```

#### Scenario: Cloudflare Access Environment Variables
- Given `cloudflare_access.enabled == true`
- When forgejo-sync executes API calls
- Then it MUST verify environment variables exist:
  - `CF_ACCESS_CLIENT_ID`
  - `CF_ACCESS_CLIENT_SECRET`
- And it MUST skip API call if variables are missing
- And it MUST report configuration error

---

### Requirement: Output Format

forgejo-sync Skill MUST output structured sync results.

#### Scenario: Sync Result Structure
- When sync completes
- Then output MUST include:
  ```yaml
  forgejo_sync_result:
    action: "story-to-issue|issue-to-story|bulk-sync|status-check|prd-to-wiki"
    stories_processed: N
    issues_created: N
    issues_updated: N
    stories_updated: N
    wiki_pages_published: N
    drift_items: [...]
    errors: [...]
  ```

---

## Cross-References

- Related: `requirements-validator` - Validates stories before sync
- Related: `requirements-sync` - Updates UPM after forgejo sync
- Related: `upm-requirements` - Tracks forgejo sync status
- External: Forgejo API documentation
- External: Forgejo Wiki API documentation

---

## Implementation Notes

### Skill Location
`.claude/skills/forgejo-sync/`

### Files
- `SKILL.md` - Skill definition and instructions
- `CONFIG.md` - Configuration template

### API Endpoints Used
- `POST /api/v1/repos/{owner}/{repo}/issues` - Create issue
- `PATCH /api/v1/repos/{owner}/{repo}/issues/{id}` - Update issue
- `GET /api/v1/repos/{owner}/{repo}/issues/{id}` - Get issue
- `PUT /api/v1/repos/{owner}/{repo}/wiki/page/{name}` - Create/update wiki page
