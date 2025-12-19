# Task Validation Rules Specification

> **Version**: 1.0.0
> **Status**: Draft
> **Created**: 2025-12-19
> **Related OpenSpec**: clarify-phase-a-task-pipeline

## Overview

This document defines comprehensive validation rules for both task documents in the two-layer task architecture:
- **tasks.md**: Coarse-grained functional checklist (OpenSpec standard)
- **detailed-tasks.yaml**: Fine-grained executable task specifications

## Purpose

Validation ensures:
- **Structural Integrity**: Both documents follow their defined formats
- **Referential Integrity**: Links between documents are valid and complete
- **Consistency**: Information is synchronized and non-contradictory
- **Completeness**: All required information is present
- **Quality**: Documents meet standards for AI execution and human readability

## Validation Levels

```yaml
Validation Levels:
  Error:
    Description: Critical issues that prevent execution
    Action: Must be fixed before proceeding
    Example: Missing required field, invalid format

  Warning:
    Description: Issues that may cause problems
    Action: Should be fixed but doesn't block execution
    Example: Uncovered tasks.md sections, high task count per parent

  Info:
    Description: Suggestions for improvement
    Action: Optional, best practice recommendations
    Example: Title consistency recommendations
```

---

## Part 1: tasks.md Validation Rules

### 1.1 Structural Validation

#### Rule: valid_markdown_format
```yaml
Level: Error
Check: File is valid Markdown with proper syntax
Validation:
  - Headings use correct syntax (## Level, - [ ] format)
  - List items properly indented
  - No malformed checkbox syntax
Message: "tasks.md contains invalid Markdown syntax at line {line}"
```

#### Rule: section_numbering_format
```yaml
Level: Error
Check: Section IDs follow "{section}.{subsection}" format
Pattern: ^## \d+\. .+$  # Top-level sections
         ^- \[ \] \d+\.\d+ .+$  # Checklist items
Examples:
  Valid:
    ## 1. Database Setup
    - [ ] 1.1 Add OTP secret column to users table
  Invalid:
    ## A. Database Setup  # Non-numeric section
    - [ ] 1 Add column   # Missing subsection
Message: "Section at line {line} has invalid numbering format"
```

#### Rule: checkbox_format_standard
```yaml
Level: Error
Check: Checkboxes use standard Markdown format
Format: "- [ ] " or "- [x] " (space after checkbox required)
Invalid:
  - "- []"     # No space after checkbox
  - "-[ ]"     # No space after dash
  - "- [X]"    # Uppercase X not standard
Message: "Invalid checkbox format at line {line}"
```

#### Rule: section_id_uniqueness
```yaml
Level: Error
Check: All section IDs are unique within the file
Validation:
  - Extract all section IDs (e.g., "1.1", "1.2", "2.1")
  - Check for duplicates
Example Violation:
  - [ ] 1.1 Task A
  - [ ] 1.1 Task B  # Duplicate ID
Message: "Duplicate section ID '{id}' found at lines {line1} and {line2}"
```

### 1.2 Semantic Validation

#### Rule: sequential_numbering
```yaml
Level: Warning
Check: Section and subsection numbers are sequential
Validation:
  - Sections increase by 1 (1, 2, 3, not 1, 3, 5)
  - Subsections restart at 1 for each section
  - Subsections within a section are sequential
Examples:
  Valid:
    ## 1. Section One
    - [ ] 1.1 Task
    - [ ] 1.2 Task
    ## 2. Section Two
    - [ ] 2.1 Task

  Warning (allowed but not ideal):
    ## 1. Section One
    - [ ] 1.1 Task
    - [ ] 1.3 Task  # Skipped 1.2
Message: "Non-sequential numbering: {section}.{subsection} follows {prev_section}.{prev_subsection}"
```

#### Rule: section_structure_consistency
```yaml
Level: Info
Check: Sections follow consistent structure pattern
Validation:
  - Each ## heading has at least one checklist item
  - All checklist items belong to a section
Message: "Section '{section}' has no checklist items"
```

### 1.3 Content Quality Validation

#### Rule: task_description_clarity
```yaml
Level: Info
Check: Task descriptions are clear and actionable
Validation:
  - Starts with action verb (Add, Create, Implement, etc.)
  - Not too vague ("Fix stuff", "Update things")
  - Not too long (>100 characters suggests task too complex)
Examples:
  Good:
    - [ ] 1.1 Add OTP secret column to users table
    - [ ] 1.2 Create authentication middleware

  Needs Improvement:
    - [ ] 1.1 Do database work  # Too vague
    - [ ] 1.2 Implement the entire authentication system including...  # Too complex
Message: "Task at line {line} may be too vague/complex"
```

---

## Part 2: detailed-tasks.yaml Validation Rules

### 2.1 YAML Format Validation

#### Rule: valid_yaml_syntax
```yaml
Level: Error
Check: File is valid YAML and can be parsed
Validation:
  - YAML syntax is correct
  - Indentation is consistent (2 spaces)
  - No duplicate keys
  - Proper quoting of strings
Message: "YAML syntax error: {error} at line {line}"
```

#### Rule: root_structure_present
```yaml
Level: Error
Check: Root structure contains required keys
Required Keys:
  - tasks: array of task objects
Optional Keys:
  - metadata: object with feature info
Validation:
  - "tasks" key exists
  - "tasks" is an array
  - "tasks" is not empty
Message: "Missing required root key 'tasks' or tasks array is empty"
```

### 2.2 Task Object Field Validation

#### Rule: required_fields_present
```yaml
Level: Error
Check: All required fields present in each task
Required Fields (A.2 Output):
  - id: string
  - parent: string
  - title: string
  - complexity: string
  - dependencies: array
  - deliverables: array

Enhanced Fields (A.3 Output):
  - agent: string (optional but recommended)
  - reason: string (optional but recommended)
  - verification: array (optional but recommended)

Validation:
  - Each task has all required fields
  - Field types match specification
Message: "Task '{task_id}' missing required field '{field}'"
```

#### Rule: task_id_format
```yaml
Level: Error
Check: Task ID follows TASK-{NNN} format
Pattern: ^TASK-\d{3}$
Examples:
  Valid: TASK-001, TASK-042, TASK-100
  Invalid: TASK-1, task-001, TASK-1000
Validation:
  - Matches regex pattern
  - NNN is zero-padded 3-digit number
Message: "Task ID '{id}' does not match TASK-NNN format"
```

#### Rule: task_id_uniqueness
```yaml
Level: Error
Check: All task IDs are unique within the file
Validation:
  - Extract all task IDs
  - Check for duplicates
Message: "Duplicate task ID '{id}' found in tasks at indices {index1} and {index2}"
```

#### Rule: parent_field_format
```yaml
Level: Error
Check: Parent field matches "{section}.{subsection}" format
Pattern: ^\d+\.\d+$
Type: String (must be quoted in YAML)
Examples:
  Valid: "1.1", "2.5", "10.3"
  Invalid: "1", "1.1.1", "A.1", 1.1 (number)
Validation:
  - Matches regex pattern
  - Is a string, not a number
Message: "Task '{task_id}' has invalid parent format: {parent}"
```

#### Rule: complexity_format
```yaml
Level: Error
Check: Complexity follows standard format
Valid Values:
  - "S (Small, 1-2h)"
  - "M (Medium, 2-4h)"
  - "L (Large, 4-8h)"
  - "XL (Extra Large, 8+h)"  # Should trigger warning to decompose

Validation:
  - Matches one of the standard formats
  - Format is consistent
Message: "Task '{task_id}' has invalid complexity value: {complexity}"
```

#### Rule: dependencies_array_format
```yaml
Level: Error
Check: Dependencies is a valid array of task IDs
Validation:
  - Is an array (can be empty: [])
  - All elements are strings
  - All elements match TASK-NNN pattern
  - All referenced task IDs exist in the file
Examples:
  Valid:
    dependencies: []
    dependencies: [TASK-001]
    dependencies: [TASK-001, TASK-002]
  Invalid:
    dependencies: TASK-001  # Not an array
    dependencies: [001]     # Not TASK-NNN format
Message: "Task '{task_id}' has invalid dependencies array"
```

#### Rule: deliverables_non_empty
```yaml
Level: Error
Check: Deliverables array is non-empty and contains valid paths
Validation:
  - Is an array
  - Has at least one element
  - All elements are strings
  - Paths are relative (not absolute)
  - Paths use forward slashes (/)
Examples:
  Valid:
    deliverables:
      - backend/src/models/user.py
      - backend/migrations/add_otp_column.sql
  Invalid:
    deliverables: []  # Empty
    deliverables:
      - C:\backend\src\user.py  # Absolute path, backslashes
Message: "Task '{task_id}' has invalid deliverables array"
```

### 2.3 Dependency Graph Validation

#### Rule: dependencies_reference_valid_tasks
```yaml
Level: Error
Check: All dependency task IDs exist in the file
Validation:
  - For each task's dependencies array
  - Verify each referenced task ID exists
  - Build a map of task IDs for quick lookup
Message: "Task '{task_id}' depends on non-existent task '{dep_id}'"
```

#### Rule: no_circular_dependencies
```yaml
Level: Error
Check: Dependency graph is acyclic (DAG)
Validation:
  - Build dependency graph
  - Perform cycle detection (DFS or topological sort)
  - Identify circular dependency chains
Examples:
  Valid (DAG):
    TASK-001 → TASK-002 → TASK-003

  Invalid (Cycle):
    TASK-001 → TASK-002 → TASK-003 → TASK-001

Message: "Circular dependency detected: {task_id1} → {task_id2} → ... → {task_id1}"
```

#### Rule: dependency_ordering
```yaml
Level: Warning
Check: Dependencies declared before dependent tasks
Validation:
  - Task dependencies should ideally reference tasks defined earlier
  - Not strictly required (since tasks are referenced by ID)
  - Helps with readability
Message: "Task '{task_id}' appears before its dependency '{dep_id}' (consider reordering)"
```

### 2.4 Task Complexity Validation

#### Rule: xl_complexity_warning
```yaml
Level: Warning
Check: XL complexity tasks should be decomposed
Trigger: complexity = "XL (Extra Large, 8+h)"
Recommendation: Task >8 hours should be broken down into smaller atomic tasks
Message: "Task '{task_id}' has XL complexity (>8h), consider decomposing into smaller tasks"
```

#### Rule: dependency_chain_length
```yaml
Level: Warning
Check: Dependency chains are not too long
Threshold: >5 levels deep
Reason: Long chains may indicate need for better task breakdown
Message: "Task '{task_id}' is {depth} levels deep in dependency chain (>5 may be complex)"
```

---

## Part 3: Cross-Document Validation Rules

### 3.1 Referential Integrity Validation

#### Rule: parent_references_exist
```yaml
Level: Error
Check: All parent field values exist in tasks.md
Process:
  1. Parse tasks.md to extract all section IDs (e.g., "1.1", "1.2", "2.1")
  2. For each task in detailed-tasks.yaml
  3. Verify task.parent exists in tasks.md section ID list
  4. Check both unchecked and checked boxes: "- [ ] 1.1" or "- [x] 1.1"

Message: "Task '{task_id}' references non-existent parent '{parent}' in tasks.md"
```

#### Rule: no_orphaned_tasks
```yaml
Level: Warning
Check: All tasks in detailed-tasks.yaml have valid parent references
Validation:
  - Run parent_references_exist check
  - List all tasks with broken parent references
Action: List orphaned tasks for review
Message: "Found {count} orphaned tasks: {task_ids}"
```

#### Rule: all_sections_covered
```yaml
Level: Info
Check: All tasks.md sections have at least one TASK-{NNN}
Process:
  1. Extract all section IDs from tasks.md
  2. Extract all unique parent values from detailed-tasks.yaml
  3. Identify tasks.md sections not referenced by any task

Reason: Informational - not all tasks.md items need detailed tasks immediately
Action: List uncovered sections for awareness
Message: "Sections in tasks.md without TASK-{NNN}: {section_ids}"
```

### 3.2 Synchronization Validation

#### Rule: task_completion_consistency
```yaml
Level: Warning
Check: Completed tasks.md items have all corresponding TASK-{NNN} completed
Process:
  1. Find checked items in tasks.md: "- [x] 1.1 ..."
  2. Find all tasks with parent="1.1" in detailed-tasks.yaml
  3. Verify all sibling tasks are marked completed (status field if present)

Note: This assumes detailed-tasks.yaml includes a status field during execution
Message: "tasks.md section '{parent}' is checked but has incomplete TASK-{NNN}: {task_ids}"
```

#### Rule: unchecked_parent_with_all_complete
```yaml
Level: Warning
Check: Unchecked tasks.md items where all TASK-{NNN} are complete
Process:
  1. Find unchecked items in tasks.md: "- [ ] 1.1 ..."
  2. Find all tasks with parent="1.1"
  3. If all are completed, suggest checking off tasks.md item

Trigger: Backward sync may not have run yet
Message: "tasks.md section '{parent}' has all TASK-{NNN} complete but is unchecked"
```

### 3.3 Consistency Validation

#### Rule: task_count_per_parent_reasonable
```yaml
Level: Warning
Check: One-to-many mappings have reasonable task count
Threshold: 1-10 tasks per parent
Reason: >10 tasks may indicate over-decomposition or missing structure
Validation:
  - Count tasks per parent value
  - Flag parents with >10 tasks
Message: "Parent '{parent}' has {count} tasks (>10), consider grouping or restructuring"
```

#### Rule: title_consistency
```yaml
Level: Info
Check: TASK titles relate to parent description
Method: Manual review recommended (AI-assisted heuristics possible)
Guidance:
  - TASK titles should expand on parent description
  - One-to-one: TASK title should closely match tasks.md item
  - One-to-many: TASK titles should collectively cover tasks.md item scope

Examples:
  Good (One-to-One):
    tasks.md: "1.1 Add OTP secret column to users table"
    TASK-001: "Add OTP secret column to users table"

  Good (One-to-Many):
    tasks.md: "2.1 Implement user authentication"
    TASK-005: "Design user data model"
    TASK-006: "Implement JWT auth service"
    TASK-007: "Create auth API endpoints"

  Questionable:
    tasks.md: "1.3 Setup database"
    TASK-007: "Implement frontend form validation"  # Unrelated

Message: "Task '{task_id}' title may not relate to parent '{parent}' description"
```

---

## Part 4: Validation Tool Specification

### 4.1 Required Checks

```yaml
Check Categories:
  1. Format Validation:
     - tasks.md: Markdown syntax, section numbering, checkbox format
     - detailed-tasks.yaml: YAML syntax, root structure, field formats

  2. Referential Integrity:
     - Parent field values exist in tasks.md
     - Dependency task IDs exist in detailed-tasks.yaml
     - No orphaned tasks

  3. Graph Validation:
     - No circular dependencies (DAG requirement)
     - Dependency chain depth reasonable

  4. Cross-Document Consistency:
     - All tasks.md sections referenced (or reported)
     - Task counts per parent reasonable
     - Title consistency (heuristic)

  5. Quality Checks:
     - XL complexity warning
     - Task description clarity
     - Section numbering sequential
```

### 4.2 Validation Output Format

```yaml
Validation Report Structure:
  summary:
    total_errors: integer
    total_warnings: integer
    total_info: integer
    overall_status: "passed" | "failed" | "warnings"

  errors: array
    - rule: string (rule name)
      level: "error"
      message: string
      location: string (file:line or task_id)
      details: object (optional)

  warnings: array
    - rule: string
      level: "warning"
      message: string
      location: string
      details: object

  info: array
    - rule: string
      level: "info"
      message: string
      location: string
      details: object

  statistics:
    tasks_md_sections: integer
    detailed_tasks_count: integer
    coverage_percentage: float (tasks covered / total sections)
    average_tasks_per_parent: float
    max_dependency_depth: integer
```

### 4.3 Example Validation Report

```yaml
Validation Report:

  ✅ Format Validation (tasks.md): PASSED
     All sections follow correct numbering format
     All checkboxes use standard Markdown syntax

  ✅ Format Validation (detailed-tasks.yaml): PASSED
     YAML syntax valid
     All 15 tasks have valid field formats

  ✅ Referential Integrity: PASSED
     All parent references exist in tasks.md
     All dependency task IDs valid
     No orphaned tasks

  ✅ Graph Validation: PASSED
     Dependency graph is acyclic (DAG)
     Maximum dependency depth: 3 levels

  ⚠️  Cross-Document Consistency: WARNINGS
     - Parent "3.2" has 12 tasks (>10 recommended)
     - 3 tasks.md sections have no TASK-{NNN}:
       * Section 4.1: Document API changes
       * Section 4.3: Update deployment guide
       * Section 5.1: Performance benchmarks

  ℹ️  Quality Checks: INFO
     - TASK-008 has XL complexity, consider decomposing
     - Section numbering has gap: 1.1, 1.2, 1.4 (missing 1.3)

  ─────────────────────────────────────────────────────
  Overall Status: PASSED WITH WARNINGS
  Total: 0 errors, 2 warnings, 2 info

  Statistics:
    tasks.md sections: 18
    detailed-tasks.yaml tasks: 15
    Coverage: 83.3% (15 of 18 sections)
    Average tasks per parent: 1.2
    Max dependency depth: 3
```

### 4.4 Validation Tool Interface

#### Command-Line Interface (Proposed)

```bash
# Validate both documents
openspec validate \
  --tasks standards/openspec/changes/{feature}/tasks.md \
  --detailed standards/openspec/changes/{feature}/detailed-tasks.yaml

# Validate with specific rule categories
openspec validate \
  --tasks tasks.md \
  --detailed detailed-tasks.yaml \
  --checks format,integrity,consistency

# Output format options
openspec validate \
  --tasks tasks.md \
  --detailed detailed-tasks.yaml \
  --format json  # or yaml, table

# Verbose mode for detailed output
openspec validate \
  --tasks tasks.md \
  --detailed detailed-tasks.yaml \
  --verbose

# Check specific rules only
openspec validate \
  --tasks tasks.md \
  --detailed detailed-tasks.yaml \
  --rules parent_references_exist,no_circular_dependencies
```

#### Programmatic API (Proposed)

```python
from openspec.validation import TaskValidator

# Create validator
validator = TaskValidator(
    tasks_md_path="standards/openspec/changes/feature/tasks.md",
    detailed_yaml_path="standards/openspec/changes/feature/detailed-tasks.yaml"
)

# Run validation
report = validator.validate()

# Check results
if report.has_errors():
    print(f"Validation failed with {report.error_count} errors")
    for error in report.errors:
        print(f"  - {error.rule}: {error.message} at {error.location}")
else:
    print("Validation passed")

# Get specific rule results
parent_check = report.get_rule_result("parent_references_exist")
if parent_check.passed:
    print("All parent references valid")

# Export report
report.export_json("validation-report.json")
report.export_html("validation-report.html")
```

---

## Part 5: Validation Implementation Guidance

### 5.1 Parsing Strategies

#### tasks.md Parsing

```yaml
Strategy:
  1. Parse Markdown line by line
  2. Identify sections using regex: ^## (\d+)\. (.+)$
  3. Identify checkboxes using regex: ^- \[([ x])\] (\d+)\.(\d+) (.+)$
  4. Build section map: {section_id: {title, checked, line_number}}

Data Structure:
  sections:
    "1.1":
      title: "Add OTP secret column to users table"
      checked: false
      line_number: 5
    "1.2":
      title: "Create OTP verification logs table"
      checked: false
      line_number: 6
```

#### detailed-tasks.yaml Parsing

```yaml
Strategy:
  1. Parse YAML to object tree
  2. Validate root structure (tasks array)
  3. Iterate tasks array and validate each task object
  4. Build task map: {task_id: task_object}
  5. Build dependency graph: {task_id: [dependencies]}

Data Structure:
  tasks:
    "TASK-001":
      parent: "1.1"
      title: "..."
      complexity: "M (Medium, 2-4h)"
      dependencies: []
      deliverables: [...]

  dependency_graph:
    "TASK-001": []
    "TASK-002": ["TASK-001"]
    "TASK-003": ["TASK-002"]
```

### 5.2 Cycle Detection Algorithm

```python
def detect_cycles(dependency_graph):
    """
    Detects circular dependencies using DFS.
    Returns: List of cycles found (empty if DAG)
    """
    visited = set()
    rec_stack = set()
    cycles = []

    def dfs(task_id, path):
        visited.add(task_id)
        rec_stack.add(task_id)
        path.append(task_id)

        for dep in dependency_graph.get(task_id, []):
            if dep not in visited:
                dfs(dep, path.copy())
            elif dep in rec_stack:
                # Cycle detected
                cycle_start = path.index(dep)
                cycles.append(path[cycle_start:] + [dep])

        rec_stack.remove(task_id)

    for task_id in dependency_graph.keys():
        if task_id not in visited:
            dfs(task_id, [])

    return cycles
```

### 5.3 Coverage Calculation

```python
def calculate_coverage(tasks_md_sections, detailed_tasks):
    """
    Calculate what percentage of tasks.md sections have TASK-{NNN} entries.
    """
    # Extract parent values from detailed-tasks.yaml
    covered_sections = set(task.parent for task in detailed_tasks)

    # Extract section IDs from tasks.md
    all_sections = set(tasks_md_sections.keys())

    # Calculate coverage
    covered_count = len(covered_sections & all_sections)
    total_count = len(all_sections)
    coverage_percentage = (covered_count / total_count * 100) if total_count > 0 else 0

    # Identify uncovered sections
    uncovered = all_sections - covered_sections

    return {
        "covered_count": covered_count,
        "total_count": total_count,
        "coverage_percentage": coverage_percentage,
        "uncovered_sections": sorted(uncovered)
    }
```

---

## Part 6: Continuous Validation

### 6.1 Pre-Commit Hook Integration

```yaml
Recommendation: Run validation as pre-commit hook

Hook Configuration (.pre-commit-config.yaml):
  - repo: local
    hooks:
      - id: openspec-task-validation
        name: Validate OpenSpec Tasks
        entry: openspec validate --tasks tasks.md --detailed detailed-tasks.yaml
        language: system
        files: '(tasks\.md|detailed-tasks\.yaml)$'
        pass_filenames: false

Benefit:
  - Catch validation errors before commit
  - Maintain document quality
  - Prevent broken references
```

### 6.2 CI/CD Pipeline Integration

```yaml
Recommendation: Run validation in CI pipeline

GitHub Actions Example:
  name: OpenSpec Validation
  on: [push, pull_request]
  jobs:
    validate:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v2
        - name: Validate OpenSpec Tasks
          run: |
            openspec validate \
              --tasks standards/openspec/changes/*/tasks.md \
              --detailed standards/openspec/changes/*/detailed-tasks.yaml \
              --format json > validation-report.json
        - name: Upload Report
          uses: actions/upload-artifact@v2
          with:
            name: validation-report
            path: validation-report.json
```

### 6.3 Automated Correction

```yaml
Auto-Fix Candidates (Safe):
  - Checkbox format normalization: "- []" → "- [ ]"
  - Consistent indentation in YAML
  - Trailing whitespace removal
  - String quoting in parent fields: 1.1 → "1.1"

Manual Review Required:
  - Circular dependencies (need task redesign)
  - Missing parent references (need task reassignment or tasks.md update)
  - Title inconsistencies (need human judgment)
  - Orphaned tasks (delete or fix parent)

Proposed Command:
  openspec validate --tasks tasks.md --detailed detailed-tasks.yaml --fix
  # Applies safe auto-fixes and reports issues requiring manual review
```

---

## Related Documents

- [Detailed Tasks YAML Format](./detailed-tasks-yaml-format.md) - Field specifications
- [Task Synchronization Mechanism](./task-synchronization-spec.md) - Forward/backward sync
- [Parent Field Linking Rules](./parent-field-linking-spec.md) - Linking semantics
- [Phase A: Planning](../../core/ten-step-cycle/phase-a-spec-planning.md) - Context for A.1/A.2/A.3

---

**Version**: 1.0.0
**Created**: 2025-12-19
**Maintainer**: AI-DDD Development Team
