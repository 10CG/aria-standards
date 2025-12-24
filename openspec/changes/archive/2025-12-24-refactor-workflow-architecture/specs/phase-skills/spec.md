# Spec: Phase Skills

## ADDED Requirements

### Requirement: Phase Skill Interface

Each Phase Skill MUST implement a standard interface for consistent orchestration.

#### Scenario: Input Contract
- Given a Phase Skill is invoked
- Then it MUST accept context object containing phase_cycle, module, changed_files, and previous_phase_output
- And it MUST accept config object containing skip_steps and params

#### Scenario: Output Contract
- Given a Phase Skill completes execution
- Then it MUST return success status, steps_executed list, steps_skipped list, results object, and context_for_next object

#### Scenario: Context Propagation
- Given Phase A completes
- When Phase B starts
- Then Phase B MUST receive Phase A's context_for_next as previous_phase_output

---

### Requirement: phase-a-planner

phase-a-planner Skill MUST execute planning phase steps (A.1-A.3) with appropriate skip logic.

#### Scenario: Execute Full Planning
- Given complexity >= Level2 AND no existing OpenSpec
- When phase-a-planner executes
- Then it MUST execute A.1 (spec-drafter), A.2 (task-planner plan), A.3 (task-planner assign) in sequence

#### Scenario: Skip A.1 When Spec Exists
- Given has_openspec is true
- When phase-a-planner executes
- Then it MUST skip A.1 and proceed with A.2, A.3

#### Scenario: Skip All When Tasks Exist
- Given has_detailed_tasks is true
- When phase-a-planner executes
- Then it MUST skip A.2 and A.3
- And it MUST report steps_skipped in output

#### Scenario: Output Context
- Given phase-a-planner completes
- Then context_for_next MUST include spec_id, task_list, assigned_agents

---

### Requirement: phase-b-developer

phase-b-developer Skill MUST execute development phase steps (B.1-B.3) with appropriate skip logic.

#### Scenario: Execute Full Development
- Given on main/develop branch with code changes
- When phase-b-developer executes
- Then it MUST execute B.1 (branch-manager), B.2 (test-verifier), B.3 (arch-update) in sequence

#### Scenario: Skip B.1 When On Feature Branch
- Given current branch is not main/develop/master
- When phase-b-developer executes
- Then it MUST skip B.1 and proceed with B.2, B.3

#### Scenario: Skip B.3 When No Arch Changes
- Given no architecture files modified
- When phase-b-developer executes
- Then it MUST skip B.3

#### Scenario: Degrade B.2 When No Tests
- Given changed files have no corresponding test files
- When phase-b-developer executes B.2
- Then it MUST run in degraded mode with warning
- And it MUST suggest using flutter-test-generator

#### Scenario: Output Context
- Given phase-b-developer completes
- Then context_for_next MUST include branch_name, test_results, arch_sync_status

---

### Requirement: phase-c-integrator

phase-c-integrator Skill MUST execute integration phase steps (C.1-C.2) with appropriate skip logic.

#### Scenario: Execute Commit Only
- Given changes are ready to commit
- When phase-c-integrator executes with skip C.2
- Then it MUST execute only C.1 (commit-msg-generator)

#### Scenario: Execute Full Integration
- Given PR is required
- When phase-c-integrator executes
- Then it MUST execute C.1 then C.2 (branch-manager pr)

#### Scenario: Skip C.2 When Direct Push
- Given direct_push_allowed is true
- When phase-c-integrator executes
- Then it MUST skip C.2

#### Scenario: Output Context
- Given phase-c-integrator completes
- Then context_for_next MUST include commit_sha, pr_url (if created)

---

### Requirement: phase-d-closer

phase-d-closer Skill MUST execute closure phase steps (D.1-D.2) with appropriate skip logic.

#### Scenario: Execute Full Closure
- Given UPM exists AND OpenSpec is active
- When phase-d-closer executes
- Then it MUST execute D.1 (progress-updater), D.2 (openspec:archive)

#### Scenario: Skip D.1 When No UPM
- Given module has no UPM configured
- When phase-d-closer executes
- Then it MUST skip D.1

#### Scenario: Skip D.2 When No OpenSpec
- Given no active OpenSpec for current work
- When phase-d-closer executes
- Then it MUST skip D.2

#### Scenario: Output Context
- Given phase-d-closer completes
- Then context_for_next MUST include upm_updated, spec_archived flags

---

### Requirement: Independent Execution

Each Phase Skill MUST be executable independently without requiring other phases.

#### Scenario: Standalone Phase B
- Given user wants to run only Phase B
- When phase-b-developer is invoked directly
- Then it MUST execute successfully without Phase A context
- And it MUST use defaults for missing context values

#### Scenario: Partial Context
- Given Phase B runs without Phase A
- When Phase C follows Phase B
- Then Phase C MUST receive Phase B's context correctly
