---
created_at: '2025-11-02'
updated_at: '2025-11-02'
classification: 开发规范
subcategory: 工作流程
status: active
version: 1.0.0
document_type: 引用文档
priority_level: S级
---

# OpenSpec 试点指南（引用）

> **注意**: 这是一个引用文档，完整内容请查看主仓库中的指南文档。

---

## 📄 完整文档位置

**[OpenSpec 试点集成指南](../../docs/analysis/openspec-pilot-guide.md)**

该文档已移动到主仓库的 `docs/analysis/` 目录，原因：
- 这是项目级战略决策文档，不仅限于 standards 子模块
- 与 [规范系统对比分析](../../docs/analysis/spec-system-comparison-analysis.md) 形成完整的决策链
- 便于所有子模块（standards、shared、mobile、backend）的开发者访问

---

## 📋 文档包含内容

完整的 OpenSpec 试点集成指南包括：

### 1. 核心概念梳理
- AI-DDD、OpenSpec、Standards 三者的本质关系
- 层次图解释（方法论 → 框架 → 实例）
- Standards 子模块的准确定位
- 融合后的完整架构

### 2. 工作目录管理
- OpenSpec CLI 的目录依赖要求
- 子模块场景下的实际影响
- 三种解决方案（规范、脚本、AGENTS.md）
- 实际影响评估

### 3. 与 Subagents 的兼容性
- `.claude/agents/` 与 `openspec/AGENTS.md` 的关系
- 分层互补的协作模式
- 实际协作示例
- OpenSpec AGENTS.md 示例模板

### 4. 试点行动方案
- 试点目标和范围定义
- 6 步详细执行步骤
- 具体示例（Git Commit Convention）
- 评估清单和决策点

### 5. 评估标准
- 量化指标（AI 生成准确率、人工修正比例等）
- 定性评估（清晰度、可维护性、可扩展性、AI 友好性）
- 决策矩阵

### 6. 快速参考
- 常用命令速查
- 关键文件位置

---

## 🔗 相关文档链接

### 分析决策文档
- **[规范系统对比分析](../../docs/analysis/spec-system-comparison-analysis.md)**
  对比 AI-DDD、Spec-Kit、OpenSpec 三个系统，解释为什么选择 OpenSpec

- **[OpenSpec 试点集成指南](../../docs/analysis/openspec-pilot-guide.md)**
  回答四个核心问题，提供完整的试点行动方案

### Standards 工作流文档
- **[子模块开发路线图](./submodule-development-roadmap.md)**
  定义 standards、shared、backend、mobile 的开发优先级和执行计划
  - 包含"风险控制与回退机制"章节

---

## 🚀 快速开始

如果你准备开始 OpenSpec 试点：

1. **阅读完整指南**：
   ```bash
   # 从主仓库根目录
   cat docs/analysis/openspec-pilot-guide.md
   ```

2. **查看开发路线图**：
   ```bash
   # 从 standards 子模块
   cat workflow/submodule-development-roadmap.md
   ```

3. **开始试点**（按照指南中的步骤）：
   ```bash
   cd standards
   git checkout -b experiment/openspec
   mkdir -p openspec/{specs,changes}
   # ... 继续按照指南执行
   ```

---

## ❓ 为什么这样组织

**设计理念**：文档分类原则

```
docs/analysis/              # 项目级分析和决策文档
├── 受众：全项目团队
├── 性质：战略指导
└── 示例：OpenSpec 试点指南、系统对比分析

standards/workflow/         # Standards 执行流程文档
├── 受众：Standards 开发者
├── 性质：操作指南
└── 示例：开发路线图、本引用文档
```

这样组织的好处：
- ✅ 文档归属更准确
- ✅ 访问更便利（主仓库直接可见）
- ✅ 形成逻辑连贯的决策链
- ✅ 同时保持 standards 工作流的完整性（通过引用）

---

**最后更新**: 2025-11-02
**维护者**: 技术团队
**版本**: v1.0.0
