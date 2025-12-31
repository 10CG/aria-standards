# Design: Architecture Documentation Separation

> **Change ID**: architecture-docs-separation
> **Version**: 1.0.0
> **Created**: 2025-12-27

## 1. Content Classification Matrix

### 1.1 主文档拆分 (architecture-documentation-management-system.md)

| 章节 | 内容 | 分类 | 目标位置 |
|------|------|------|---------|
| AI快速索引格式 | 元数据格式定义 | 通用 | ai-integration-guide.md |
| 核心价值 | 文档体系价值描述 | 通用 | README.md |
| 核心子文档导航 | 子文档列表 | 项目 | architecture-project-config.md |
| AI快速决策矩阵 | 场景-行动映射 | 通用 | ai-integration-guide.md |
| AI执行规范要求 | AI操作原则 | 通用 | ai-integration-guide.md |
| 系统架构-重要概念区分 | 规范/实例/文档概念 | 通用 | README.md |
| 系统架构-项目端划分 | mobile/backend/frontend | 项目 | architecture-project-config.md |
| 核心原则 | 简洁/时间/避免重复 | 通用 | README.md |
| 文档标准 v4.5格式 | 模板格式 | 通用 | document-templates.md |
| 验证体系 | 三级验证架构 | 通用 | validation-levels.md |
| 决策流程 | 是否需要文档 | 通用 | layering-system.md |
| 工具集成 | 核心脚本 | 项目 | architecture-project-tools.md |
| CI/CD集成 | 配置示例 | 项目 | architecture-project-tools.md |
| 性能指标 | 当前项目指标 | 项目 | architecture-project-config.md |
| AI使用指导 | 执行原则 | 通用 | ai-integration-guide.md |
| 文档治理 | 生命周期管理 | 通用 | lifecycle-management.md |
| 快速开始 | 操作步骤 | 混合 | 拆分到各文档 |
| 版本演进 | 规范版本历史 | 通用 | README.md |

### 1.2 子文档拆分矩阵

| 子文档 | 通用内容 | 项目内容 | 通用目标 | 项目目标 |
|--------|---------|---------|---------|---------|
| **index** | 索引格式规范、层级定义 | 端索引路径、具体端划分 | layering-system.md | project-config.md |
| **templates** | 模板格式、必备章节 | 项目模板示例 | document-templates.md | project-examples.md |
| **operations** | 操作流程、判断标准 | 脚本命令、具体路径 | layering-system.md | project-tools.md |
| **validation** | 验证级别、检查项 | 验证脚本、项目标准 | validation-levels.md | project-tools.md |
| **tools** | 工具概念、接口定义 | 脚本实现、路径配置 | validation-levels.md | project-tools.md |
| **version-control** | 版本格式、时间格式 | 项目版本策略 | naming-conventions.md | project-config.md |
| **examples** | 通用示例模式 | 项目具体示例 | document-templates.md | project-examples.md |
| **quick-ref** | 通用速查表 | 项目速查 | README.md | project-config.md |

---

## 2. Target File Structure

### 2.1 @standards/core/architecture/ (通用规范)

```
standards/core/architecture/
├── README.md                    # 入口、导航、核心原则
│   ├── Overview
│   ├── Quick Reference
│   ├── Document Index
│   └── Version History
│
├── layering-system.md           # L0/L1/L2 层级体系
│   ├── Layer Definitions
│   ├── Threshold Rules
│   ├── Decision Flowchart
│   ├── File Counting Rules
│   └── Cross-Layer References
│
├── document-templates.md        # 文档模板规范
│   ├── Template Format Standard
│   ├── L0 Index Template
│   ├── L1 Component Template
│   ├── L2 Sub-Component Template
│   ├── Metadata Standards
│   └── Best Practices
│
├── validation-levels.md         # 三级验证体系
│   ├── Three-Level System
│   ├── Level 1: Format (Auto)
│   ├── Level 2: Content (Semi-Auto)
│   ├── Level 3: Quality (Manual)
│   ├── Validation Workflow
│   └── Report Format
│
├── naming-conventions.md        # 命名规范 (新增)
│   ├── Directory Naming
│   │   ├── Code Directories
│   │   └── Documentation Directories
│   ├── File Naming
│   │   ├── Architecture Documents
│   │   ├── Index Documents
│   │   └── Tree Documents
│   ├── Version Format
│   └── Timestamp Format
│
├── lifecycle-management.md      # 生命周期管理 (新增)
│   ├── Document Lifecycle
│   │   ├── Creation Triggers
│   │   ├── Update Triggers
│   │   ├── Deprecation Process
│   │   └── Archival Process
│   ├── Responsibility Matrix
│   ├── Quality Assurance
│   └── Rollback Mechanism
│
└── ai-integration-guide.md      # AI 集成指南 (新增)
    ├── AI Quick Index Format
    ├── AI Execution Principles
    ├── Decision Matrix Template
    ├── Query Strategies
    └── Conflict Resolution
```

### 2.2 docs/project-standards/ (项目配置)

```
docs/project-standards/
├── architecture-project-config.md    # 项目配置主文档
│   ├── Project Overview
│   ├── Module Boundaries
│   │   ├── Mobile (mobile/)
│   │   ├── Backend (backend/)
│   │   └── Frontend (frontend/)
│   ├── Index Locations
│   ├── Performance Metrics
│   └── Version Strategy
│
├── architecture-project-tools.md     # 项目工具配置
│   ├── Script Inventory
│   │   ├── arch_tree_generate.py
│   │   ├── arch_check.sh
│   │   └── Other scripts
│   ├── Usage Examples
│   ├── CI/CD Integration
│   └── Troubleshooting
│
├── architecture-project-examples.md  # 项目示例
│   ├── Mobile Module Example
│   ├── Backend Module Example
│   ├── Document Creation Example
│   └── Update Workflow Example
│
└── archived/                         # 归档原文档
    ├── architecture-documentation-management-system.md
    ├── architecture-doc-index.md
    ├── architecture-doc-templates.md
    ├── architecture-doc-operations.md
    ├── architecture-doc-validation.md
    ├── architecture-doc-tools.md
    ├── architecture-doc-version-control.md
    ├── architecture-doc-examples.md
    └── architecture-doc-quick-ref.md
```

---

## 3. Reference Architecture

### 3.1 引用关系图

```
┌─────────────────────────────────────────────────────────────────┐
│                @standards/core/architecture/                     │
│                                                                 │
│  README.md ◄─────────────────────────────────────────────────┐  │
│      │                                                       │  │
│      ├──► layering-system.md                                 │  │
│      ├──► document-templates.md                              │  │
│      ├──► validation-levels.md                               │  │
│      ├──► naming-conventions.md                              │  │
│      ├──► lifecycle-management.md                            │  │
│      └──► ai-integration-guide.md                            │  │
│                                                               │  │
└───────────────────────────┬───────────────────────────────────┘  │
                            │                                      │
                            ▼ @standards 引用                      │
┌───────────────────────────────────────────────────────────────┐  │
│            @.claude/skills/arch-common/SKILL.md               │  │
│                                                               │  │
│  方法论基础: @standards/core/architecture/                     │  │
│  项目配置: 内置 (mobile/backend/frontend 路径)                 │  │
│                                                               │  │
└───────────────────────────┬───────────────────────────────────┘  │
                            │                                      │
                            ▼ arch-common 引用                     │
┌───────────────────────────────────────────────────────────────┐  │
│                arch-search, arch-update                        │  │
└───────────────────────────────────────────────────────────────┘  │
                                                                   │
┌───────────────────────────────────────────────────────────────┐  │
│            docs/project-standards/                             │  │
│                                                               │  │
│  architecture-project-config.md ──► @standards (引用通用规范) ──┘  │
│  architecture-project-tools.md                                │
│  architecture-project-examples.md                             │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

### 3.2 引用规则

| 引用方向 | 允许 | 禁止 |
|---------|------|------|
| @standards → @standards | ✅ 内部引用 | - |
| @.claude → @standards | ✅ 引用通用规范 | - |
| @.claude → @docs | ❌ | 违反层级 |
| @docs → @standards | ✅ 引用通用规范 | - |
| @docs → @.claude | ❌ | 避免循环 |

---

## 4. Migration Strategy

### 4.1 迁移顺序

```
Phase 1: 分析 (不修改文件)
    ↓
Phase 2: 完善 @standards (只添加，不删除)
    ↓
Phase 3: 创建新 @docs (只添加，不删除)
    ↓
Phase 4: 更新引用 (修改引用)
    ↓
Phase 5: 验证 + 归档原文档
```

### 4.2 回滚策略

```yaml
回滚点:
  - Phase 2 完成后: 可删除新增的 @standards 文件
  - Phase 3 完成后: 可删除新增的 @docs 文件
  - Phase 4 完成后: 需恢复引用 (git checkout)
  - Phase 5 完成后: 从 archived/ 恢复原文档
```

---

## 5. Validation Checklist

### 5.1 @standards 文档检查

- [ ] 每个文档独立可用，无项目特定内容
- [ ] 无硬编码的项目路径 (mobile/, backend/, scripts/)
- [ ] 使用占位符或模板变量
- [ ] 有清晰的使用说明

### 5.2 @docs 文档检查

- [ ] 只包含项目特定配置
- [ ] 正确引用 @standards 通用规范
- [ ] 脚本路径正确
- [ ] 示例与项目实际一致

### 5.3 引用完整性检查

- [ ] 运行 `/validate-docs --mode hierarchy`
- [ ] 所有 @standards 引用存在
- [ ] 无 @docs 被 Skills 直接引用
- [ ] arch-common 引用正确
