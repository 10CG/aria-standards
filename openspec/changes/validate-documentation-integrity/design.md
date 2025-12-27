# Design: Documentation Integrity Validation System

> **Change ID**: validate-documentation-integrity
> **Version**: 2.0.0
> **Created**: 2025-12-27
> **Updated**: 2025-12-27

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                    doc-integrity-validator Skill                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────────────────┐   │
│  │ Reference   │   │ Hierarchy   │   │ Semantic                │   │
│  │ Extractor   │   │ Validator   │   │ Analyzer (LLM)          │   │
│  └──────┬──────┘   └──────┬──────┘   └───────────┬─────────────┘   │
│         │                 │                      │                  │
│         └─────────────────┼──────────────────────┘                  │
│                           │                                         │
│                    ┌──────▼───────┐                                 │
│                    │ Issue        │                                 │
│                    │ Aggregator   │                                 │
│                    └──────┬───────┘                                 │
│                           │                                         │
│                    ┌──────▼───────┐                                 │
│                    │ Interactive  │                                 │
│                    │ Fixer        │                                 │
│                    └──────────────┘                                 │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                    Report Generator                                  │
│              (Markdown / Structured output)                          │
└─────────────────────────────────────────────────────────────────────┘
```

## 2. Core Concepts

### 2.1 Claude Code @ Reference Mechanism

当 Claude Code 加载 Skill/Agent 时：

```yaml
加载流程:
  1. 读取 SKILL.md 文件内容
  2. 扫描文件中的 @ 引用 (例如 @standards/conventions/git-commit.md)
  3. 将 @ 路径解析为实际文件路径
  4. 读取引用文件内容
  5. 将内容注入到运行时上下文

风险点:
  - 如果 @ 引用的文件不存在 → 静默失败或报错
  - 如果引用项目级资源 → 跨项目复用时失效
  - 如果引用内容与用途不符 → 行为异常
```

### 2.2 Architecture Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│                    架构层级定义                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  通用级 (Portable) - 可跨项目复用                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ @.claude/*     │ AI 配置、Agents、Skills、Commands  │   │
│  │ @standards/*   │ 开发规范、约定、工作流              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  项目级 (Project-specific) - 仅当前项目使用                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ @docs/*        │ 项目文档、分析报告、决策记录        │   │
│  │ @mobile/*      │ Mobile 模块文档                    │   │
│  │ @backend/*     │ Backend 模块文档                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  规则: 可移植组件 (Skills/Agents/Commands)                   │
│        只能引用通用级资源                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 3. Component Design

### 3.1 Reference Extractor

提取可移植组件中的所有 @ 引用。

**扫描目标**:

```yaml
扫描路径:
  - .claude/agents/*.md
  - .claude/skills/*/SKILL.md
  - .claude/skills/*/*.md
  - .claude/commands/*.md
```

**提取规则**:

```regex
# @ 前缀路径
@[a-zA-Z0-9_./-]+\.(md|yaml|json|mdc)

# 支持的格式示例
@standards/conventions/git-commit.md
@.claude/docs/README.md
@docs/analysis/report.md  # 项目级 - 需标记违规
```

**输出结构**:

```typescript
interface Reference {
  source: string;       // 来源文件路径
  line: number;         // 行号
  reference: string;    // @ 引用字符串
  resolvedPath: string; // 解析后的实际路径
  exists: boolean;      // 文件是否存在
  tier: 'portable' | 'project';  // 资源层级
}
```

### 3.2 Hierarchy Validator

验证 @ 引用是否符合架构层级规则。

**规则定义**:

```yaml
hierarchy_rules:
  portable_resources:
    - pattern: "^@\\.claude/.*"
    - pattern: "^@standards/.*"

  project_resources:
    - pattern: "^@docs/.*"
    - pattern: "^@mobile/.*"
    - pattern: "^@backend/.*"
    - pattern: "^@shared/.*"

  portable_components:
    - ".claude/agents/*.md"
    - ".claude/skills/**/*.md"
    - ".claude/commands/*.md"

  violation_rule: |
    portable_components 中不应引用 project_resources
```

**违规检测**:

```typescript
interface HierarchyViolation {
  component: string;      // 违规组件路径
  line: number;           // 行号
  reference: string;      // 违规引用
  severity: 'error' | 'warning';
  suggestion: string;     // 修复建议
}
```

### 3.3 Semantic Analyzer (LLM-Powered)

使用 LLM 分析引用的语义相关性。

**分析提示词模板**:

```yaml
prompt_template: |
  你是一个文档引用分析专家。请分析以下组件及其引用的相关性。

  ## 组件信息
  - 名称: {component_name}
  - 描述: {component_description}
  - 文件: {component_path}

  ## 引用列表
  {references_list}

  ## 分析任务
  1. 评估每个引用与组件用途的相关性 (高/中/低/无关)
  2. 识别可能缺失的必要引用
  3. 识别可能过时或冗余的引用
  4. 提供优化建议

  ## 输出格式
  ```yaml
  analysis:
    references:
      - path: "@standards/..."
        relevance: high|medium|low|irrelevant
        reason: "..."
    missing:
      - suggested_path: "@standards/..."
        reason: "..."
    recommendations:
      - type: remove|replace|add
        path: "..."
        reason: "..."
  ```
```

**输出结构**:

```typescript
interface SemanticAnalysis {
  component: string;
  references: ReferenceRelevance[];
  missing: MissingReference[];
  recommendations: Recommendation[];
}

interface ReferenceRelevance {
  path: string;
  relevance: 'high' | 'medium' | 'low' | 'irrelevant';
  reason: string;
}

interface MissingReference {
  suggestedPath: string;
  reason: string;
}

interface Recommendation {
  type: 'remove' | 'replace' | 'add';
  path: string;
  replacement?: string;
  reason: string;
}
```

### 3.4 Issue Aggregator

汇总所有验证结果。

**问题分类**:

```yaml
issue_categories:
  error:
    - 路径不存在
    - 层级违规 (Skills/Agents 引用 @docs/*)

  warning:
    - 引用相关性低
    - 疑似冗余引用

  suggestion:
    - 缺失建议引用
    - 引用优化建议
```

### 3.5 Interactive Fixer

交互式修复系统。

**交互流程**:

```yaml
workflow:
  1. 展示问题摘要:
     - X 个错误
     - Y 个警告
     - Z 个建议

  2. 逐项处理:
     - 展示问题详情
     - 展示修复建议
     - 用户选择: [接受] [修改] [跳过]

  3. 批量操作:
     - 接受所有同类修复
     - 跳过所有警告

  4. 执行修复:
     - 备份原文件
     - 应用修改
     - 生成变更摘要
```

## 4. Skill Interface Design

### 4.1 SKILL.md Structure

```markdown
---
name: doc-integrity-validator
description: 验证 Skills/Agents/Commands 的 @ 引用完整性和层级合规性
version: 1.0.0
author: AI Assistant
---

# Doc Integrity Validator

## 概述
验证可移植组件的运行时上下文完整性。

## 使用方式

### 完整验证
\`\`\`
/doc-integrity-validator
\`\`\`

### 仅路径验证
\`\`\`
/doc-integrity-validator --mode path-only
\`\`\`

### 包含语义分析
\`\`\`
/doc-integrity-validator --mode full
\`\`\`

## 参数

| 参数 | 说明 | 默认值 |
|-----|------|-------|
| --mode | 验证模式: path-only, hierarchy, full | hierarchy |
| --fix | 启用交互式修复 | false |
| --scope | 扫描范围: agents, skills, commands, all | all |

## 相关规范
- @standards/conventions/documentation-references.md
- @.claude/docs/SKILL_DEVELOPMENT_GUIDE.md
```

### 4.2 Configuration Schema

```yaml
# .doc-validator.yaml

# 验证范围
scope:
  agents: true
  skills: true
  commands: true

# 验证模式
mode: hierarchy  # path-only | hierarchy | full

# 层级规则
hierarchy:
  portable_prefixes:
    - "@.claude/"
    - "@standards/"
  project_prefixes:
    - "@docs/"
    - "@mobile/"
    - "@backend/"

# 忽略规则
ignore:
  paths:
    - "**/*.backup"
    - "**/archived/**"
  references:
    - "http://*"
    - "https://*"

# LLM 配置 (仅 full 模式)
llm:
  enabled: true
  model: "default"
  max_tokens: 2000
```

## 5. Output Formats

### 5.1 Validation Report (Markdown)

```markdown
# Documentation Integrity Report

> Generated: 2025-12-27 10:30:00
> Mode: hierarchy
> Scope: agents, skills, commands

## Summary

| Category | Count |
|----------|-------|
| ❌ Errors | 2 |
| ⚠️ Warnings | 3 |
| 💡 Suggestions | 5 |
| ✅ Passed | 45 |

## ❌ Errors (2)

### 1. Invalid Reference
- **Component**: `.claude/skills/arch-update/SKILL.md`
- **Line**: 45
- **Reference**: `@docs/standards/old-file.md`
- **Issue**: File not found
- **Suggestion**: Update to `@standards/conventions/new-file.md`

### 2. Hierarchy Violation
- **Component**: `.claude/agents/mobile-developer.md`
- **Line**: 23
- **Reference**: `@docs/mobile/architecture.md`
- **Issue**: Portable component references project-level resource
- **Suggestion**: Move content to `@.claude/docs/mobile-architecture.md`

## ⚠️ Warnings (3)
...

## 💡 Suggestions (5)
...

## ✅ Passed Components (45)
<details>
<summary>Click to expand</summary>

- [x] .claude/agents/tech-lead.md (5 references)
- [x] .claude/skills/commit-msg-generator/SKILL.md (3 references)
...
</details>
```

### 5.2 Structured Output (JSON)

```json
{
  "generated_at": "2025-12-27T10:30:00Z",
  "mode": "hierarchy",
  "scope": ["agents", "skills", "commands"],
  "summary": {
    "errors": 2,
    "warnings": 3,
    "suggestions": 5,
    "passed": 45
  },
  "errors": [
    {
      "type": "invalid_reference",
      "component": ".claude/skills/arch-update/SKILL.md",
      "line": 45,
      "reference": "@docs/standards/old-file.md",
      "message": "File not found",
      "suggestion": "Update to @standards/conventions/new-file.md"
    }
  ],
  "warnings": [...],
  "suggestions": [...],
  "passed": [...]
}
```

## 6. Implementation Notes

### 6.1 Path Resolution

```yaml
路径解析规则:
  "@.claude/xxx" → "{PROJECT_ROOT}/.claude/xxx"
  "@standards/xxx" → "{PROJECT_ROOT}/standards/xxx"
  "@docs/xxx" → "{PROJECT_ROOT}/docs/xxx"
  "@mobile/xxx" → "{PROJECT_ROOT}/mobile/xxx"
  "@backend/xxx" → "{PROJECT_ROOT}/backend/xxx"

跨平台处理:
  - 统一使用 "/" 作为路径分隔符
  - 自动处理 Windows "\" 转换
```

### 6.2 LLM Usage Guidelines

```yaml
LLM 使用场景:
  - 语义相关性分析
  - 缺失引用推荐
  - 优化建议生成

非 LLM 场景:
  - 路径存在性检查
  - 层级合规性验证
  - 正则匹配提取

成本控制:
  - 默认不启用 LLM (hierarchy 模式)
  - 用户显式请求时启用 (full 模式)
  - 批量处理减少调用次数
```

### 6.3 Error Handling

| 错误类型 | 处理方式 |
|---------|---------|
| 文件读取失败 | 记录警告，跳过该文件 |
| 路径解析失败 | 标记为无效引用 |
| LLM 调用失败 | 降级为 hierarchy 模式 |
| 修复冲突 | 提示用户手动处理 |

## 7. Future Enhancements

1. **依赖图谱**: 可视化组件间的引用关系
2. **增量验证**: 仅验证变更的组件
3. **自动迁移**: 自动将 @docs 引用迁移到 @standards
4. **跨项目复用检测**: 识别可提取为通用组件的项目级资源
