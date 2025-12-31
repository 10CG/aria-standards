# intelligent-state-scanner Specification

## Purpose
TBD - created by archiving change refactor-workflow-architecture. Update Purpose after archive.
## Requirements
### Requirement: State Collection

state-scanner Skill MUST collect comprehensive project state including git status, UPM progress, OpenSpec status, and change analysis.

#### Scenario: Collect Git State
- Given a git repository with uncommitted changes
- When state-scanner executes
- Then it MUST report current branch, staged files, unstaged changes, and recent commits

#### Scenario: Collect Project Context
- Given a project with UPM configured
- When state-scanner executes
- Then it MUST report current Phase/Cycle and active module

#### Scenario: Analyze Changes
- Given files have been modified
- When state-scanner executes
- Then it MUST categorize changes by type (code, test, docs, config) and assess complexity

---

### Requirement: Workflow Recommendation

state-scanner Skill MUST generate intelligent workflow recommendations based on collected state.

#### Scenario: Recommend Quick Fix
- Given changed_files <= 3 AND change_type is bugfix/typo/config
- When state-scanner generates recommendation
- Then it MUST recommend "quick-fix" workflow with reason "简单修复，使用快速流程"

#### Scenario: Recommend Feature Dev with Spec
- Given has_openspec is true AND openspec_status is approved
- When state-scanner generates recommendation
- Then it MUST recommend "feature-dev" workflow
- And it MUST indicate skip for Phase A steps
- And it MUST provide reason "已有 OpenSpec，跳过规划阶段"

#### Scenario: Recommend Full Cycle
- Given complexity >= Level2 AND has_openspec is false
- When state-scanner generates recommendation
- Then it MUST recommend "full-cycle" workflow with reason "新功能开发，建议完整流程"

#### Scenario: Recommend Doc Update
- Given all changed files are *.md AND no_code_changes is true
- When state-scanner generates recommendation
- Then it MUST recommend "doc-update" workflow with reason "仅文档变更"

---

### Requirement: Recommendation Explanation

state-scanner Skill MUST provide clear explanations for each recommendation.

#### Scenario: Primary Recommendation Format
- Given a workflow recommendation
- When displayed to user
- Then it MUST include workflow name, steps to execute, steps to skip, and reasoning

#### Scenario: Alternative Options
- Given a primary recommendation
- When displayed to user
- Then it MUST also show 2-3 alternative workflow options with brief reasons

---

### Requirement: User Confirmation

state-scanner Skill MUST allow user to confirm, modify, or reject the recommendation.

#### Scenario: Accept Recommendation
- Given a workflow recommendation
- When user selects the primary option
- Then state-scanner MUST pass the workflow definition to workflow-runner

#### Scenario: Select Alternative
- Given alternative options displayed
- When user selects an alternative
- Then state-scanner MUST use the selected workflow instead

#### Scenario: Custom Combination
- Given user wants a custom workflow
- When user inputs custom syntax (e.g., "B.2 + C.1")
- Then state-scanner MUST parse and pass the custom workflow definition

---

### Requirement: Output Format

state-scanner Skill MUST output results in a structured, readable format.

#### Scenario: Status Section
- When displaying project state
- Then it MUST show branch, module, Phase/Cycle, change summary in a clearly labeled section

#### Scenario: Recommendation Section
- When displaying recommendations
- Then it MUST use numbered options with the primary recommendation marked as "推荐"
- And each option MUST include workflow name and brief reason

#### Scenario: Interactive Prompt
- After displaying options
- Then it MUST prompt user for selection with clear instructions for custom input

---

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

### Requirement: Extended Output Format

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

