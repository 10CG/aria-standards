# Refactor Skill Structure

> **Level**: Full (Level 3)
> **Status**: Draft
> **Created**: 2025-12-23
> **Module**: .claude/skills

---

## Why

### 问题描述

当前新增的 Skills (2025-12 创建) 存在以下问题：

1. **SKILL.md 行数过高**：
   - `task-planner/SKILL.md`: 689 行
   - `progress-updater/SKILL.md`: 600 行
   - `spec-drafter/SKILL.md`: 479 行
   - 对比成熟 skill: `commit-msg-generator/SKILL.md` 仅 300 行

2. **内容组织不合理**：
   - 大量示例代码内嵌在 SKILL.md 中
   - YAML 格式规范和模板未分离
   - 执行流程描述过于详细

3. **缺乏子文件模块化**：
   - 成熟 skill (`commit-msg-generator`) 有良好的子文件分离：
     - `SKILL.md`: 300 行 (核心逻辑)
     - `ENHANCED_MARKERS_SPEC.md`: 485 行 (规范文档)
     - `COMMIT_FOOTER_GUIDE.md`: 468 行 (指南文档)
     - `EXAMPLES.md`: 可选示例文件
   - 新增 skill 只有 `SKILL.md` + 少量辅助文件

### 影响

- AI 读取 SKILL.md 时 Token 消耗过高
- 核心逻辑被详细规范淹没，不易快速理解
- 维护和更新困难
- 与成熟 skill 结构不一致

---

## What

### 解决方案

参考成熟 skill (`commit-msg-generator`) 的结构，将新增 Skills 的 SKILL.md 进行模块化拆分：

**目标结构**（每个 skill 目录）：

```
{skill-name}/
├── SKILL.md              # 核心逻辑 (目标: ≤350 行)
├── {SPEC}.md             # 规范/格式定义 (按需)
├── {GUIDE}.md            # 使用指南 (按需)
├── EXAMPLES.md           # 完整示例 (可选)
└── CHANGELOG.md          # 版本历史 (推荐)
```

### Key Deliverables

1. **task-planner 重构**
   - `SKILL.md`: 核心流程 + 快速参考 (目标 ≤350 行)
   - `DUAL_LAYER_SPEC.md`: 双层架构规范 (tasks.md + detailed-tasks.yaml 格式)
   - `AGENT_MAPPING.md`: Agent 分配规则
   - `COMPLEXITY_GUIDE.md`: 已存在，保持

2. **progress-updater 重构**
   - `SKILL.md`: 核心流程 (目标 ≤350 行)
   - `STATETOKEN_SPEC.md`: stateToken 计算和冲突检测规范
   - `SYNC_RULES.md`: 双层同步规则
   - `EXAMPLES.md`: 已存在，保持

3. **spec-drafter 重构**
   - `SKILL.md`: 核心流程 (目标 ≤350 行)
   - `LEVEL_GUIDE.md`: Level 1/2/3 选择指南
   - `LEVEL3_TEMPLATE.md`: 已存在，保持

---

## Impact

| Type | Description |
|------|-------------|
| **Positive** | SKILL.md 行数降低 50%+，Token 消耗减少 |
| **Positive** | 结构与成熟 skill 一致，易于维护 |
| **Positive** | 规范文档独立，可单独引用 |
| **Risk** | 重构过程可能引入遗漏 |
| **Mitigation** | 使用 diff 验证内容完整性，执行前后对比测试 |

---

## Scope

### In Scope

- `task-planner/SKILL.md` 拆分
- `progress-updater/SKILL.md` 拆分
- `spec-drafter/SKILL.md` 拆分

### Out of Scope

- 其他 skills (行数 ≤400 的不处理)
- 功能逻辑变更 (仅结构重组)
- `state-scanner`, `branch-manager` 等 (行数可接受)

---

## Success Criteria

- [ ] 所有目标 skill 的 SKILL.md ≤350 行
- [ ] 拆分出的子文件内容完整，无遗漏
- [ ] 子文件遵循成熟 skill 的命名模式 (`*_SPEC.md`, `*_GUIDE.md`)
- [ ] SKILL.md 保持快速参考表和执行流程，详细规范移至子文件
- [ ] 所有内部引用正确 (如 `[详见](./DUAL_LAYER_SPEC.md)`)

---

## References

### 成熟 Skill 结构参考

**commit-msg-generator/** (300 行 SKILL.md + 3 个子文件):
- 核心: 快速开始 + 核心功能 + 执行流程 + 示例 (简化版) + 输出格式
- 分离: ENHANCED_MARKERS_SPEC.md (增强标记规范)
- 分离: COMMIT_FOOTER_GUIDE.md (Footer 指南)

### 行数对比

| Skill | 当前 SKILL.md | 目标 SKILL.md | 预计拆分 |
|-------|---------------|---------------|----------|
| task-planner | 689 | ≤350 | ~350 行移至子文件 |
| progress-updater | 600 | ≤350 | ~250 行移至子文件 |
| spec-drafter | 479 | ≤350 | ~130 行移至子文件 |

---

## Related Documents

- [commit-msg-generator/SKILL.md](../../.claude/skills/commit-msg-generator/SKILL.md) - 结构参考
- [AI 开发协作架构设计](../../.claude/docs/CONVENTIONS_SKILLS_COLLABORATION.md)
