# requirements-validator Specification

> **Change**: evolve-ai-ddd-system
> **Type**: ADDED
> **Purpose**: Validate PRD and User Story format, check associations and coverage

---

## ADDED Requirements

### Requirement: PRD Validation

requirements-validator Skill MUST validate PRD document format and completeness.

#### Scenario: Validate PRD Required Sections
- Given a PRD file in `docs/requirements/`
- When requirements-validator validates the PRD
- Then it MUST check for required sections:
  - 文档目的
  - 产品定位 (目标用户, 核心价值, 成功标准)
  - 功能范围 (Must-have, Nice-to-have, Out of Scope)
- And it MUST report missing sections as errors

#### Scenario: Validate PRD Feature List Format
- Given a PRD with 功能范围 section
- When requirements-validator validates the PRD
- Then it MUST check feature list uses yaml + ✅/❌ format
- And it MUST report format violations as warnings

#### Scenario: Validate PRD User Story References
- Given a PRD with 关联文档 section
- When requirements-validator validates the PRD
- Then it MUST check User Story table exists
- And it MUST extract Story IDs for association check

---

### Requirement: User Story Validation

requirements-validator Skill MUST validate User Story document format.

#### Scenario: Validate Story Required Fields
- Given a User Story file in `docs/requirements/user-stories/`
- When requirements-validator validates the Story
- Then it MUST check for required header fields:
  - Story ID (format: US-XXX)
  - Status (draft/ready/in_progress/done/blocked)
  - Priority (HIGH/MEDIUM/LOW)
  - Created (YYYY-MM-DD)
- And it MUST report missing fields as errors

#### Scenario: Validate Story Format
- Given a User Story file
- When requirements-validator validates the Story
- Then it MUST check for User Story format:
  - "As a {role}" line
  - "I want {feature}" line
  - "So that {value}" line
- And it MUST report missing format elements as errors

#### Scenario: Validate Acceptance Criteria
- Given a User Story with 验收标准 section
- When requirements-validator validates the Story
- Then it MUST check for at least one Scenario
- And each Scenario MUST have Given/When/Then format
- And it MUST report missing criteria as warnings

---

### Requirement: Association Check

requirements-validator Skill MUST verify bidirectional associations between documents.

#### Scenario: Check PRD to Story Links
- Given a PRD lists Stories [US-001, US-002, US-003]
- When requirements-validator checks associations
- Then it MUST verify each Story file exists
- And it MUST report missing Story files as errors

#### Scenario: Check Story to PRD Links
- Given a Story references PRD path
- When requirements-validator checks associations
- Then it MUST verify the PRD file exists
- And it MUST report missing PRD as warnings

#### Scenario: Check Story to OpenSpec Links
- Given a Story references OpenSpec change
- When requirements-validator checks associations
- Then it MUST verify the OpenSpec proposal exists
- And it MUST report missing OpenSpec as info (not error)

---

### Requirement: Coverage Analysis

requirements-validator Skill MUST analyze requirement coverage status.

#### Scenario: Calculate Story Status Distribution
- Given multiple Story files in `docs/requirements/user-stories/`
- When requirements-validator analyzes coverage
- Then it MUST count Stories by status:
  - draft, ready, in_progress, done, blocked
- And it MUST report distribution in output

#### Scenario: Check OpenSpec Coverage
- Given Stories with status `ready` or `in_progress`
- When requirements-validator analyzes coverage
- Then it MUST check which Stories have linked OpenSpec
- And it MUST report uncovered Stories count

#### Scenario: Generate Coverage Report
- When requirements-validator completes analysis
- Then it MUST output coverage summary:
  ```yaml
  coverage:
    total: 8
    with_openspec: 5
    without_openspec: 3
    coverage_rate: "62.5%"
  ```

---

### Requirement: Output Format

requirements-validator Skill MUST output structured validation results.

#### Scenario: Validation Result Structure
- When validation completes
- Then output MUST include:
  ```yaml
  validation_result:
    prd_valid: true/false
    prd_issues: [{file, issue, severity}]
    stories_valid: true/false
    story_issues: [{file, issue, severity}]
    associations_valid: true/false
    association_issues: [{source, target, issue}]
    coverage:
      total: N
      with_openspec: N
      without_openspec: N
  ```

#### Scenario: Severity Levels
- When reporting issues
- Then severity MUST be one of:
  - error: Must fix before proceeding
  - warning: Should fix, not blocking
  - info: Informational only

---

## Cross-References

- Related: `upm-requirements` (uses same document structure)
- Related: `requirements-sync` (consumes validation results)
- Depends: PRD template at `standards/templates/prd-template.md`
- Depends: User Story template at `standards/templates/user-story-template.md`
