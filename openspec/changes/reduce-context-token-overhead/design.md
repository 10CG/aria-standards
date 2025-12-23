# Design: Reduce Context Token Overhead

> **Spec**: reduce-context-token-overhead
> **Created**: 2025-12-23
> **Author**: AI Analysis

---

## Architecture Overview

### Current State (问题架构)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Claude Code Context Loading                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   CLAUDE.md (13.6 KB)                                               │
│   ├── OpenSpec Instructions                                          │
│   ├── 项目概述                                                       │
│   ├── @ 引用 ──────────────────────────────────────────────────────┐│
│   │   └── 18+ 文件自动展开 (~273 KB)                                ││
│   │       ├── standards/core/workflow/*.md (4 files, 110 KB)        ││
│   │       ├── standards/core/ten-step-cycle/*.md (38 KB)            ││
│   │       ├── standards/core/progress-management/*.md (15 KB)       ││
│   │       ├── standards/core/state-management/*.md (23 KB)          ││
│   │       ├── standards/core/upm/*.md (18 KB)                       ││
│   │       ├── standards/extensions/*.md (38 KB)                     ││
│   │       ├── standards/conventions/*.md (27 KB)                    ││
│   │       └── .claude/docs/*.md (13 KB)                             ││
│   │                                                                 ││
│   └── 子模块 CLAUDE.md (312 行)                                     ││
│       ├── backend/CLAUDE.md (206 行)                                ││
│       └── mobile/CLAUDE.md (106 行)                                 ││
│                                                                     ││
│   Total Initial Context: ~286 KB ≈ 70,000+ tokens                  ││
│                                                                     │└──
└─────────────────────────────────────────────────────────────────────┘
```

### Target State (目标架构)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Claude Code Context Loading (Optimized)           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌───────────────────────────────────────────────────────────┐     │
│   │                    L0: Always Loaded                        │     │
│   │                    (~8,000 tokens max)                      │     │
│   ├───────────────────────────────────────────────────────────┤     │
│   │ CLAUDE.md (精简版, <5 KB)                                   │     │
│   │ ├── 项目概述 (10 行)                                        │     │
│   │ ├── 模块表格 (5 行)                                         │     │
│   │ ├── 关键规则摘要 (20 行)                                    │     │
│   │ └── 按需加载指引 (10 行)                                    │     │
│   └───────────────────────────────────────────────────────────┘     │
│                           │                                         │
│                           │ 按需加载                                 │
│                           ▼                                         │
│   ┌───────────────────────────────────────────────────────────┐     │
│   │                    L1: On-Demand Summaries                  │     │
│   │                    (任务相关时加载)                          │     │
│   ├───────────────────────────────────────────────────────────┤     │
│   │ standards/summaries/                                        │     │
│   │ ├── ten-step-cycle-summary.md (~3 KB)                       │     │
│   │ ├── workflow-summary.md (~4 KB)                             │     │
│   │ ├── conventions-summary.md (~2 KB)                          │     │
│   │ └── extensions-summary.md (~2 KB)                           │     │
│   │                                                              │     │
│   │ {module}/docs/ARCHITECTURE.md (~5 KB each)                  │     │
│   └───────────────────────────────────────────────────────────┘     │
│                           │                                         │
│                           │ 深入查阅                                 │
│                           ▼                                         │
│   ┌───────────────────────────────────────────────────────────┐     │
│   │                    L2: Full Reference                       │     │
│   │                    (明确请求时加载)                          │     │
│   ├───────────────────────────────────────────────────────────┤     │
│   │ standards/core/**/*.md (完整规范)                           │     │
│   │ standards/conventions/**/*.md (完整约定)                    │     │
│   │ standards/extensions/**/*.md (完整扩展)                     │     │
│   └───────────────────────────────────────────────────────────┘     │
│                                                                     │
│   Target Initial Context: ~8,000 tokens (87% reduction)            │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Key Design Decisions

### Decision 1: 移除 @ 引用自动展开

**Context**: Claude Code 的 `@` 语法会将引用文件内容完整内联到上下文中。

**Decision**: 将 `@file.md` 改为 `file.md` 纯文本路径引用。

**Rationale**:
- 避免 18+ 大型文件自动展开
- AI 仍可根据路径按需读取文件
- 保持文档可读性

**Trade-offs**:
- (+) 初始上下文减少 ~85%
- (-) AI 需要额外步骤读取详细规范
- (-) 部分任务可能需要明确指导读取哪些文件

### Decision 2: 创建 Summary 层

**Context**: 完整规范文件过大 (单文件 30+ KB)，但完全不加载又会丢失关键信息。

**Decision**: 为每个主要规范创建精简的 summary 版本。

**Summary 内容标准**:
```markdown
# {Topic} Summary

## 核心概念 (5-10 行)
## 关键规则 (10-15 行)
## 常用命令/格式 (5-10 行)
## 详细参考 (文件路径列表)
```

**Rationale**:
- 保留最常用的 20% 内容
- 覆盖 80% 日常使用场景
- 详细内容按需加载

### Decision 3: L0/L1/L2 分层策略

**Context**: 不同任务需要不同深度的上下文。

**Decision**:
| 层级 | 加载时机 | 目标大小 |
|------|---------|---------|
| L0 | 每次对话 | <5 KB |
| L1 | 任务相关 | <15 KB |
| L2 | 明确请求 | 无限制 |

**Rationale**:
- L0 确保 AI 理解项目基础
- L1 提供任务上下文
- L2 保留完整规范访问能力

---

## File Structure Changes

### New Directories

```
standards/
├── summaries/                    # NEW: Summary layer
│   ├── README.md
│   ├── ten-step-cycle-summary.md
│   ├── workflow-summary.md
│   ├── conventions-summary.md
│   └── extensions-summary.md
├── core/
│   ├── ten-step-cycle/
│   │   ├── README.md            # 保留，但精简
│   │   ├── phase-a-spec-planning.md
│   │   ├── EXAMPLES.md          # NEW: 从主文件分离的示例
│   │   └── TEMPLATES.md         # NEW: 从主文件分离的模板
│   └── workflow/
│       ├── ai-ddd-workflow-standards.md  # 精简
│       └── EXAMPLES.md          # NEW
└── archive/                     # NEW: 归档废弃内容
    └── seven-step-cycle/        # 移动旧版本
```

### CLAUDE.md Structure (精简后)

```markdown
# Todo App - AI配置

## 项目概述 (~50 words)
## 模块结构 (表格, ~20 lines)
## 关键规则 (~10 rules, inline)
## 按需加载指引 (~10 lines with paths)
## Skills 快速参考 (表格)

Total: ~150 lines, <5 KB
```

---

## Migration Strategy

### Phase 1: Non-Breaking Preparation
1. 创建 `standards/summaries/` 目录
2. 编写 summary 文件
3. 不修改现有 CLAUDE.md

### Phase 2: CLAUDE.md Refactor
1. 创建 `CLAUDE.md.backup`
2. 重写精简版 CLAUDE.md
3. 更新 @ 引用为路径引用
4. 验证 AI 功能

### Phase 3: Standards Reorganization
1. 分离示例和模板到独立文件
2. 合并重复定义
3. 归档废弃内容

### Phase 4: Validation
1. 测试常见开发任务
2. 测量 token 消耗
3. 收集反馈
4. 调整优化

---

## Risks and Mitigations

| 风险 | 可能性 | 影响 | 缓解措施 |
|------|--------|------|---------|
| AI 遗漏关键规范 | 中 | 高 | L0 保留关键规则摘要 |
| 开发者需要手动指导 AI 读取文件 | 高 | 低 | 在 L0 提供清晰的文件路径指引 |
| Summary 文件维护成本 | 中 | 中 | 考虑自动生成脚本 |
| 破坏现有工作流 | 低 | 高 | 渐进式迁移，保留 backup |

---

## Success Metrics

| 指标 | 当前 | 目标 | 验证方法 |
|------|------|------|---------|
| CLAUDE.md 大小 | 13.6 KB | <5 KB | `wc -c CLAUDE.md` |
| 初始 tokens | ~70,000 | <10,000 | Claude API 报告 |
| 常见任务成功率 | 100% | 100% | 手动测试 |
| 首次响应时间 | ~4s | <2s | 计时测量 |
