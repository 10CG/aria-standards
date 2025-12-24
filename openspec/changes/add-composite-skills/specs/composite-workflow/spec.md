# Composite Workflow Capability

## ADDED Requirements

### Requirement: Workflow Definition

workflow-runner Skill MUST support defining workflows as ordered sequences of ten-step-cycle steps.

#### Scenario: Quick-fix workflow definition
**Given** a workflow named "quick-fix" with steps [B.1, B.2, C.1]
**When** workflow-runner parses the definition
**Then** it MUST recognize all three steps and their order

#### Scenario: Invalid step reference
**Given** a workflow with an invalid step "X.9"
**When** workflow-runner parses the definition
**Then** it MUST reject the workflow with a clear error message

---

### Requirement: Sequential Execution

workflow-runner Skill MUST execute workflow steps in defined order with context passing.

#### Scenario: Successful sequential execution
**Given** a workflow [A.2, A.3, B.1]
**When** each step completes successfully
**Then** it MUST pass context to the next step and complete the workflow

#### Scenario: Step failure handling
**Given** a workflow where step B.2 fails
**When** the failure is detected
**Then** it MUST stop execution, report the failure, and offer recovery options

---

### Requirement: Automatic Step Skip

workflow-runner Skill MUST automatically skip steps based on context analysis.

#### Scenario: Skip A.1 for Level 1 tasks
**Given** a task classified as Level 1 (simple fix)
**When** workflow includes A.1 (Spec management)
**Then** it MUST skip A.1 and proceed to next step

#### Scenario: Skip B.3 when no architecture changes
**Given** changes only affect test files
**When** workflow includes B.3 (Architecture sync)
**Then** it MUST skip B.3 and log the reason

---

### Requirement: Context Preservation

workflow-runner Skill MUST preserve and pass context between steps.

#### Scenario: Branch name passing
**Given** B.1 creates branch "feature/mobile/TASK-001-auth"
**When** C.1 (Git commit) executes
**Then** it MUST have access to the branch name from B.1

#### Scenario: Test results passing
**Given** B.2 produces test results with 95% pass rate
**When** C.1 (Git commit) executes
**Then** it MUST have access to test summary for commit message

---

### Requirement: Rollback Support

workflow-runner Skill MUST support rollback to last successful step on failure.

#### Scenario: Rollback after commit failure
**Given** steps [B.1, B.2, C.1] where C.1 fails due to pre-commit hook
**When** user requests rollback
**Then** it MUST restore to post-B.2 state and allow retry
