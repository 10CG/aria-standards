# OpenSpec Changes (Deprecated)

> ⚠️ **此目录已废弃**

## 新的正确结构

从 v2.0 开始，所有项目（包括 Aria 自身）应在自己的 `openspec/changes/` 目录中创建变更：

```
your-project/
├── standards/          → aria-standards 子模块
├── openspec/           ← 您的 OpenSpec 变更在这里
│   ├── changes/        ← 活跃的变更
│   │   └── {feature}/
│   │       ├── proposal.md
│   │       └── tasks.md
│   └── specs/          (或使用 openspec spec init 创建)
└── docs/
```

## 为什么废弃?

aria-standards 是一个**共享子模块**，Git 子模块的特性导致在其中创建的变更会被追踪到 aria-standards 仓库，这违背了"项目变更属于项目自身"的原则。

## 迁移指南

如果您有变更在此目录：

1. 在您的项目根目录创建 `openspec/changes/`
2. 移动您的变更目录到新位置
3. 删除此目录中的旧副本

## 示例

- **Aria 项目**: `Aria/openspec/changes/aria-workflow-enhancement/`
- **用户项目**: `your-project/openspec/changes/your-feature/`

---

**参考**: `../examples/user-projects/` 包含其他项目的变更示例。
