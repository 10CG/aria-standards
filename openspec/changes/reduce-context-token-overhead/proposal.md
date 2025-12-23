# Proposal: Reduce Context Token Overhead

> **Status**: Draft
> **Level**: Full (Level 3)
> **Created**: 2025-12-23
> **Author**: AI Analysis

---

## Problem Statement

当前项目的 Claude Code 预加载上下文规则导致 tokens 消耗过大，严重影响开发效率和成本。

---

## Root Cause Analysis (深度原因分析)

### 1. 数据统计

| 组件 | 大小 | 说明 |
|------|------|------|
| **CLAUDE.md (主)** | 13,648 bytes (379 行) | 项目入口配置 |
| **standards/ 目录** | 1,343,384 bytes (~1.3 MB) | AI-DDD 规范库 |
| **.claude/ 目录** | 1,017,350 bytes (~1 MB) | Skills + Agents + Docs |
| **Total** | **~2.4 MB** | 纯文本上下文 |

### 2. CLAUDE.md 引用的文件分析

CLAUDE.md 通过 `@` 语法引用了 **18+ 个大型规范文件**：

| 文件 | 大小 | Tokens (估算) |
|------|------|--------------|
| `implementation-best-practices.md` | 36,450 bytes | ~9,000 |
| `document-sync-mechanisms.md` | 36,216 bytes | ~9,000 |
| `phase-a-spec-planning.md` | 26,806 bytes | ~6,700 |
| `ai-ddd-workflow-standards.md` | 24,044 bytes | ~6,000 |
| `ai-ddd-state-management.md` | 23,204 bytes | ~5,800 |
| `mobile-ai-ddd-extension.md` | 19,816 bytes | ~5,000 |
| `unified-progress-management-spec.md` | 18,445 bytes | ~4,600 |
| `backend-ai-ddd-extension.md` | 18,448 bytes | ~4,600 |
| `ai-ddd-progress-management-core.md` | 15,236 bytes | ~3,800 |
| `CONVENTIONS_SKILLS_COLLABORATION.md` | 12,793 bytes | ~3,200 |
| `ten-step-cycle/README.md` | 11,783 bytes | ~2,900 |
| **其他 8+ 文件** | ~50,000 bytes | ~12,500 |
| **Total Referenced** | **~273 KB** | **~68,000+ tokens** |

### 3. 问题根源分析

#### 3.1 Context Injection 机制 (核心问题)

Claude Code 的 `claudeMd` 上下文加载机制会：
1. **预加载主 CLAUDE.md** (~380 行)
2. **自动展开 @ 引用的文件** (18+ 个文件全部内联)
3. **加载子模块 CLAUDE.md** (backend + mobile 共 312 行)

这意味着 **每次对话开始时，自动注入 ~70,000+ tokens 的上下文**！

#### 3.2 引用文件内容膨胀

| 问题 | 描述 | 影响 |
|------|------|------|
| **冗余示例** | 每个规范文件包含大量示例代码 | +30% tokens |
| **重复定义** | 多个文件定义相同概念 (如 Stage 定义) | +20% tokens |
| **历史兼容** | 保留已废弃的七步循环同时有十步循环 | +15% tokens |
| **完整 YAML 模板** | 每个文档嵌入完整的 YAML 模板 | +25% tokens |

#### 3.3 文档结构问题

```
CLAUDE.md
├── 直接内容: ~13 KB (合理)
└── @ 引用展开: ~273 KB (问题!)
    ├── standards/core/workflow/*.md (4 files, ~110 KB)
    ├── standards/core/ten-step-cycle/*.md (~38 KB)
    ├── standards/core/progress-management/*.md (~15 KB)
    ├── standards/core/state-management/*.md (~23 KB)
    ├── standards/core/upm/*.md (~18 KB)
    ├── standards/extensions/*.md (2 files, ~38 KB)
    ├── standards/conventions/*.md (3 files, ~27 KB)
    └── .claude/docs/*.md (~13 KB)
```

### 4. 问题严重程度

| 指标 | 当前值 | 目标值 | 差距 |
|------|--------|--------|------|
| 初始上下文 | ~70,000 tokens | <10,000 tokens | **7x 超标** |
| 每次对话成本 | ~$0.21 (input) | ~$0.03 | 7x 成本 |
| 可用对话空间 | ~30,000 tokens | ~90,000 tokens | 60% 损失 |

---

## Why (为什么需要解决)

1. **成本问题**: 每次对话预消耗 70K tokens，按 Claude API 价格计算成本过高
2. **效率问题**: 可用上下文空间减少 60%，限制了复杂任务处理能力
3. **响应延迟**: 大量上下文导致首次响应延迟增加
4. **开发体验**: 长上下文导致 AI 响应时间变长，影响开发流程

---

## What (解决方案)

### 1. CLAUDE.md 精简策略

#### 1.1 移除 @ 引用自动展开

**核心改变**: 将 `@file.md` 引用改为 **"按需加载"** 模式

```markdown
# Before (当前)
详细规范请参考:
- @standards/core/workflow/ai-context-loading.md (SSOT)

# After (改进)
详细规范请参考:
- `standards/core/workflow/ai-context-loading.md` (按需读取)
```

#### 1.2 保留精简快速参考

CLAUDE.md 保留 **关键规则摘要**，而非完整规范：

```markdown
## Git Commit (快速参考)

| Type | 用途 |
|------|------|
| feat | 新功能 |
| fix | Bug修复 |

> 完整规范: `standards/conventions/git-commit.md`
```

### 2. 规范文件分层策略

#### 2.1 创建 SUMMARY 层

为每个大型规范创建 `*-summary.md` 摘要版本：

| 原文件 | 摘要版本 | 压缩比 |
|--------|----------|--------|
| `ai-ddd-workflow-standards.md` (24 KB) | `ai-ddd-workflow-summary.md` (~3 KB) | 87% |
| `implementation-best-practices.md` (36 KB) | `best-practices-summary.md` (~4 KB) | 89% |

#### 2.2 CLAUDE.md 引用摘要版本

```markdown
### 标准规范引用

- `standards/summaries/ten-step-cycle-summary.md` - 十步循环快速参考
- `standards/summaries/workflow-summary.md` - 工作流快速参考

> 详细规范按需查阅 `standards/core/` 目录
```

### 3. 按需加载机制

#### 3.1 定义加载层级

| 层级 | 加载时机 | 内容 | 大小限制 |
|------|---------|------|---------|
| **L0 (Always)** | 每次对话开始 | CLAUDE.md 核心内容 | <5 KB |
| **L1 (On-Demand)** | 相关任务时 | 模块 ARCHITECTURE.md | <10 KB |
| **L2 (Deep-Dive)** | 明确请求时 | 完整规范文档 | 无限制 |

#### 3.2 CLAUDE.md L0 精简版

```markdown
# Todo App - AI配置 (L0)

## 项目概述
Todo App - 多模块全栈应用，Git Submodule 架构。

## 模块
| 模块 | 路径 | 说明 |
|------|------|------|
| backend | `backend/` | FastAPI |
| mobile | `mobile/` | Flutter |
| shared | `shared/` | API契约 |
| standards | `standards/` | 规范 |

## 关键规则
1. 禁止 AI 签名
2. 双语 commit 格式
3. 契约先行

## 按需加载
- Git 规范: `standards/conventions/git-commit.md`
- 十步循环: `standards/core/ten-step-cycle/README.md`
- 架构文档: `{module}/docs/ARCHITECTURE.md`
```

### 4. 文档瘦身策略

#### 4.1 规范文件瘦身

| 优化项 | 方法 | 预期节省 |
|--------|------|---------|
| 示例代码 | 移到独立 EXAMPLES.md | 30% |
| YAML 模板 | 移到 TEMPLATES.md | 25% |
| 重复定义 | 统一引用单一 SSOT | 20% |
| 历史内容 | 移到 archive/ | 15% |

#### 4.2 废弃文件清理

- 七步循环 → 已被十步循环替代，保留简短引用
- 重复的 extension 定义 → 合并

---

## Impact (影响评估)

### Positive

| 指标 | Before | After | 改善 |
|------|--------|-------|------|
| 初始上下文 | ~70,000 tokens | <8,000 tokens | **87% 减少** |
| 每次对话成本 | ~$0.21 | ~$0.024 | **87% 节省** |
| 可用对话空间 | ~30,000 tokens | ~92,000 tokens | **3x 增加** |
| 首次响应延迟 | ~3-5s | <1s | **3x 加速** |

### Risk

| 风险 | 缓解措施 |
|------|---------|
| AI 遗漏重要规范 | 保留关键规则摘要在 L0 |
| 增加文档维护成本 | 自动化生成 summary 文件 |
| 开发者学习曲线 | 提供迁移指南 |

---

## Success Criteria

1. [ ] CLAUDE.md 主文件 < 5 KB (当前 13.6 KB)
2. [ ] 初始预加载上下文 < 10,000 tokens (当前 ~70,000)
3. [ ] 创建 standards/summaries/ 摘要层
4. [ ] 更新所有 @ 引用为按需加载模式
5. [ ] 验证 AI 仍能正确执行开发任务

---

## Related

- OpenSpec: `openspec/AGENTS.md`
- AI Context Loading: `standards/core/workflow/ai-context-loading.md`
- Claude Skills: `.claude/docs/CONVENTIONS_SKILLS_COLLABORATION.md`
