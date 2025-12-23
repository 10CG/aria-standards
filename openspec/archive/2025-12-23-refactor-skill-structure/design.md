# Design: Refactor Skill Structure

> **Spec**: refactor-skill-structure
> **Created**: 2025-12-23

---

## 设计原则

### 1. 遵循成熟 Skill 模式

参考 `commit-msg-generator` 的成功模式：

```
commit-msg-generator/
├── SKILL.md              # 300 行 - 核心逻辑
├── ENHANCED_MARKERS_SPEC.md   # 485 行 - 规范定义
├── COMMIT_FOOTER_GUIDE.md     # 468 行 - 使用指南
├── EXAMPLES.md           # 示例文件
└── CHANGELOG.md          # 版本历史
```

**核心洞察**：
- SKILL.md 保持精简 (≤350 行)，聚焦 **执行流程** 和 **快速参考**
- 详细规范 (格式定义、计算规则) 移至 `*_SPEC.md`
- 使用指南 (决策树、最佳实践) 移至 `*_GUIDE.md`
- 示例代码移至 `EXAMPLES.md`

### 2. SKILL.md 保留内容

每个 SKILL.md 应保留：

```markdown
---
name: {skill-name}
description: |
  简短描述...
allowed-tools: ...
---

# {Skill Name}

> **版本**: x.x.x | **十步循环**: A.x

## 快速开始
### 我应该使用这个 skill 吗？
- 使用场景
- 不使用场景

## 核心功能
| 功能 | 描述 |
|------|------|

## 执行流程
(精简版，详细规范引用子文件)

## 输入参数
| 参数 | 必需 | 说明 | 示例 |

## 输出格式
(精简概述，详细格式引用子文件)

## 示例
(1-2 个核心示例，完整示例引用 EXAMPLES.md)

## 与其他 Skills 的协作
(简要流程图)

## 相关文档
- 子文件引用
- 外部文档引用
```

### 3. 子文件命名规范

| 后缀 | 用途 | 示例 |
|------|------|------|
| `*_SPEC.md` | 格式规范、计算规则、接口定义 | `DUAL_LAYER_SPEC.md` |
| `*_GUIDE.md` | 决策指南、最佳实践 | `LEVEL_GUIDE.md` |
| `EXAMPLES.md` | 完整示例集合 | `EXAMPLES.md` |
| `CHANGELOG.md` | 版本历史 | `CHANGELOG.md` |

---

## 拆分方案

### task-planner (689 → ≤350 行)

**当前内容分析**：

| 章节 | 行数 | 保留/拆分 | 目标文件 |
|------|------|-----------|----------|
| YAML Header + 标题 | 30 | 保留 | SKILL.md |
| 快速开始 | 30 | 保留 | SKILL.md |
| 核心功能表 | 20 | 保留 | SKILL.md |
| A.2.1-A.2.6 执行流程 | 200 | **拆分** | 精简版→SKILL.md, 详细规范→DUAL_LAYER_SPEC.md |
| 输入参数 | 20 | 保留 | SKILL.md |
| 输出格式 (Markdown) | 60 | 精简 | SKILL.md 保留概述 |
| 输出格式 (YAML) | 120 | **拆分** | DUAL_LAYER_SPEC.md |
| 依赖图 (ASCII) | 30 | **拆分** | EXAMPLES.md 或删除 |
| 使用示例 | 60 | 精简 | SKILL.md 保留 1 个 |
| Agent 分配规则 | 50 | **拆分** | AGENT_MAPPING.md |
| 错误处理 | 40 | 保留 | SKILL.md |
| 检查清单 | 30 | 保留 | SKILL.md |
| 相关文档 | 20 | 保留 | SKILL.md |

**拆分文件**：

1. **DUAL_LAYER_SPEC.md** (~200 行)
   - detailed-tasks.yaml 完整格式规范
   - parent 字段规则
   - 双层同步机制
   - 路径 A/B 详细流程

2. **AGENT_MAPPING.md** (~80 行)
   - Agent 能力矩阵
   - 分配规则
   - 文件类型匹配

### progress-updater (600 → ≤350 行)

**当前内容分析**：

| 章节 | 行数 | 保留/拆分 | 目标文件 |
|------|------|-----------|----------|
| YAML Header + 标题 | 20 | 保留 | SKILL.md |
| 快速开始 | 30 | 保留 | SKILL.md |
| 核心功能表 | 20 | 保留 | SKILL.md |
| D.1 执行流程 | 100 | 精简 | SKILL.md (50行) |
| stateToken 计算规范 | 80 | **拆分** | STATETOKEN_SPEC.md |
| 双层同步规则 | 100 | **拆分** | SYNC_RULES.md |
| 冲突检测与处理 | 80 | **拆分** | STATETOKEN_SPEC.md |
| 输入/输出 | 50 | 保留 | SKILL.md |
| 示例 | 80 | 精简 | SKILL.md (30行), EXAMPLES.md (已存在) |
| 其他 | 40 | 保留 | SKILL.md |

**拆分文件**：

1. **STATETOKEN_SPEC.md** (~150 行)
   - stateToken 计算公式
   - 冲突检测机制
   - 重试策略

2. **SYNC_RULES.md** (~100 行)
   - 双层架构后向同步
   - checkbox 更新规则
   - 冲突类型定义

### spec-drafter (479 → ≤350 行)

**当前内容分析**：

| 章节 | 行数 | 保留/拆分 | 目标文件 |
|------|------|-----------|----------|
| 核心内容 | 350 | 保留 | SKILL.md |
| Level 选择详细指南 | 80 | **拆分** | LEVEL_GUIDE.md |
| 模板内容 | 50 | **拆分** | LEVEL3_TEMPLATE.md (已存在) |

**拆分文件**：

1. **LEVEL_GUIDE.md** (~100 行)
   - Level 1/2/3 决策树
   - 详细判断条件
   - 边界案例

---

## 引用模式

子文件引用使用相对路径：

```markdown
## 输出格式

**概述**: detailed-tasks.yaml 是双层架构的细粒度任务规范。

**完整格式规范**: [DUAL_LAYER_SPEC.md](./DUAL_LAYER_SPEC.md)
```

---

## 验证方法

1. **行数验证**:
   ```bash
   wc -l .claude/skills/task-planner/SKILL.md
   # 期望: ≤350
   ```

2. **内容完整性验证**:
   ```bash
   # 拆分前后 grep 关键词
   grep -c "parent" task-planner/SKILL.md task-planner/DUAL_LAYER_SPEC.md
   ```

3. **引用有效性验证**:
   ```bash
   # 检查所有内部链接
   grep -o '\[.*\](\.\/.*\.md)' task-planner/SKILL.md
   # 验证文件存在
   ```
