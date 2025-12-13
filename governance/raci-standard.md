# RACI 职责分工标准

> **Version**: 1.0.0
> **Status**: Active
> **Purpose**: 定义项目文档和任务的职责分工标准，确保协作清晰有序

---

## 1. 概述

RACI 模型是一种职责分配矩阵，用于明确项目中各角色的职责边界，避免协作冲突，提升工作效率。

---

## 2. RACI 模型定义

### 2.1 角色职责类型

| 角色 | 英文 | 说明 | 数量限制 |
|------|------|------|----------|
| **R** | Responsible | 负责执行：实际执行工作的角色 | 可多人 |
| **A** | Accountable | 承担责任：对结果承担最终责任的角色 | **唯一** |
| **C** | Consulted | 需要咨询：提供专业意见的角色 | 可多人 |
| **I** | Informed | 需要知情：需了解结果但不参与的角色 | 可多人 |

### 2.2 核心原则

```yaml
五大原则:
  1. 唯一决策权: 每项工作只能有一个 A 角色
  2. 职责清晰: 每个角色明确知道自己的职责
  3. 协作有序: 通过 C 角色建立正当的咨询渠道
  4. 信息透明: 通过 I 角色确保相关人员及时知情
  5. 无遗漏: 每项工作至少有 R 和 A
```

---

## 3. 标准角色定义

### 3.1 核心角色

| 角色ID | 角色名称 | 职责描述 |
|--------|----------|----------|
| `product-manager` | 产品经理 | 产品规划、需求管理、用户研究 |
| `tech-lead` | 技术负责人 | 技术架构、团队协调、技术决策 |
| `solution-architect` | 解决方案架构师 | 系统架构设计、技术选型 |
| `backend-developer` | 后端开发者 | 后端功能实现、API开发 |
| `frontend-developer` | 前端开发者 | 前端功能实现、UI开发 |
| `mobile-developer` | 移动端开发者 | 移动应用开发 |
| `qa-engineer` | 测试工程师 | 质量保证、测试执行 |
| `devops-engineer` | 运维工程师 | 部署运维、基础设施 |
| `ux-designer` | 用户体验设计师 | 用户界面、交互设计 |
| `knowledge-manager` | 知识管理专家 | 文档架构、知识管理 |

### 3.2 角色组

```yaml
角色组定义:
  all-development-team:
    - backend-developer
    - frontend-developer
    - mobile-developer

  all-stakeholders:
    - product-manager
    - tech-lead
    - all-development-team
    - qa-engineer

  core-team:
    - product-manager
    - tech-lead
    - solution-architect
```

---

## 4. 文档类型 RACI 矩阵

### 4.1 需求与产品文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 产品需求文档 | product-manager | product-manager | tech-lead, ux-designer | all-development-team |
| 用户故事 | product-manager | product-manager | ux-designer | development-team |
| 产品规划 | product-manager | product-manager | tech-lead | all-stakeholders |
| 用户研究报告 | ux-designer | product-manager | product-manager | core-team |

### 4.2 架构与设计文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 系统架构文档 | solution-architect | solution-architect | tech-lead | all-development-team |
| 技术选型文档 | solution-architect | tech-lead | backend-developer, frontend-developer | all-development-team |
| 数据库设计 | solution-architect | tech-lead | backend-developer | frontend-developer, mobile-developer |
| API架构设计 | solution-architect | tech-lead | backend-developer | frontend-developer, mobile-developer |

### 4.3 契约文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| API契约 | tech-lead | tech-lead | backend-developer, frontend-developer | qa-engineer |
| UI契约 | frontend-developer | tech-lead | ux-designer, mobile-developer | backend-developer |
| 数据契约 | backend-developer | tech-lead | solution-architect | frontend-developer, mobile-developer |

### 4.4 实现文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 后端开发文档 | backend-developer | backend-developer | tech-lead | frontend-developer, qa-engineer |
| 前端开发文档 | frontend-developer | frontend-developer | tech-lead, ux-designer | backend-developer, qa-engineer |
| 移动端开发文档 | mobile-developer | mobile-developer | tech-lead, ux-designer | backend-developer, qa-engineer |
| 代码规范 | tech-lead | tech-lead | all-development-team | qa-engineer |

### 4.5 测试文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 测试计划 | qa-engineer | qa-engineer | tech-lead | all-development-team |
| 测试用例 | qa-engineer | qa-engineer | relevant-developer | tech-lead |
| 测试报告 | qa-engineer | qa-engineer | tech-lead | product-manager, all-development-team |
| 性能测试报告 | qa-engineer | qa-engineer | devops-engineer | tech-lead, product-manager |

### 4.6 部署运维文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 部署手册 | devops-engineer | devops-engineer | tech-lead | all-development-team |
| 运维手册 | devops-engineer | devops-engineer | tech-lead | product-manager |
| 监控配置 | devops-engineer | devops-engineer | backend-developer | tech-lead |
| 安全配置 | devops-engineer | tech-lead | solution-architect | all-development-team |

### 4.7 管理文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 项目计划 | tech-lead | product-manager | core-team | all-development-team |
| 进度报告 | tech-lead | product-manager | team-leads | all-stakeholders |
| 风险评估 | tech-lead | product-manager | solution-architect | core-team |
| 会议记录 | meeting-organizer | meeting-organizer | attendees | relevant-stakeholders |

### 4.8 质量保障文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 文档标准 | knowledge-manager | knowledge-manager | tech-lead, product-manager | all-team-members |
| 质量检查清单 | knowledge-manager | knowledge-manager | qa-engineer | all-team-members |
| 最佳实践 | knowledge-manager | knowledge-manager | experienced-members | all-team-members |

---

## 5. 文档 RACI 标识

### 5.1 标识格式

在文档头部添加 RACI 信息：

```markdown
> **RACI职责分工**:
> - **R (负责编写)**: backend-developer
> - **A (承担责任)**: tech-lead
> - **C (需要咨询)**: solution-architect
> - **I (需要知情)**: frontend-developer, qa-engineer
```

### 5.2 YAML Frontmatter

```yaml
---
title: API设计文档
raci:
  responsible: backend-developer
  accountable: tech-lead
  consulted:
    - solution-architect
  informed:
    - frontend-developer
    - qa-engineer
---
```

---

## 6. 特殊情况处理

### 6.1 角色缺失替代方案

| 缺失角色 | 替代角色 | 适用条件 |
|----------|----------|----------|
| solution-architect | tech-lead | 小型项目或早期阶段 |
| security-specialist | tech-lead + devops-engineer | 安全要求不高的项目 |
| ux-designer | product-manager | UI/UX要求简单的项目 |
| mobile-developer | frontend-developer | 使用跨平台框架时 |
| knowledge-manager | tech-lead | 小团队 |

### 6.2 冲突解决机制

```yaml
职责边界冲突:
  优先级: A > R > C > I
  协调者: knowledge-manager 或 tech-lead
  解决时限: 2小时内

多角色竞争:
  处理方式:
    - 按专业领域划分职责
    - 由 A 角色做最终决策
    - 记录决策原因

角色能力不匹配:
  处理方式:
    - 临时授权机制
    - 能力培训计划
    - 外部专家支持
```

---

## 7. 实施指南

### 7.1 新文档创建流程

```yaml
Step 1 - 确定文档类型:
  - 根据内容确定文档分类

Step 2 - 查询RACI矩阵:
  - 找到对应的角色分工

Step 3 - 标注RACI信息:
  - 在文档头部明确标注

Step 4 - 通知相关角色:
  - 告知 C 和 I 角色

Step 5 - 按流程执行:
  - 严格按照 RACI 流程执行
```

### 7.2 现有文档更新流程

```yaml
Step 1 - 批量扫描:
  - 识别缺少 RACI 信息的文档

Step 2 - 分类整理:
  - 按文档类型分组处理

Step 3 - 添加RACI:
  - 根据标准矩阵添加职责信息

Step 4 - 验证确认:
  - 与相关角色确认职责分工

Step 5 - 更新完成:
  - 记录更新历史
```

---

## 8. 质量监控

### 8.1 量化指标

| 指标 | 目标 | 说明 |
|------|------|------|
| RACI覆盖率 | ≥95% | 包含RACI信息的文档比例 |
| 冲突解决时间 | ≤2小时 | 职责冲突的平均解决时间 |
| 协作满意度 | ≥85% | 团队成员对协作的满意度 |
| 文档质量评分 | ≥90分 | 文档质量综合评分 |

### 8.2 定性指标

```yaml
评估维度:
  - 角色边界是否清晰明确
  - 协作流程是否顺畅高效
  - 决策权威性是否得到保证
  - 团队协作氛围是否良好
```

---

## 9. 快速参考

### 9.1 RACI 角色速查

```
R (Responsible) - 谁来做？
A (Accountable) - 谁负责？（唯一）
C (Consulted)   - 咨询谁？
I (Informed)    - 通知谁？
```

### 9.2 常用文档 RACI 速查

| 文档 | R | A |
|------|---|---|
| 需求文档 | PM | PM |
| 架构文档 | Architect | Tech Lead |
| API文档 | Backend Dev | Tech Lead |
| 测试计划 | QA | QA |
| 部署文档 | DevOps | DevOps |

### 9.3 检查清单

创建文档前：
- [ ] 确定文档类型
- [ ] 查询 RACI 矩阵
- [ ] 标注 RACI 信息
- [ ] 通知相关角色

---

## 相关文档

- [文档分类规范](../conventions/document-classification.md)
- [命名规范](../conventions/naming-conventions.md)
- [契约驱动开发](../methodology/contract-driven-development.md)

---

**Version**: 1.0.0
**Created**: 2025-12-14
**Maintainer**: AI-DDD Development Team
