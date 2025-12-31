# intelligent-state-scanner Spec Delta

> **Change**: evolve-ai-ddd-system
> **Type**: MODIFIED
> **Base Spec**: `openspec/specs/intelligent-state-scanner/spec.md`

---

## ADDED Requirements

### Requirement: Requirements Awareness

state-scanner Skill MUST detect and report requirements document status.

#### Scenario: Detect PRD Existence
- Given a project with `docs/requirements/` directory
- When state-scanner executes
- Then it MUST check for PRD files matching pattern `prd-*.md`
- And it MUST report `prd_exists: true/false`

#### Scenario: Read UPM Requirements Section
- Given a UPM file with `requirements:` YAML section
- When state-scanner reads UPM
- Then it MUST parse `requirements.prd` and `requirements.user_stories`
- And it MUST include this in output as `requirements_status` block

#### Scenario: Handle Missing Requirements Section
- Given a UPM file without `requirements:` section
- When state-scanner reads UPM
- Then it MUST continue normally
- And it MUST set `requirements_status.configured: false`

---

### Requirement: Sub-Skill Invocation

state-scanner Skill MUST invoke requirements-validator as sub-skill.

#### Scenario: Invoke Validator in Check Mode
- When state-scanner needs requirements status
- Then it MUST invoke requirements-validator with mode "check"
- And it MUST incorporate validation results into output

#### Scenario: Handle Validator Errors
- Given requirements-validator returns validation errors
- When state-scanner processes results
- Then it MUST include errors in `requirements_status.issues`
- And it MUST adjust recommendations based on errors

#### Scenario: Skip Validator When Not Configured
- Given project has no `docs/requirements/` directory
- When state-scanner executes
- Then it MUST skip requirements-validator invocation
- And it MUST set `requirements_status.configured: false`

---

### Requirement: Requirements-Based Recommendations

state-scanner Skill MUST provide workflow recommendations based on requirements status.

#### Scenario: Recommend Create OpenSpec for Pending Stories
- Given `ready_stories > 0` AND no active OpenSpec change
- When state-scanner generates recommendation
- Then it MUST suggest "create-openspec" as an option
- And it MUST provide reason "有 {n} 个就绪 Story，建议创建技术方案"

#### Scenario: Recommend Create PRD for Complex Feature
- Given `!prd_exists` AND `complexity >= Level2`
- When state-scanner generates recommendation
- Then it MUST suggest "create-prd" as an option
- And it MUST provide reason "复杂功能变更，建议先创建 PRD"

#### Scenario: Recommend Start Implementation
- Given `stories_ready > 0` AND `no_active_work`
- When state-scanner generates recommendation
- Then it MUST suggest "start-implementation" as an option
- And it MUST provide reason "有 {n} 个就绪 Story 可开始实现"

#### Scenario: Recommend Forgejo Sync
- Given Story status differs from Issue status
- When state-scanner generates recommendation
- Then it MUST suggest "sync-forgejo" as an option
- And it MUST provide reason "Story 与 Issue 状态不一致，建议同步"

#### Scenario: Recommend Requirements Check
- Given validation errors exist
- When state-scanner generates recommendation
- Then it MUST suggest "requirements-check" as an option
- And it MUST provide reason "需求文档存在问题，建议先修复"

---

## MODIFIED Requirements

### Requirement: Output Format (Extended)

state-scanner Skill MUST include requirements status in output.

#### Scenario: Requirements Status Section
- When displaying project state
- Then it MUST include requirements status:
  ```yaml
  requirements_status:
    configured: true
    prd_exists: true
    prd_path: "docs/requirements/prd-v2.1.0.md"
    prd_status: approved
    stories:
      total: 8
      draft: 1
      ready: 3
      in_progress: 2
      done: 2
      blocked: 0
    coverage:
      with_openspec: 5
      without_openspec: 3
    validation:
      prd_valid: true
      stories_valid: true
      issues: []
    forgejo:
      enabled: true
      synced: true
      drift: false
  ```

#### Scenario: Requirements Not Configured
- Given project has no requirements directory
- When displaying project state
- Then requirements_status MUST show:
  ```yaml
  requirements_status:
    configured: false
  ```

---

### Requirement: Recommendation Explanation (Extended)

state-scanner recommendations MUST include requirements context.

#### Scenario: Include Requirements in Reasoning
- Given requirements status is available
- When generating recommendation explanation
- Then it MUST include relevant requirements context:
  - Story count and status distribution
  - Coverage status
  - Validation issues (if any)

---

## Cross-References

- Related: `requirements-validator` (invoked as sub-skill)
- Related: `requirements-sync` (can be recommended)
- Related: `forgejo-sync` (can be recommended)
- Related: `upm-requirements` (reads requirements section)
