# Branch Management Guide

> **Version**: 1.0.0
> **Status**: Active
> **Purpose**: Define Git branch management standards for the Ten-Step Cycle

---

## Overview

This guide establishes branch management conventions that integrate with the Spec-Enhanced AI-DDD Ten-Step Cycle, specifically supporting:
- **Step 4**: Branch Creation
- **Step 8**: Branch Merge / PR

---

## Branch Types

### 1. Main Branches (Protected)

| Branch | Purpose | Protection |
|--------|---------|------------|
| `main` | Production-ready code | Require PR, CI pass |
| `develop` | Integration branch | Require PR, CI pass |

### 2. Feature Branches

```
feature/{module}/{task-id}-{short-description}
```

| Component | Description | Example |
|-----------|-------------|---------|
| `{module}` | Target module | `backend`, `mobile`, `shared`, `cross` |
| `{task-id}` | Task identifier | `TASK-001`, `ISSUE-42` |
| `{short-description}` | Brief description | `user-auth`, `login-ui` |

**Examples**:
```
feature/backend/TASK-001-user-model
feature/mobile/TASK-002-login-ui
feature/shared/TASK-003-auth-contract
feature/cross/TASK-004-e2e-auth
```

### 3. Other Branch Types

| Pattern | Purpose | Example |
|---------|---------|---------|
| `bugfix/{module}/{issue}-{desc}` | Bug fixes | `bugfix/backend/ISSUE-99-null-check` |
| `hotfix/{version}-{desc}` | Production fixes | `hotfix/v1.2.1-security-patch` |
| `release/{version}` | Release preparation | `release/v1.3.0` |
| `experiment/{name}` | Experimental work | `experiment/openspec-pilot` |

---

## Branch Lifecycle

### Creation (Step 4)

```bash
# 1. Ensure develop is current
git checkout develop
git pull origin develop

# 2. Create feature branch
git checkout -b feature/{module}/{task-id}-{desc}

# 3. Push to remote with tracking
git push -u origin feature/{module}/{task-id}-{desc}
```

### Development (Steps 5-7)

```bash
# Regular commits during development
git add .
git commit -m "feat(scope): description"
git push origin feature/{module}/{task-id}-{desc}

# Keep branch updated with develop
git fetch origin develop
git rebase origin/develop
# Resolve conflicts if any
git push --force-with-lease origin feature/{module}/{task-id}-{desc}
```

### Merge (Step 8)

```bash
# Final rebase before merge
git fetch origin develop
git rebase origin/develop
git push --force-with-lease origin feature/{module}/{task-id}-{desc}

# Create PR
gh pr create \
  --title "feat(module): description" \
  --body "$(cat <<'EOF'
## Summary
Implements: `standards/openspec/changes/{feature}/spec.md`

## Changes
- Change 1
- Change 2

## Test Plan
- [ ] Tests pass
EOF
)"

# After approval, merge
gh pr merge --squash

# Clean up
git checkout develop
git pull origin develop
git branch -d feature/{module}/{task-id}-{desc}
git push origin --delete feature/{module}/{task-id}-{desc}
```

---

## Naming Conventions

### Module Identifiers

| Module | Identifier | Description |
|--------|------------|-------------|
| Backend | `backend` | Python/FastAPI services |
| Mobile | `mobile` | Flutter application |
| Shared | `shared` | API contracts, schemas |
| Cross-module | `cross` | Multi-module changes |
| Documentation | `docs` | Documentation only |
| Standards | `standards` | AI-DDD standards |

### Description Guidelines

- Use lowercase with hyphens
- Keep under 30 characters
- Be descriptive but concise
- Match Spec feature name when possible

**Good**:
```
user-auth
login-form
api-contract-v2
cache-layer
```

**Avoid**:
```
fix                    # Too vague
my-feature             # Not descriptive
UserAuthentication     # Wrong case
feature_implementation # Wrong separator
```

---

## Merge Strategies

### Squash Merge (Recommended)

```bash
gh pr merge --squash
```

**When to use**:
- Multiple small commits during development
- Want clean single commit in history
- Feature is self-contained

**Result**: All commits squashed into one

### Regular Merge

```bash
gh pr merge --merge
```

**When to use**:
- Want to preserve full commit history
- Large feature with meaningful commit breakdown
- Collaborative work with multiple authors

**Result**: All commits preserved with merge commit

### Rebase Merge

```bash
gh pr merge --rebase
```

**When to use**:
- Want linear history
- Small, focused changes
- No need for merge commit marker

**Result**: Commits replayed on top of base

---

## Conflict Resolution

### Before Creating PR

```bash
# Update with latest develop
git fetch origin develop
git rebase origin/develop

# If conflicts occur
git status                    # See conflicting files
# Edit files to resolve
git add <resolved-file>
git rebase --continue

# If rebase goes wrong
git rebase --abort            # Start over
```

### During PR Review

```bash
# If develop moves ahead during review
git fetch origin develop
git rebase origin/develop
git push --force-with-lease origin feature/{branch}
```

### Force Push Safety

Always use `--force-with-lease` instead of `--force`:
```bash
# Safe: fails if remote has new commits
git push --force-with-lease origin feature/{branch}

# Dangerous: overwrites remote unconditionally
git push --force origin feature/{branch}  # AVOID
```

---

## Branch Protection Rules

### Main Branch

```yaml
main:
  required_reviews: 1
  required_ci: true
  dismiss_stale_reviews: true
  require_up_to_date: true
  restrict_push: [maintainers]
```

### Develop Branch

```yaml
develop:
  required_reviews: 1
  required_ci: true
  dismiss_stale_reviews: false
  require_up_to_date: false
  restrict_push: [developers, maintainers]
```

---

## Submodule Considerations

### Working in Main Repo (Recommended)

When working from the main `todo-app` repository:

```bash
# All submodules are accessible
cd todo-app/
git checkout develop
git submodule update --init --recursive

# Create feature branch in main repo
git checkout -b feature/cross/TASK-001-feature

# Changes in submodules will show as submodule pointer updates
```

### Working in Individual Submodule

When working directly in a submodule:

```bash
cd todo-app/backend/
git checkout develop
git checkout -b feature/backend/TASK-001-api

# After completing work
git push origin feature/backend/TASK-001-api

# Return to main repo to update pointer
cd ..
git add backend
git commit -m "chore(submodule): update backend pointer"
```

---

## Quick Reference

### Branch Creation Checklist

- [ ] Develop branch is up to date
- [ ] Branch name follows convention
- [ ] Branch pushed to remote
- [ ] Related Spec exists (if applicable)

### Pre-Merge Checklist

- [ ] All commits follow conventions
- [ ] Branch rebased on latest develop
- [ ] All CI checks pass
- [ ] PR reviewed and approved
- [ ] Conflicts resolved

### Post-Merge Checklist

- [ ] Local develop updated
- [ ] Feature branch deleted locally
- [ ] Feature branch deleted from remote
- [ ] UPM updated (Step 9)

---

## Related Documents

- [Ten-Step Cycle Overview](../core/ten-step-cycle/README.md)
- [Phase B: Development](../core/ten-step-cycle/phase-b-development.md)
- [Phase C: Integration](../core/ten-step-cycle/phase-c-integration.md)
- [Git Commit Conventions](../conventions/git-commit.md)

---

**Version**: 1.0.0
**Created**: 2025-12-13
**Maintainer**: AI-DDD Development Team
