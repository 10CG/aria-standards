---
created_at: 2025-07-01
updated_at: 2025-07-01 07:03
---

# RACI职责分工标准

> **文档类型**: 标准规范
> **重要级别**: A级
> **创建时间**: 2025-01-24
> **最后更新**: 2025-01-24
> **RACI职责分工**:
> - **R (负责编写)**: knowledge-manager
> - **A (承担责任)**: knowledge-manager
> - **C (需要咨询)**: tech-lead, product-manager
> - **I (需要知情)**: all-team-members

## 概述

本文档定义了Todo应用项目中各类文档的RACI职责分工标准，确保每个文档都有明确的角色职责边界，避免协作冲突，提升工作效率。

## RACI模型定义

### 角色职责类型

- **R (Responsible)** - 负责编写：实际执行文档编写工作的角色
- **A (Accountable)** - 承担责任：对文档质量承担最终责任的角色
- **C (Consulted)** - 需要咨询：在文档创建过程中需要提供专业意见的角色
- **I (Informed)** - 需要知情：需要了解文档内容但不参与创建的角色

### 核心原则

1. **唯一决策权**：每个文档只能有一个A角色，确保决策权明确
2. **职责清晰**：每个角色都明确知道自己在每个文档中的职责
3. **协作有序**：通过C角色建立正当的咨询和建议渠道
4. **信息透明**：通过I角色确保相关人员及时知情

## 项目角色定义

### 核心角色

- **product-manager**: 产品经理，负责产品规划和需求管理
- **tech-lead**: 技术负责人，负责技术架构和团队协调
- **solution-architect**: 解决方案架构师，负责系统架构设计
- **backend-developer**: 后端开发者，负责后端功能实现
- **frontend-developer**: 前端开发者，负责前端功能实现
- **mobile-developer**: 移动端开发者，负责移动应用开发
- **qa-engineer**: 测试工程师，负责质量保证和测试
- **devops-engineer**: 运维工程师，负责部署和运维
- **ux-designer**: 用户体验设计师，负责用户界面和体验设计
- **knowledge-manager**: 知识管理专家，负责文档架构和知识管理

### 特殊角色组

- **all-development-team**: 包含所有开发角色的组合
- **all-stakeholders**: 包含所有项目相关人员
- **core-team**: 核心团队成员（product-manager, tech-lead, solution-architect）

## 文档类型RACI矩阵

### 1. 需求与产品文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 产品需求文档 | product-manager | product-manager | tech-lead, ux-designer | all-development-team |
| 用户故事 | product-manager | product-manager | ux-designer | development-team |
| 产品规划 | product-manager | product-manager | tech-lead | all-stakeholders |
| 用户研究报告 | ux-designer | product-manager | product-manager | core-team |

### 2. 架构与设计文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 系统架构文档 | solution-architect | solution-architect | tech-lead | all-development-team |
| 技术选型文档 | solution-architect | tech-lead | backend-developer, frontend-developer | all-development-team |
| 数据库设计 | solution-architect | tech-lead | backend-developer | frontend-developer, mobile-developer |
| API架构设计 | solution-architect | tech-lead | backend-developer | frontend-developer, mobile-developer |

### 3. 契约文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| API契约 | tech-lead | tech-lead | backend-developer, frontend-developer | qa-engineer |
| UI契约 | frontend-developer | tech-lead | ux-designer, mobile-developer | backend-developer |
| 数据契约 | backend-developer | tech-lead | solution-architect | frontend-developer, mobile-developer |
| 移动端契约 | mobile-developer | tech-lead | ux-designer | backend-developer, frontend-developer |

### 4. 实现文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 后端开发文档 | backend-developer | backend-developer | tech-lead | frontend-developer, qa-engineer |
| 前端开发文档 | frontend-developer | frontend-developer | tech-lead, ux-designer | backend-developer, qa-engineer |
| 移动端开发文档 | mobile-developer | mobile-developer | tech-lead, ux-designer | backend-developer, qa-engineer |
| 代码规范 | tech-lead | tech-lead | all-development-team | qa-engineer |

### 5. 测试文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 测试计划 | qa-engineer | qa-engineer | tech-lead | all-development-team |
| 测试用例 | qa-engineer | qa-engineer | relevant-developer | tech-lead |
| 测试报告 | qa-engineer | qa-engineer | tech-lead | product-manager, all-development-team |
| 性能测试报告 | qa-engineer | qa-engineer | devops-engineer | tech-lead, product-manager |

### 6. 部署运维文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 部署手册 | devops-engineer | devops-engineer | tech-lead | all-development-team |
| 运维手册 | devops-engineer | devops-engineer | tech-lead | product-manager |
| 监控配置 | devops-engineer | devops-engineer | backend-developer | tech-lead |
| 安全配置 | devops-engineer | tech-lead | solution-architect | all-development-team |

### 7. 用户文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 用户手册 | product-manager | product-manager | ux-designer | tech-lead |
| API文档 | backend-developer | tech-lead | product-manager | frontend-developer, mobile-developer |
| 安装指南 | devops-engineer | product-manager | tech-lead | all-users |
| FAQ文档 | product-manager | product-manager | qa-engineer | all-stakeholders |

### 8. 管理文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 项目计划 | tech-lead | product-manager | core-team | all-development-team |
| 进度报告 | tech-lead | product-manager | team-leads | all-stakeholders |
| 风险评估 | tech-lead | product-manager | solution-architect | core-team |
| 会议记录 | meeting-organizer | meeting-organizer | attendees | relevant-stakeholders |

### 9. 质量保障文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 文档标准 | knowledge-manager | knowledge-manager | tech-lead, product-manager | all-team-members |
| 质量检查清单 | knowledge-manager | knowledge-manager | qa-engineer | all-team-members |
| 最佳实践 | knowledge-manager | knowledge-manager | experienced-team-members | all-team-members |
| 知识库维护 | knowledge-manager | knowledge-manager | all-contributors | all-team-members |

### 10. 安全文档

| 文档类型 | R | A | C | I |
|----------|---|---|---|---|
| 安全策略 | security-specialist | tech-lead | solution-architect | all-development-team |
| 安全评估报告 | security-specialist | tech-lead | qa-engineer | product-manager |
| 数据保护规范 | security-specialist | tech-lead | backend-developer | all-development-team |
| 访问控制规范 | security-specialist | tech-lead | devops-engineer | all-development-team |

## 特殊情况处理

### 角色缺失处理

当指定角色不存在时的替代方案：

| 缺失角色 | 替代角色 | 替代条件 |
|----------|----------|----------|
| solution-architect | tech-lead | 小型项目或早期阶段 |
| security-specialist | tech-lead + devops-engineer | 安全要求不高的项目 |
| ux-designer | product-manager | UI/UX要求简单的项目 |
| mobile-developer | frontend-developer | 使用跨平台框架时 |

### 冲突解决机制

1. **职责边界冲突**
   - 优先级：A > R > C > I
   - 协调者：knowledge-manager
   - 解决时限：2小时内

2. **多角色竞争**
   - 按照专业领域划分职责
   - 由A角色做最终决策
   - 记录决策原因

3. **角色能力不匹配**
   - 临时授权机制
   - 能力培训计划
   - 外部专家支持

## 实施指南

### 新文档创建流程

1. **确定文档类型** - 根据内容确定文档分类
2. **查询RACI矩阵** - 找到对应的角色分工
3. **标注RACI信息** - 在文档头部明确标注
4. **通知相关角色** - 告知C和I角色文档创建
5. **按流程执行** - 严格按照RACI流程执行

### 现有文档更新流程

1. **批量扫描** - 识别缺少RACI信息的文档
2. **分类整理** - 按文档类型分组处理
3. **添加RACI** - 根据标准矩阵添加职责信息
4. **验证确认** - 与相关角色确认职责分工
5. **更新完成** - 记录更新历史

### 质量监控机制

- **覆盖率监控**：确保所有文档都有RACI信息
- **一致性检查**：定期检查RACI分工的一致性
- **效果评估**：收集角色协作效果反馈
- **持续优化**：基于实践经验优化RACI矩阵

## 工具支持

### 自动化工具

- **RACI检查脚本**：自动检查文档RACI信息完整性
- **角色通知系统**：自动通知相关角色文档变更
- **协作状态追踪**：跟踪多角色协作的进展状态
- **冲突预警系统**：提前识别可能的角色冲突

### 模板集成

- **文档模板更新**：所有模板都包含RACI字段
- **自动填充**：基于文档类型自动建议RACI分工
- **一致性验证**：确保实际分工与标准矩阵一致
- **历史记录**：完整记录RACI变更历史

## 成功指标

### 量化指标

- **RACI覆盖率**：≥95%的文档包含RACI信息
- **冲突解决时间**：平均≤2小时
- **协作满意度**：≥85%的团队成员满意
- **文档质量评分**：平均≥90分

### 定性指标

- 角色边界清晰明确
- 协作流程顺畅高效
- 决策权威性得到保证
- 团队协作氛围良好

## 变更历史

| 版本 | 日期 | 变更内容 | 变更人 |
|------|------|----------|--------|
| 1.0.0 | 2025-01-24 | 初始版本，建立完整的RACI职责分工标准 | knowledge-manager |

## 相关文档

- [AI-DDD + PromptX开发指南](ai-ddd-promptx-guide.md)
- [文档标准规范](project-doc-rule.mdc)
- [角色协作流程](../maintained/project/planning/pr-dev-plan.md)
- [质量保证体系](../maintained/testing/strategies/test-plan-strategy.md) 