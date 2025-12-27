# Architecture Documentation Lifecycle Management

> **Version**: 1.0.0
> **Created**: 2025-12-28
> **Status**: production

## Overview

生命周期管理规范定义了架构文档从创建到归档的完整流程，确保文档与代码同步更新。

## Document Lifecycle

```
┌─────────┐    ┌────────────┐    ┌────────────┐    ┌──────────┐
│ Create  │ →  │ Production │ →  │ Deprecated │ →  │ Archived │
└─────────┘    └────────────┘    └────────────┘    └──────────┘
     │               │                  │                │
     │               │                  │                │
   Draft          Active            Warning          Read-only
```

---

## Lifecycle Stages

### Stage 1: Creation

**Trigger Conditions**:
- New module with ≥5 code files
- New major component (≥10 files)
- New functional sub-component (5-10 files)

**Actions**:
1. Determine document level (L0/L1/L2)
2. Select appropriate template
3. Fill in initial content
4. Set status to `draft`
5. Run Level 1 validation

**Responsibility**: Developer creating the module

### Stage 2: Production

**Trigger Conditions**:
- Draft document reviewed and approved
- Module goes live
- Initial code complete

**Actions**:
1. Set status to `production`
2. Run Level 1 + Level 2 validation
3. Update parent document references
4. Add to documentation index

**Responsibility**: Developer + Tech Lead review

### Stage 3: Update

**Trigger Conditions**:
- Code file added/removed/renamed
- Significant code changes
- Dependency changes
- Design decision changes

**Actions**:
1. Update file lists (mark ⭐ new, ❌ deleted)
2. Update statistics
3. Increment version (patch or minor)
4. Update timestamp
5. Add version history entry

**Update Frequency**:
| Change Type | Update Timing |
|-------------|---------------|
| File added/removed | Same commit |
| Refactoring | Same PR |
| Bug fixes | Optional |
| Config changes | Not required |

**Responsibility**: Developer making the change

### Stage 4: Deprecation

**Trigger Conditions**:
- Module scheduled for removal
- Major architectural change planned
- Replacement module available

**Actions**:
1. Set status to `deprecated`
2. Add deprecation notice with removal date
3. Link to replacement documentation
4. Notify dependent modules
5. Add to deprecation tracking

**Template**:
```markdown
> ⚠️ **DEPRECATED**: This module is deprecated as of YYYY-MM-DD.
> Use [New Module](link) instead.
> Scheduled removal: YYYY-MM-DD
```

**Responsibility**: Tech Lead or Architect

### Stage 5: Archival

**Trigger Conditions**:
- 3 months after deprecation
- Module completely removed
- No more references

**Actions**:
1. Move to `archived/` directory
2. Set status to `archived`
3. Remove from active indexes
4. Update all incoming references

**Responsibility**: Automated process or designated maintainer

---

## Update Triggers

### Must Update

| Event | Required Action |
|-------|-----------------|
| Add code file | Add to file list with ⭐ |
| Remove code file | Mark with ❌, update stats |
| Rename file | Update entry, mark with 🔄 |
| Add dependency | Update dependency section |
| Remove dependency | Update dependency section |
| Change architecture | Update design decisions |

### Should Update

| Event | Recommended Action |
|-------|-------------------|
| Major bug fix | Note in design decisions |
| Performance improvement | Update if architecture changed |
| Test coverage change | Update statistics |

### No Update Needed

| Event | Reason |
|-------|--------|
| Internal refactoring (same API) | No architectural impact |
| Documentation fix in code | Comments, not architecture |
| Dependency version bump | Unless breaking change |
| Config file changes | Unless affects architecture |

---

## Responsibility Matrix

### RACI Model

| Activity | Developer | Tech Lead | Architect | Automation |
|----------|-----------|-----------|-----------|------------|
| Create draft | R | C | C | - |
| Approve production | C | A | I | - |
| Regular updates | R | - | - | - |
| Major refactoring | R | A | C | - |
| Deprecation decision | I | R | A | - |
| Archival | - | I | I | R |
| Validation | C | I | - | R |

R = Responsible, A = Accountable, C = Consulted, I = Informed

---

## Quality Assurance

### Pre-Commit Checks

```yaml
pre_commit:
  - Format validation (Level 1)
  - Required fields present
  - Version incremented if content changed
```

### PR Review Checks

```yaml
pr_review:
  - Coverage validation (Level 2)
  - Link validation
  - Consistency with code changes
```

### Periodic Audits

| Frequency | Scope | Actions |
|-----------|-------|---------|
| Weekly | Active documents | Quick sanity check |
| Monthly | All documents | Full Level 1+2 validation |
| Quarterly | Architecture | Level 3 quality review |

---

## Rollback Mechanism

### When to Rollback

- Validation failures after update
- Incorrect changes merged
- Architecture revert needed

### Rollback Process

```bash
# 1. Identify the correct version
git log -- path/to/ARCHITECTURE.md

# 2. Restore previous version
git checkout <commit-hash> -- path/to/ARCHITECTURE.md

# 3. Update version and timestamp
# Increment patch version
# Update timestamp to current

# 4. Add version history entry
# Note: "Rollback from X.Y.Z due to [reason]"
```

### Version Retention

| Type | Retention |
|------|-----------|
| Git history | Forever |
| Explicit backups | Last 10 versions |
| Archived documents | 1 year minimum |

---

## Health Metrics

### Document Health Score

Calculate health based on:

| Factor | Weight | Criteria |
|--------|--------|----------|
| Freshness | 30% | Updated within last 30 days |
| Coverage | 25% | 100% file coverage |
| Validation | 25% | Passes Level 1+2 |
| Completeness | 20% | All required sections |

### Health Thresholds

| Score | Status | Action |
|-------|--------|--------|
| 90-100% | Healthy | Maintain |
| 70-89% | Warning | Review soon |
| 50-69% | Critical | Update required |
| <50% | Failing | Immediate action |

---

## Automation Support

### Recommended Automation

| Task | Tool/Script | Frequency |
|------|-------------|-----------|
| Generate TREE | `arch_tree_generate.py` | On demand |
| Validate format | `arch_check.sh` | Pre-commit |
| Check coverage | Custom script | CI pipeline |
| Update timestamps | Git hooks | On commit |

### Integration Points

```yaml
ci_integration:
  on_push:
    - Run Level 1 validation
  on_pr:
    - Run Level 1 + Level 2
    - Check documentation updated with code
  scheduled:
    - Monthly full audit
```

