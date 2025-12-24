# Test Verification Capability

## ADDED Requirements

### Requirement: Multi-Module Test Detection

test-verifier Skill MUST automatically detect the module type of changed files and route to appropriate test framework.

#### Scenario: Mobile file detection
**Given** a file path `mobile/lib/services/auth_service.dart`
**When** test-verifier analyzes the file
**Then** it MUST identify module as `mobile` and use Flutter test framework

#### Scenario: Backend file detection
**Given** a file path `backend/src/services/user_service.py`
**When** test-verifier analyzes the file
**Then** it MUST identify module as `backend` and use pytest framework

#### Scenario: Shared contract detection
**Given** a file path `shared/contracts/api/user-api.yaml`
**When** test-verifier analyzes the file
**Then** it MUST identify module as `shared` and use contract validation

---

### Requirement: Test Execution Flow

test-verifier Skill MUST execute tests and report results in a standardized format.

#### Scenario: Successful test run
**Given** all tests pass for the changed files
**When** test execution completes
**Then** it MUST output a success summary with pass count

#### Scenario: Failed test run
**Given** some tests fail for the changed files
**When** test execution completes
**Then** it MUST output failure details with file:line references

---

### Requirement: Coverage Gate Check

test-verifier Skill MUST check test coverage against configurable thresholds when coverage data is available.

#### Scenario: Coverage below threshold
**Given** test coverage is 70% and threshold is 80%
**When** coverage check runs
**Then** it MUST warn about coverage gap and suggest files needing tests

#### Scenario: Coverage meets threshold
**Given** test coverage is 85% and threshold is 80%
**When** coverage check runs
**Then** it MUST report coverage as passing

---

### Requirement: OpenSpec Task Sync

test-verifier Skill MUST sync test results back to OpenSpec tasks.md when running in OpenSpec context.

#### Scenario: Test task completion
**Given** a task in tasks.md is "Run unit tests for AuthService"
**When** tests pass for AuthService
**Then** it MAY update task checkbox to `[x]` with timestamp
