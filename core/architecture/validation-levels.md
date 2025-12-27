# Architecture Documentation Validation Levels

> **Version**: 1.0.0
> **Created**: 2025-12-27
> **Status**: production

## Overview

三级验证体系确保架构文档的质量和一致性，从自动化格式检查到人工质量审查。

## Three-Level Validation System

| Level | Name | Method | Purpose |
|-------|------|--------|---------|
| **Level 1** | Format Validation | Automatic | Structure and format correctness |
| **Level 2** | Content Validation | Semi-Auto | Coverage and consistency |
| **Level 3** | Quality Validation | Manual | Design clarity and accuracy |

---

## Level 1: Format Validation (Automatic)

### Checkpoints

| Check | Criteria | Pass Condition |
|-------|----------|----------------|
| File exists | Document file present | File readable |
| AI Index | Has AI Quick Index section | Section present with required fields |
| Core Value | Has Core Value section | ≤30 characters |
| Version History | Has version table | At least 1 entry |
| Timestamps | ISO 8601 format | Valid format |
| Encoding | UTF-8 | No encoding errors |

### Required Fields in AI Quick Index

```yaml
required:
  - "Document Type"
  - "Version"
  - "Created"
  - "Updated"
  - "Status"

optional:
  - "Author"
  - "Module Type"
  - "Core Function"
  - "Key Files"
  - "Dependencies"
```

### Validation Script Template

```bash
#!/bin/bash
# Level 1 Format Validation

validate_format() {
    local file=$1
    local errors=0

    # Check AI Quick Index
    if ! grep -q "## .*AI.*Index" "$file"; then
        echo "ERROR: Missing AI Quick Index"
        ((errors++))
    fi

    # Check Version field
    if ! grep -q "\*\*Version\*\*:" "$file"; then
        echo "ERROR: Missing Version field"
        ((errors++))
    fi

    # Check timestamps (ISO 8601)
    if ! grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}" "$file"; then
        echo "WARNING: No ISO 8601 timestamp found"
    fi

    return $errors
}
```

---

## Level 2: Content Validation (Semi-Automatic)

### Checkpoints

| Check | Criteria | Method |
|-------|----------|--------|
| File Coverage | All code files documented | Script comparison |
| Link Validity | All internal links work | Link checker |
| Dependency Accuracy | Listed deps match actual | Code analysis |
| Statistics Match | Counts match reality | Script verification |
| Cross-References | L0↔L1↔L2 links valid | Link traversal |

### Coverage Validation

```yaml
coverage_check:
  input:
    - code_directory: "lib/"
    - doc_file: "ARCHITECTURE.md"

  process:
    1. List all code files in directory
    2. Parse file list from document
    3. Compare sets
    4. Report missing/extra entries

  output:
    - coverage_percentage: N%
    - missing_files: [list]
    - extra_entries: [list]
```

### Dependency Validation

```yaml
dependency_check:
  input:
    - documented_deps: [from ARCHITECTURE.md]
    - actual_deps: [from import statements]

  validation:
    - All documented deps exist in code
    - Major deps in code are documented
    - No circular dependencies undocumented
```

### Link Validation

```bash
#!/bin/bash
# Level 2 Link Validation

validate_links() {
    local file=$1
    local base_dir=$(dirname "$file")

    # Extract markdown links
    grep -oE '\[.*\]\(([^)]+)\)' "$file" | \
    grep -oE '\(([^)]+)\)' | \
    tr -d '()' | \
    while read link; do
        # Skip external links
        [[ "$link" == http* ]] && continue

        # Check relative links
        local target="$base_dir/$link"
        if [[ ! -f "$target" ]]; then
            echo "BROKEN: $link"
        fi
    done
}
```

---

## Level 3: Quality Validation (Manual)

### Review Criteria

| Aspect | Question | Score |
|--------|----------|-------|
| **Clarity** | Is the architecture easy to understand? | 1-5 |
| **Accuracy** | Does it reflect current implementation? | 1-5 |
| **Completeness** | Are all important aspects covered? | 1-5 |
| **Usefulness** | Can a new developer use it effectively? | 1-5 |
| **Maintainability** | Is it easy to keep updated? | 1-5 |

### Review Checklist

```markdown
## Architecture Document Review

### Clarity
- [ ] Clear module boundaries defined
- [ ] Dependency relationships explained
- [ ] Design decisions documented with rationale
- [ ] Diagrams used where helpful

### Accuracy
- [ ] File list matches actual files
- [ ] Dependency list is current
- [ ] Statistics are accurate
- [ ] No outdated information

### Completeness
- [ ] All public APIs documented
- [ ] Error handling approach explained
- [ ] Edge cases noted
- [ ] Testing strategy mentioned

### Usefulness
- [ ] New developer can navigate codebase
- [ ] Common tasks are addressed
- [ ] Troubleshooting guidance provided
- [ ] Examples included where helpful

### Maintainability
- [ ] Uses standard templates
- [ ] No redundant information
- [ ] Links instead of duplicates
- [ ] Clear update triggers defined
```

### Review Frequency

| Document Level | Review Frequency |
|----------------|------------------|
| L0 Index | Monthly or on major changes |
| L1 Component | On feature releases |
| L2 Sub-Component | On significant refactoring |

---

## Validation Workflow

### Pre-Commit

```yaml
pre_commit:
  level: 1
  blocking: true
  actions:
    - Format validation
    - Required fields check
```

### Continuous Integration

```yaml
ci_pipeline:
  level: 1 + 2
  blocking: true
  actions:
    - Format validation
    - Coverage check
    - Link validation
```

### Periodic Review

```yaml
periodic:
  level: 3
  frequency: monthly
  blocking: false
  actions:
    - Manual quality review
    - Architecture drift check
    - Update recommendations
```

---

## Validation Reports

### Summary Format

```markdown
# Documentation Validation Report

**Date**: YYYY-MM-DD
**Scope**: [module/all]

## Summary
| Level | Passed | Failed | Warnings |
|-------|--------|--------|----------|
| L1 Format | N | N | N |
| L2 Content | N | N | N |
| L3 Quality | N/A | N/A | N/A |

## Details
...
```

### Issue Classification

| Severity | Description | Action |
|----------|-------------|--------|
| **Error** | Validation failed | Must fix before merge |
| **Warning** | Potential issue | Should fix, not blocking |
| **Info** | Suggestion | Consider for improvement |

---

## Integration with Development Workflow

### When to Validate

| Event | Validation Level |
|-------|-----------------|
| Creating new document | L1 |
| Updating document | L1 + L2 |
| Code refactoring | L1 + L2 |
| Pre-release | L1 + L2 + L3 |
| Monthly audit | L1 + L2 + L3 |

### Escalation Path

```
L1 Failure → Block commit
L2 Failure → Block PR merge
L3 Issues → Track in backlog
```
