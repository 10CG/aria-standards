# Phase C: Commit & Integration

> **Phase**: C (Steps 7-8)
> **Focus**: Create versioned records and integrate changes safely
> **Key Principle**: Clean commits, safe merges

---

## Overview

Phase C handles version control and integration:
1. Creating well-formatted commits
2. Managing pull requests and merges

```
┌─────────────────────────────────────────┐
│       Phase C: Commit & Integration     │
│                                         │
│  Step 7: Git提交    ──▶ Commit SHA      │
│           │                             │
│           ▼                             │
│  Step 8: 分支合并   ──▶ PR Merged       │
│                                         │
└─────────────────────────────────────────┘
```

---

## Step 7: Git Commit

### Purpose
Create standardized version records.

### Trigger Conditions
- Step 6 architecture sync completed

### Input
- Code changes
- Documentation changes
- Spec reference

### Execution

```bash
# 1. Stage changes
git add .

# 2. Choose appropriate skill (see decision tree below)
# 3. Generate commit message
# 4. Execute commit
git commit -m "{message}"

# 5. Push to remote feature branch
git push origin feature/{branch-name}
```

### Output
- Commit SHA
- Push status

### Skill Selection Decision Tree

```
Need to group commits?
  ├─ YES (cross-module / batch docs / phase milestone)
  │   └─ Use: strategic-commit-orchestrator
  │       - Smart change grouping
  │       - Assign specialized subagents
  │       - Add Phase/Cycle context markers
  │       - Parallel/serial commit execution
  │
  └─ NO (single module / simple change)
      └─ Use: commit-msg-generator
          - Standard Conventional Commits
          - Simple and efficient
```

### Scenario Reference

| Scenario | Recommended Skill | Reason |
|----------|-------------------|--------|
| Single file bug fix | `commit-msg-generator` | Simple, direct |
| Single module feature | `commit-msg-generator` | No orchestration needed |
| **Backend + Shared API change** | `strategic-commit-orchestrator` | Cross-module coordination |
| **Batch architecture docs** | `strategic-commit-orchestrator` | Smart grouping |
| **Phase/Cycle milestone** | `strategic-commit-orchestrator` | Context tracking needed |

### Commit Message Formats

#### Simple Mode (commit-msg-generator)

```
<type>(<scope>): <中文描述> / <English description>

<body>

Spec: changes/{feature}/spec.md
<footer>
```

#### Orchestrated Mode (strategic-commit-orchestrator)

```
<type>(<scope>): <中文描述> / <English description>

<body>

🤖 Executed-By: {subagent_type} subagent

📋 Context: {Phase}-{Cycle} {context}

🔗 Module: {module_name}

Spec: changes/{feature}/spec.md
<footer>
```

### Commit Types

| Type | Usage | Example |
|------|-------|---------|
| `feat` | New feature | `feat(auth): 添加JWT认证` |
| `fix` | Bug fix | `fix(api): 修复token过期` |
| `docs` | Documentation | `docs(readme): 更新安装说明` |
| `refactor` | Code restructure | `refactor(service): 优化API结构` |
| `test` | Tests | `test(auth): 添加登录测试` |
| `chore` | Maintenance | `chore: 更新依赖` |

---

## Step 8: Branch Merge / PR

### Purpose
Safely integrate changes into the main branch.

### Trigger Conditions
- Step 7 Git commit completed

### Input
- Feature branch name
- Commit history
- Spec reference

### Execution

```bash
# 1. Sync develop branch
git fetch origin develop
git rebase origin/develop  # or merge

# 2. Resolve conflicts (if any)

# 3. Create Pull Request
gh pr create --title "{title}" --body "{body}"

# 4. Link Spec and Issue

# 5. Code review (if needed)

# 6. Merge to develop
gh pr merge --squash  # or --merge

# 7. Delete feature branch
git branch -d feature/{branch-name}
git push origin --delete feature/{branch-name}
```

### Output
- PR URL
- Merge status
- Develop branch confirmation

### PR Template

```markdown
## Summary
Implements: `standards/openspec/changes/{feature}/spec.md`
Related Issue: #{issue-number}

## Changes
- {Change 1}
- {Change 2}

## Test Plan
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Spec acceptance criteria satisfied
- [ ] Tests passing
- [ ] Documentation updated
- [ ] No security vulnerabilities
```

### Merge Strategies

| Strategy | Command | When to Use |
|----------|---------|-------------|
| Squash | `gh pr merge --squash` | Multiple small commits → clean single commit |
| Merge | `gh pr merge --merge` | Preserve full commit history |
| Rebase | `gh pr merge --rebase` | Linear history preferred |

### Suggested Skill
`pr-manager` (planned)

---

## Phase C Checklist

Before proceeding to Phase D, ensure:

- [ ] All changes committed with proper messages
- [ ] Feature branch pushed to remote
- [ ] PR created and reviewed
- [ ] All CI checks passing
- [ ] PR merged to develop
- [ ] Feature branch deleted

---

## Common Issues & Solutions

### Merge Conflicts

```bash
# Update your branch with latest develop
git fetch origin develop
git rebase origin/develop

# Resolve conflicts file by file
git add <resolved-file>
git rebase --continue

# If things go wrong
git rebase --abort
```

### Failed CI Checks

1. Check CI logs for specific failures
2. Fix issues locally
3. Push fixes: `git push origin feature/{branch}`
4. CI will re-run automatically

### PR Review Comments

1. Address each comment
2. Push additional commits or amend
3. Mark conversations as resolved
4. Request re-review if needed

---

## Related Documents

- [Ten-Step Cycle Overview](./README.md)
- [Phase B: Development](./phase-b-development.md)
- [Phase D: Closure](./phase-d-closure.md)
- [Git Commit Conventions](../../conventions/git-commit.md)

---

**Version**: 1.0.0
**Created**: 2025-12-13
