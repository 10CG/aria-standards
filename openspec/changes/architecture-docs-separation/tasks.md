# Tasks: Architecture Documentation Separation

> **Change ID**: architecture-docs-separation
> **Status**: Completed
> **Last Updated**: 2025-12-28

## Phase 1: 内容分析与规划

- [x] 1.1 分析主文档内容
  - 读取 `architecture-documentation-management-system.md`
  - 标注每个章节：通用 / 项目
  - 生成拆分清单

- [x] 1.2 分析8个子文档内容
  - architecture-doc-index.md
  - architecture-doc-templates.md
  - architecture-doc-operations.md
  - architecture-doc-validation.md
  - architecture-doc-tools.md
  - architecture-doc-version-control.md
  - architecture-doc-examples.md
  - architecture-doc-quick-ref.md

- [x] 1.3 生成详细拆分计划
  - 每个文档的拆分表
  - 新文档结构设计
  - 引用关系图

## Phase 2: @standards 通用规范完善

- [x] 2.1 完善 layering-system.md
  - 补充从原文档提取的详细内容
  - 确保独立可用

- [x] 2.2 完善 document-templates.md
  - 整合 architecture-doc-templates.md 的通用模板
  - 移除项目特定示例

- [x] 2.3 完善 validation-levels.md
  - 整合 architecture-doc-validation.md 的通用验证概念
  - 移除项目脚本路径

- [x] 2.4 创建 naming-conventions.md
  - 从主文档提取命名规范
  - 代码目录 vs docs 目录命名
  - 文件命名规则

- [x] 2.5 创建 lifecycle-management.md
  - 文档生命周期（创建/更新/废弃/归档）
  - 触发条件
  - 责任划分

- [x] 2.6 创建 ai-integration-guide.md
  - AI 快速索引格式
  - AI 执行规范
  - AI 决策矩阵通用版

- [x] 2.7 更新 README.md
  - 更新文档导航
  - 添加使用指南

## Phase 3: @docs 项目配置重构

- [x] 3.1 分析项目配置需求
  - 发现 CI/CD 未使用架构脚本
  - 脚本自带 config.yaml 配置
  - arch-common 已有项目配置

- [x] 3.2 决定精简方案
  - 删除冗余的项目配置文档
  - 保持单一信息源原则

- [x] 3.3 归档原文档
  - 添加废弃标记和迁移指南到原主文档
  - 保留原文档供参考

## Phase 4: 引用更新

- [x] 4.1 更新 arch-common/SKILL.md
  - 确认引用正确指向 @standards
  - 添加对新项目配置文档的引用

- [x] 4.2 更新项目文档引用
  - 新 @docs 文档引用 @standards 通用规范
  - 确保引用链完整

- [x] 4.3 更新 arch-update/SKILL.md
  - 更新规范文档引用
  - 指向新的项目配置文档

## Phase 5: 验证与清理

- [x] 5.1 验证文件结构
  - @standards/core/architecture/ 包含 7 个文档
  - 项目配置使用 arch-common + scripts/config.yaml

- [x] 5.2 验证引用链
  - Skills 正确引用 @standards
  - 删除冗余项目文档，避免多处维护

- [x] 5.3 更新版本和状态
  - arch-common 更新到 1.2.0
  - arch-update 更新到 2.3.0
  - 原主文档标记为已迁移

- [x] 5.4 精简优化 (追加)
  - 删除 architecture-project-config.md (与 arch-common 重复)
  - 删除 architecture-project-tools.md (脚本自带 config.yaml)
  - 删除 architecture-project-examples.md (实际代码即示例)
  - 更新相关引用

---

## 验收标准

| 阶段 | 验收标准 |
|------|---------|
| Phase 1 | 拆分计划完整，每个内容块有明确归属 |
| Phase 2 | @standards 文档独立可用，无项目特定内容 |
| Phase 3 | @docs 只包含项目配置，引用 @standards |
| Phase 4 | 所有引用正确，无断链 |
| Phase 5 | 验证通过，Skills 功能正常 |

## 依赖项

- doc-integrity-validator Skill (已创建)
- arch-common/SKILL.md (已更新)
- @standards/core/architecture/ (已创建基础文档)

## 复杂度评估

| 阶段 | 复杂度 | 工作量 |
|------|--------|--------|
| Phase 1 | 中 | 分析9个文档 |
| Phase 2 | 高 | 完善/创建7个通用文档 |
| Phase 3 | 中 | 创建3个项目文档 |
| Phase 4 | 低 | 更新引用 |
| Phase 5 | 低 | 验证测试 |

## 预计产出

```
standards/core/architecture/     (7个文档)
├── README.md
├── layering-system.md          (完善)
├── document-templates.md       (完善)
├── validation-levels.md        (完善)
├── naming-conventions.md       (新增)
├── lifecycle-management.md     (新增)
└── ai-integration-guide.md     (新增)

docs/project-standards/         (3个文档 + archived/)
├── architecture-project-config.md   (新增)
├── architecture-project-tools.md    (新增)
├── architecture-project-examples.md (新增)
└── archived/                        (原9个文档)
```
