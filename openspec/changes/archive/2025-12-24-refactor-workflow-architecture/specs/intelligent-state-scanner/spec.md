# Spec: Intelligent State Scanner

## ADDED Requirements

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
