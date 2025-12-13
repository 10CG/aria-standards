# Phase B: Development Execution

> **Phase**: B (Steps 4-6)
> **Focus**: Implement features in isolated environments
> **Key Principle**: Branch-based development with continuous verification

---

## Overview

Phase B handles the actual development work:
1. Creating isolated development branches
2. Implementing and verifying against Spec
3. Keeping documentation in sync

```
┌─────────────────────────────────────────┐
│       Phase B: Development Execution    │
│                                         │
│  Step 4: 分支创建  ──▶ feature branch   │
│           │                             │
│           ▼                             │
│  Step 5: 执行验证  ──▶ Code + Tests     │
│           │                             │
│           ▼                             │
│  Step 6: 架构同步  ──▶ Updated Docs     │
│                                         │
└─────────────────────────────────────────┘
```

---

## Step 4: Branch Creation

### Purpose
Create an isolated development environment for the task.

### Trigger Conditions
- Step 3 Agent assignment completed

### Input
- Task ID
- Target module (backend/mobile/shared)
- Spec reference

### Execution

```bash
# 1. Ensure develop branch is up to date
git checkout develop && git pull origin develop

# 2. Create feature branch
git checkout -b feature/{module}/{task-id}-{short-desc}

# 3. Push to remote
git push -u origin feature/{module}/{task-id}-{short-desc}

# 4. (Optional) Create Spec reference file in branch
```

### Output
- Branch name
- Remote push status

### Branch Naming Convention

| Pattern | Example | Use Case |
|---------|---------|----------|
| `feature/{module}/{task-id}-{desc}` | `feature/backend/TASK-001-user-model` | Single module |
| `feature/cross/{task-id}-{desc}` | `feature/cross/TASK-004-auth-integration` | Cross-module |

### Examples

```bash
# Backend feature
feature/backend/TASK-001-user-model
feature/backend/TASK-002-jwt-auth

# Mobile feature
feature/mobile/TASK-003-login-ui
feature/mobile/TASK-004-form-validation

# Shared contracts
feature/shared/TASK-005-auth-contract

# Cross-module integration
feature/cross/TASK-006-auth-e2e
```

### Suggested Skill
`branch-manager` (planned)

---

## Step 5: Execution & Verification

### Purpose
Implement features and verify they meet Spec requirements.

### Trigger Conditions
- Step 4 branch creation completed

### Input
- Spec file
- Branch name
- UPM task information

### Execution

1. **Write Code** on feature branch
2. **Verify** against Spec acceptance criteria
3. **Run Tests**
   ```bash
   # Backend
   pytest tests/ -v

   # Mobile
   flutter test --reporter=compact --concurrency=1
   ```
4. **Quality Checks**
   - Lint check
   - Type check
   - Security scan

### Output
- Code changes
- Test results
- Quality report

### Verification Checklist

```yaml
Acceptance Criteria:
  - [ ] All Spec criteria satisfied
  - [ ] Unit tests pass
  - [ ] Integration tests pass (if applicable)

Quality Gates:
  - [ ] Lint check passes
  - [ ] Type check passes
  - [ ] No security vulnerabilities
  - [ ] Code coverage maintained/improved

Performance:
  - [ ] No regression in response times
  - [ ] Memory usage acceptable
```

### Available Skills

| Skill | Module | Coverage |
|-------|--------|----------|
| `flutter-test-generator` | Mobile | 30% |

### Test Commands Reference

```bash
# Mobile (Flutter)
flutter test --reporter=compact --concurrency=1
flutter analyze

# Backend (Python)
pytest tests/ -v --cov=src
flake8 src/
mypy src/
```

---

## Step 6: Architecture Sync

### Purpose
Ensure documentation remains consistent with implementation.

### Trigger Conditions
- Step 5 execution verification passed

### Input
- Code changes
- Spec reference

### Execution

1. **Update Architecture Documents**
   - `{module}/docs/architecture/ARCHITECTURE.md`
   - Component diagrams, sequence diagrams, etc.

2. **Sync API Documentation** (if API changed)
   - `shared/contracts/openapi/*.yaml`

3. **Update README** (if needed)

### Output
- Updated architecture documents
- API documentation change record

### Documentation Update Checklist

```yaml
Architecture Docs:
  - [ ] Component diagram updated
  - [ ] Sequence diagrams reflect new flows
  - [ ] Data models documented
  - [ ] Dependencies noted

API Docs:
  - [ ] OpenAPI spec updated
  - [ ] Request/response examples added
  - [ ] Error codes documented
  - [ ] Authentication requirements specified

README:
  - [ ] Setup instructions current
  - [ ] Environment variables listed
  - [ ] New features documented
```

### Available Skills

| Skill | Purpose |
|-------|---------|
| `architecture-doc-updater` | Update ARCHITECTURE.md |
| `api-doc-generator` | Generate OpenAPI specs |

---

## Phase B Checklist

Before proceeding to Phase C, ensure:

- [ ] Feature branch created and pushed
- [ ] All code implemented
- [ ] All tests passing
- [ ] Quality checks passing
- [ ] Architecture documents updated
- [ ] API documentation synced (if applicable)

---

## Common Issues & Solutions

### Branch Conflicts

```bash
# If develop has moved ahead
git fetch origin develop
git rebase origin/develop

# Resolve conflicts if any
git add .
git rebase --continue
```

### Test Failures

1. Check test environment setup
2. Verify mock data is current
3. Ensure dependencies are installed
4. Check for race conditions in async tests

### Documentation Gaps

1. Review Spec for documentation requirements
2. Use `architecture-doc-updater` skill
3. Cross-reference with existing docs

---

## Related Documents

- [Ten-Step Cycle Overview](./README.md)
- [Phase A: Planning](./phase-a-spec-planning.md)
- [Phase C: Integration](./phase-c-integration.md)
- [Branch Management Guide](../../workflow/branch-management-guide.md)

---

**Version**: 1.0.0
**Created**: 2025-12-13
