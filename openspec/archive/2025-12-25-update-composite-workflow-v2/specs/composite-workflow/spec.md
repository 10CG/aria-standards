# composite-workflow Specification

## MODIFIED Purpose

~~TBD - created by archiving change add-composite-skills. Update Purpose after archive.~~

Defines the composite workflow execution model for the ten-step-cycle. The workflow-runner Skill orchestrates Phase Skills (A, B, C, D) to execute predefined or custom workflows, with automatic context passing and Phase-level error handling.

## MODIFIED Requirements

### Requirement: Workflow Definition

~~workflow-runner Skill MUST support defining workflows as ordered sequences of ten-step-cycle steps.~~

workflow-runner Skill MUST support defining workflows as ordered sequences of Phases (A, B, C, D) or individual steps within Phases.

#### Scenario: Quick-fix workflow definition (Phase-based)

~~**Given** a workflow named "quick-fix" with steps [B.1, B.2, C.1]~~
**Given** a workflow named "quick-fix" with phases [B, C]
**When** workflow-runner parses the definition
**Then** it MUST recognize both Phases and delegate execution to phase-b-developer and phase-c-integrator

#### Scenario: Custom step combination

**Given** a workflow with steps [B.2, C.1]
**When** workflow-runner parses the definition
**Then** it MUST map steps to corresponding Phase Skills and execute only specified steps

#### Scenario: Invalid step reference

**Given** a workflow with an invalid step "X.9"
**When** workflow-runner parses the definition
**Then** it MUST reject the workflow with a clear error message

---

### Requirement: Sequential Execution

~~workflow-runner Skill MUST execute workflow steps in defined order with context passing.~~

workflow-runner Skill MUST execute workflow Phases in defined order, delegating step execution to Phase Skills.

#### Scenario: Successful Phase execution

~~**Given** a workflow [A.2, A.3, B.1]~~
**Given** a workflow with phases [A, B, C]
**When** each Phase completes successfully
**Then** it MUST pass context_for_next to the next Phase and complete the workflow

#### Scenario: Phase failure handling

~~**Given** a workflow where step B.2 fails~~
**Given** a workflow where Phase B fails (e.g., test-verifier reports failures)
**When** the failure is detected
**Then** it MUST stop execution, report the Phase and step that failed, and offer recovery options

---

### Requirement: Automatic Step Skip

~~workflow-runner Skill MUST automatically skip steps based on context analysis.~~

Phase Skills MUST automatically skip steps based on context analysis. workflow-runner delegates skip decisions to each Phase Skill.

#### Scenario: Skip A.1 for Level 1 tasks

**Given** a task classified as Level 1 (simple fix)
**When** phase-a-planner executes
**Then** phase-a-planner MUST skip A.1 (Spec management) and proceed to A.2

#### Scenario: Skip B.3 when no architecture changes

**Given** changes only affect test files
**When** phase-b-developer executes
**Then** phase-b-developer MUST skip B.3 (Architecture sync) and log the reason

---

### Requirement: Context Preservation

~~workflow-runner Skill MUST preserve and pass context between steps.~~

workflow-runner Skill MUST use context_for_next mechanism to automatically pass context between Phases.

#### Scenario: Branch name passing via context_for_next

~~**Given** B.1 creates branch "feature/mobile/TASK-001-auth"~~
**Given** phase-b-developer outputs context_for_next with branch_name "feature/mobile/TASK-001-auth"
**When** phase-c-integrator executes
**Then** it MUST receive branch_name from context and use it for commit operations

#### Scenario: Test results passing via context_for_next

~~**Given** B.2 produces test results with 95% pass rate~~
**Given** phase-b-developer outputs context_for_next with test_results { passed: true, coverage: 95 }
**When** phase-c-integrator executes
**Then** it MUST receive test_results from context for commit message generation

#### Scenario: Context merge strategy

**Given** Phase A outputs { spec_id: "auth-feature" }
**And** Phase B outputs { branch_name: "feature/auth", spec_id: "auth-feature-v2" }
**When** context is merged
**Then** later Phase outputs MUST override earlier values (later_wins strategy)

---

### Requirement: Rollback Support

~~workflow-runner Skill MUST support rollback to last successful step on failure.~~

workflow-runner Skill MUST support rollback to last successful Phase on failure.

#### Scenario: Rollback after Phase C failure

~~**Given** steps [B.1, B.2, C.1] where C.1 fails due to pre-commit hook~~
**Given** phases [B, C] where Phase C fails due to pre-commit hook
**When** user requests rollback
**Then** it MUST restore to post-Phase-B state (preserving branch and test results) and allow retry

#### Scenario: Partial Phase rollback

**Given** Phase B partially completed (B.1 done, B.2 failed)
**When** user requests rollback
**Then** it MUST preserve B.1 outputs (branch created) and suggest fixing B.2 issues before retry
