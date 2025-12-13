# AI 上下文加载策略

> **文档版本**: 1.0.0
> **创建日期**: 2025-12-14
> **适用范围**: 所有 AI 辅助开发场景
> **责任人**: AI Development Team

## 📋 概述

本文档定义 AI 在项目中加载上下文的标准策略，核心目标是**最小化 Token 消耗**的同时确保 AI 获得足够的项目理解。

**核心原则**: 架构文档优先，按需读取代码，最小化 Token 消耗

**相关文档**:
- **主配置** → `@CLAUDE.md`
- **工作流标准** → `@standards/core/workflow/ai-ddd-workflow-standards.md`
- **架构搜索 Skill** → `@.claude/skills/arch-search/SKILL.md`

---

## 🔄 上下文加载顺序

当 AI 需要理解项目时，**必须按以下优先级加载上下文**：

### 优先级 1 - 架构文档 (必读)

**目的**: 快速获取项目全貌和当前状态

```yaml
文档:
  - CLAUDE.md                    # AI入口配置
  - {module}/ARCHITECTURE.md     # 模块架构概览 (L0)
  - {module}/UPM文档             # 当前进度状态

预估Token: ~1000-2000
```

### 优先级 2 - 契约文档 (按需)

**目的**: 理解接口定义和数据结构

```yaml
文档:
  - shared/contracts/            # API契约
  - shared/schemas/              # 数据Schema

触发条件: 涉及跨模块接口或数据结构时
预估Token: ~500-1000
```

### 优先级 3 - 代码文件 (最后)

**目的**: 实现具体功能时才读取

```yaml
原则: 只读取与当前任务直接相关的文件
触发条件: 需要修改或理解具体实现时
预估Token: 按需（尽量最小化）
```

---

## 📐 架构文档层级 (L0/L1/L2)

### L0 - 模块概览 (必读)

```yaml
路径: {module}/ARCHITECTURE.md 或 {module}/docs/ARCHITECTURE.md
内容: 模块定位、技术栈、目录结构、核心组件
Token: ~500-1000
使用场景: 任何涉及该模块的任务
```

### L1 - 子系统详情 (按需)

```yaml
路径: {module}/docs/architecture/*.md
内容: 具体子系统的设计细节
Token: ~300-800 each
使用场景: 需要了解特定子系统时
```

### L2 - 实现细节 (仅需时)

```yaml
路径: 源代码文件
原则: 只在需要修改或理解具体实现时读取
使用场景: 功能开发、Bug修复
```

---

## 🎯 Token 优化实践

### ✅ 正确做法

```yaml
1. 架构优先:
   - 先读 ARCHITECTURE.md 了解模块结构
   - 通过架构文档定位需要修改的文件

2. 精准定位:
   - 只读取与任务直接相关的代码文件
   - 使用 UPM 了解当前开发状态

3. 搜索策略:
   - 使用 arch-search Skill 搜索架构文档
   - 避免全代码库 grep 搜索
```

### ❌ 错误做法

```yaml
1. 盲目搜索:
   - 直接 grep 整个代码库搜索关键词
   - 读取大量源代码文件来"理解项目"

2. 忽略文档:
   - 忽略架构文档直接看代码
   - 重复读取相同内容

3. 过度加载:
   - 一次性读取整个模块的所有文件
   - 读取与当前任务无关的文档
```

---

## 📊 任务类型与加载策略

| 任务类型 | 加载策略 | 预估 Token |
|----------|----------|------------|
| **了解项目** | CLAUDE.md + 各模块 ARCHITECTURE.md | ~3000 |
| **开发新功能** | UPM + 相关 L0/L1 + 目标代码文件 | ~2000-5000 |
| **修复 Bug** | UPM + 相关 L1 + 问题代码文件 | ~1000-3000 |
| **更新文档** | 目标文档 + 相关架构文档 | ~500-2000 |
| **维护架构文档** | `docs/standards/architecture-documentation-*` | ~3000-6000 |

---

## 🤖 AI 工作模式

### 搜索模式 (优先)

```yaml
触发: 需要定位功能/模块/文件时
工具: arch-search Skill
策略: 三层递进搜索
  Layer 1: 快速路由 (~200 Token) - 关键词匹配预置领域
  Layer 2: 架构搜索 (~500 Token) - Grep 架构文档
  Layer 3: 传统搜索 (Fallback) - 仅在 L1+L2 失败时使用
优势: 平均节省 70% Token
```

### 开发模式 (默认)

```yaml
触发: 功能开发、Bug 修复、代码重构
入口: CLAUDE.md → {module}/ARCHITECTURE.md → 代码
集成: 自动触发 arch-search 定位代码
跳过: docs/standards/architecture-documentation-* (管理规范)
```

### 文档维护模式

```yaml
触发: 明确要求更新/创建架构文档
入口: docs/standards/architecture-documentation-management-system.md
工具: arch-update Skill
原则: 先读管理规范，再按流程操作
```

---

## 🛠️ 相关 Skills

### arch-search

```yaml
路径: .claude/skills/arch-search/
用途: 搜索架构文档，节省 70% Token
触发: 显式（搜索/查找）+ 隐式（AI 开发时自动）
详情: @.claude/skills/arch-search/SKILL.md
```

### arch-update

```yaml
路径: .claude/skills/arch-update/
用途: 创建/更新架构文档
触发: 创建/更新架构文档请求
详情: @.claude/skills/arch-update/SKILL.md
```

### arch-common

```yaml
路径: .claude/skills/arch-common/
用途: 共享配置（L0/L1/L2定义、命名规范）
触发: 不直接触发，被其他 arch-* Skills 引用
详情: @.claude/skills/arch-common/SKILL.md
```

---

## 📈 效果指标

| 指标 | 传统方式 | 优化后 | 节省 |
|------|----------|--------|------|
| 认证功能定位 | ~3000 Token | ~500 Token | 83% |
| API端点查找 | ~4000 Token | ~300 Token | 92% |
| 数据库设计理解 | ~2500 Token | ~600 Token | 76% |
| **平均** | ~2900 Token | ~860 Token | **70%** |

---

**最后更新**: 2025-12-14
**规范版本**: 1.0.0
