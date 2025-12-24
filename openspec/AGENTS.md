# AI Agent Instructions for Standards Repository

## Working Directory Protocol

When executing OpenSpec commands in this repository, you MUST:

1. Change to the standards directory first:
   ```bash
   cd standards
   ```

2. Execute OpenSpec commands:
   ```bash
   openspec list
   openspec validate [change]
   ```

3. Return to main directory when done:
   ```bash
   cd ..
   ```

**NEVER** execute `openspec` commands from the main repository root unless explicitly intended for the main repository's openspec/.

## Workflow

### Creating a new standard:
1. `/openspec:proposal [description]`
2. Generate Delta-based specs (ADDED/MODIFIED/REMOVED)
3. `openspec validate [change] --strict` (if CLI available)
4. `/openspec:apply [change]`
5. `openspec archive [change]`
6. **⚠️ 验证归档目录** (见下方 Known Issues)

## ⚠️ Known Issues

### 归档目录位置 Bug

**问题**: `openspec archive` CLI 有 bug，会将归档放入错误位置：
- ❌ 错误: `openspec/changes/archive/`
- ✅ 正确: `openspec/archive/`

**必须执行的验证步骤**:

归档后立即检查：
```bash
# 检查是否有错误位置
ls openspec/changes/archive/ 2>/dev/null

# 如果有内容，手动修正：
mv openspec/changes/archive/<archived-change> openspec/archive/
rmdir openspec/changes/archive
```

或使用验证脚本：
```bash
bash scripts/verify-openspec-archive.sh
```

**正确的目录结构**:
```
openspec/
├── archive/           ← 归档变更 (正确位置)
│   └── 2025-xx-xx-change-name/
├── changes/           ← 活跃变更
│   └── active-change/
└── specs/             ← 规范文档
```

### Quality Gates

Before archiving, check:
- [ ] **Simplicity**: Using ≤3 new concepts?
- [ ] **Clarity**: Can a new developer understand in 5 minutes?
- [ ] **Consistency**: Aligned with existing standards?
- [ ] **Enforceability**: Can be automatically checked?

## Seven-Step Cycle Integration

1-3. **State Recognition → Planning**: `/openspec:proposal`
4. **Quality Gates**: `openspec validate` (or manual checklist)
5. **Execution**: `/openspec:apply`
6-7. **Update & Validation**: `openspec archive`

## Delta Mechanism

All spec changes MUST use Delta markers:

- **ADDED**: New content being introduced
- **MODIFIED**: Existing content being changed
- **REMOVED**: Existing content being deleted
- **RENAMED**: Content being renamed or moved

Example:
```markdown
## ADDED Requirements

### Requirement: New Coding Standard
All TypeScript files MUST use strict mode.

## MODIFIED Requirements

### Requirement: Git Commit Format
~~Old format: `[TYPE] message`~~
New format: `type(scope): message`

## REMOVED Requirements

### ~~Requirement: Deprecated Practice~~
~~This requirement is no longer applicable.~~
```

## Agent-Specific Instructions

### For knowledge-manager agent:
When managing standards documentation, you MUST:
- Create all specs in `openspec/specs/` using capability-based organization
- Use Delta markers (ADDED/MODIFIED/REMOVED) for all changes
- Update `openspec/project.md` when scope changes

### For tech-lead agent:
When reviewing architectural decisions:
- Reference standards from `openspec/specs/architecture/`
- Enforce Contract-First principle
- Ensure changes have cross-repo impact assessment

### For qa-engineer agent:
When reviewing quality gates:
- Reference quality definitions from `openspec/specs/quality/`
- Ensure all gates are measurable and enforceable
- Validate that standards can be automated

## Reference to .claude/agents

This AGENTS.md complements (not replaces) the specialized agents defined in `.claude/agents/`.

**Relationship**:
- `.claude/agents/` → Defines "WHO" (role expertise)
- `openspec/AGENTS.md` → Defines "HOW" (project workflow rules)

The specialized agents should read and follow the instructions in this file when working within the standards repository.
