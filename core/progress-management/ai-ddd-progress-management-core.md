# AI-DDD进度管理核心标准（跨模块通用）

> **文档版本**: 1.0.0-core
> **创建日期**: 2025-12-09
> **适用范围**: 所有模块（mobile/backend/frontend/shared）
> **基于规范**: mobile-ai-ddd-progress-management-system v2.3.0提取
> **架构设计**: @docs/analysis/ai-ddd-universal-progress-management-adr.md
> **责任人**: Tech Lead + AI Development Team

## 🤖 AI引用导航

**📖 本文档是跨模块通用的核心标准主文档**

### 🔍 核心标准子文档系统：

- **工作流标准** → `@docs/standards/core/ai-ddd-workflow-standards.md`
  * 七步循环详细流程（Step 1-7完整说明）
  * 开发前后检查流程
  * Subagent分配策略

- **状态管理标准** → `@docs/standards/core/ai-ddd-state-management.md`
  * UPMv2-STATE机读接口规范
  * 并发与幂等更新协议
  * UPM体量控制与滚动窗口
  * 项目周期文档组织规范

- **文档同步机制** → `@docs/standards/core/document-sync-mechanisms.md`
  * 文档同步标准机制
  * 智能任务调度
  * 智能混合策略集成
  * 偏差管理与修正

- **实施最佳实践** → `@docs/standards/core/implementation-best-practices.md`
  * AI操作最佳实践
  * 文档维护指南
  * 故障处理与应急机制
  * 质量保证检查清单

### 🔍 模块扩展标准：

- **Mobile模块** → `@docs/standards/extensions/mobile-ai-ddd-extension.md`
- **Backend模块** → `@docs/standards/extensions/backend-ai-ddd-extension.md`
- **Frontend模块** → `@docs/standards/extensions/frontend-ai-ddd-extension.md`
- **Shared模块** → `@docs/standards/extensions/shared-ai-ddd-extension.md`

### 📚 相关标准文档：

- **Git提交规范** → `@.cursor/rules/git-rule.mdc`
- **架构文档管理** → `@docs/standards/architecture-documentation-management-system.md`

---

## 📋 1. 概述与核心原则

### 1.1 规范目标

建立跨模块通用的AI-DDD进度管理框架，实现：

- **跨模块标准统一**: 所有模块使用相同的核心概念和流程
- **AI友好接口**: 标准化的机读接口和查询流程
- **灵活扩展机制**: 支持模块特定的定制和扩展
- **进度管理权威化**: 统一的进度追踪和状态同步
- **双规范协作**: 与代码生命周期管理规范的无缝集成

### 1.2 核心原则

1. **模块无关原则**: 核心概念和流程对所有模块通用
2. **AI优先原则**: 接口设计优先考虑AI理解和操作便利性
3. **文档权威原则**: 文档是项目状态的唯一权威源
4. **状态驱动原则**: 基于文档状态自动驱动开发计划
5. **扩展点原则**: 明确定义哪些部分可由模块定制

### 1.3 适用场景

**适用于**：
- ✅ 多模块协同开发项目
- ✅ AI辅助的敏捷开发流程
- ✅ 文档驱动开发（DDD）实践
- ✅ 需要精确进度追踪的项目

**不适用于**：
- ❌ 单模块小型项目（过度设计）
- ❌ 不使用AI辅助的传统开发
- ❌ 无进度管理需求的实验性项目

---

## 📊 2. 通用状态机定义

### 2.1 三层状态结构

```yaml
Phase (阶段):
  定义: 项目生命周期的主要阶段
  作用域: 项目级别
  持续时间: 数周到数月
  标准阶段:
    - Phase 1 - Planning (规划阶段)
    - Phase 2 - Design (设计阶段)
    - Phase 3 - Development (开发阶段)
    - Phase 4 - Testing (测试阶段)
    - Phase 5 - Deployment (部署阶段)

Cycle (周期):
  定义: 阶段内的迭代周期
  作用域: 阶段级别
  持续时间: 1-2周
  编号方式: 连续数字 (Cycle 1, Cycle 2, ...)
  特点: 每个Cycle包含完整的开发-测试-验证循环

Stage (状态):
  定义: 周期内的开发状态
  作用域: 任务级别
  持续时间: 数小时到数天
  标准状态:
    - planning: 任务规划和准备
    - development: 功能开发和实现
    - testing: 单元测试和集成测试
    - review: 代码审查和质量检查
    - completed: 任务完成
    - blocked: 任务阻塞
```

### 2.2 状态转换规则

```yaml
标准转换流程:
  planning → development → testing → review → completed

状态转换约束:
  1. 必须按顺序转换，不允许跳跃
  2. 只有review阶段可以回退到development（修复问题）
  3. completed是终态，不可逆转
  4. 每次转换必须更新UPM文档和stateToken

特殊转换规则:
  review → development:
    触发条件: 代码审查发现问题
    操作要求: 记录回退原因，更新任务状态

  任意阶段 → blocked:
    触发条件: 遇到阻塞问题无法继续
    操作要求: 记录阻塞原因，标记依赖任务
```

### 2.3 扩展点：模块特定阶段

模块可以在标准阶段基础上定义更细粒度的子阶段。

**扩展机制**：
- 在标准Stage之间插入模块特定Stage
- 细化development阶段的子阶段
- 在模块扩展标准中定义

**示例**：
- Mobile扩展：增加 `ui-review`, `device-testing` 阶段
- Backend扩展：增加 `api-contract-design`, `database-migration` 阶段

详见各模块扩展标准文档。

---

## 🔄 3. 七步循环开发模型（概要）

**完整详细流程** → `@docs/standards/core/ai-ddd-workflow-standards.md`

### 3.1 七步流程概览

```yaml
Step 1: 项目状态感知
  目标: AI获取当前项目状态和任务上下文
  输出: 当前Phase/Cycle/Stage, 活跃任务, 项目上下文

Step 2: 任务规划
  目标: 基于当前状态分解和规划开发任务
  输出: 任务列表（优先级排序）, 依赖关系图, 执行计划

Step 3: Subagent分配
  目标: 将任务分配给最合适的AI Subagent
  输出: 任务与Subagent的映射关系

Step 4: 执行验证
  目标: 确保代码质量和功能正确性
  输出: 验证报告（通过/失败）, 质量指标

Step 5: 架构同步
  目标: 保持架构文档与代码实现同步
  输出: 更新后的架构文档, ADR记录

Step 6: Git提交
  目标: 创建规范的、可追溯的Git提交记录
  输出: 符合规范的提交记录

Step 7: 进度更新
  目标: 同步项目进度和状态信息
  输出: 更新后的UPM文档, KPI仪表板
```

### 3.2 通用Subagent能力映射（概要）

```yaml
7个核心Subagent:
  - knowledge-manager: 文档创建、架构维护
  - backend-architect: 后端API、数据库设计
  - mobile-developer: 移动端UI/UX、架构
  - frontend-developer: 前端组件、Web UI
  - qa-engineer: 测试编写、质量验证
  - api-documenter: API文档、OpenAPI规范
  - tech-lead: 架构决策、跨模块协调
```

详细能力定义和分配策略见工作流标准文档。

### 3.3 Git提交消息格式

```
type(scope): 中文描述 / English description

详细说明主要变更内容。

- 变更点1
- 变更点2
- 变更点3

🤖 Executed-By: {subagent_type} subagent
📋 Context: Phase{N}-Cycle{M} {feature-context}
🔗 Module: {mobile|backend|frontend|shared}
🔗 Related: #{task-id}

Refs: #issue-number
```

**提交类型**：`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

---

## 🔌 4. 扩展点定义

### 4.1 扩展点总览

模块扩展标准必须定义的6个扩展点：

```yaml
1. Module-Specific Stages:
   - 定义模块特定的开发阶段细分
   - 基于通用Stage扩展

2. Module-Specific Quality Metrics:
   - 定义模块特定的质量指标
   - 包含数值目标和检查方法

3. Module-Specific Tech Validation:
   - 定义模块特定的技术验证命令
   - 在Step 4: 执行验证中调用

4. Module-Specific Doc Structure:
   - 定义模块特定的文档组织方式
   - 在Step 5: 架构同步中使用

5. Module-Specific Subagent Mapping:
   - 定义或覆盖Subagent分配规则
   - 在Step 3: Subagent分配中应用

6. Module-Specific Progress Metrics:
   - 定义模块特定的进度计算方式
   - 在Step 7: 进度更新中使用
```

### 4.2 扩展点实现指南

**创建模块扩展标准文档**：

```yaml
文件位置: docs/standards/extensions/{module}-ai-ddd-extension.md

必需章节:
  1. 基础信息:
     - 基于哪个核心标准版本
     - 模块标识符
     - 版本号和维护者

  2. 模块特定开发阶段:
     - 定义Phase/Cycle结构
     - 细化development阶段的子阶段

  3. 模块质量指标:
     - 测试覆盖率目标
     - 性能指标
     - 代码质量标准

  4. 模块技术验证命令:
     - 静态检查命令
     - 测试执行命令
     - 构建验证命令

  5. 模块文档结构:
     - 架构文档路径规范
     - 必需的架构文档列表

  6. Subagent映射配置 (可选):
     - 模块特定优先级配置
```

**示例模板**：

```markdown
# {Module} AI-DDD进度管理扩展

> **基于**: ai-ddd-progress-management-core.md v1.0.0
> **模块**: {module}
> **版本**: 1.0.0-{module}-extension

## 1. {Module}特定开发阶段
## 2. {Module}质量指标
## 3. {Module}技术验证命令
## 4. {Module}文档结构
## 5. {Module} Subagent映射配置
## 6. {Module}进度指标
```

---

## 📚 5. 与其他规范的协作

### 5.1 双规范协作体系

```yaml
AI-DDD进度管理核心标准 (本文档):
  核心职责: "开发什么、何时开发、开发到什么程度"
  管理层级: 项目协调层
  管理范围:
    - 项目进度追踪
    - 任务状态管理
    - AI-DDD工作流
    - 文档驱动开发

代码生命周期管理规范:
  核心职责: "如何开发"
  管理层级: 技术执行保障层
  管理范围:
    - 代码质量标准
    - 分支策略
    - 测试流程
    - CI/CD流程

协作接口:
  - 本规范调用代码管理规范的技术验证流程 (Step 4)
  - 代码管理规范的测试结果反馈给本规范 (Step 7)
  - 通过标准化接口实现无缝协作
```

### 5.2 与Git规范协作

本标准生成的提交消息必须遵循项目的Git提交规范：
- 参考: `@.cursor/rules/git-rule.mdc`
- 格式: Conventional Commits + 双语描述
- 增强: 添加Subagent、Context、Module标记

### 5.3 与架构文档管理体系协作

本标准在Step 5中维护的架构文档必须遵循：
- 参考: `@docs/standards/architecture-documentation-management-system.md`
- v4.5架构文档管理系统
- 三层架构体系（L0/L1/L2）

---

## ✅ 6. 质量保证

### 6.1 核心标准遵循检查清单

```yaml
开发前:
  □ 已读取模块UPM文档
  □ 已识别当前Phase/Cycle/Stage
  □ 已检查前置任务完成状态
  □ 已确认文档偏差在可接受范围
  □ 已执行模块特定的技术准备检查

开发中:
  □ 任务分解符合4-8小时粒度
  □ Subagent分配基于标准映射规则
  □ 代码变更通过模块特定的技术验证
  □ 架构变更已同步到架构文档

开发后:
  □ Git提交消息遵循统一格式
  □ 增强标记完整（Agent/Context/Module/Related）
  □ UPM文档已更新（lastUpdateAt/stateToken）
  □ KPI仪表板已同步
  □ 跨模块依赖已通知
```

### 6.2 模块扩展标准质量检查

```yaml
模块扩展标准必须包含:
  □ 明确的基于关系（基于core v{X.Y.Z}）
  □ 完整的模块特定开发阶段定义
  □ 可量化的质量指标和目标值
  □ 可执行的技术验证命令
  □ 清晰的文档结构规范

模块扩展标准禁止:
  ✗ 重新定义核心概念（Phase/Cycle/Stage）
  ✗ 违反核心标准的约束和规则
  ✗ 引入与核心标准冲突的流程
```

**详细质量保证实践** → `@docs/standards/core/implementation-best-practices.md`

---

## 🔄 7. 版本管理

### 7.1 语义化版本

本标准采用语义化版本号：`MAJOR.MINOR.PATCH-core`

- **MAJOR**: 不兼容的API变更
- **MINOR**: 向后兼容的功能新增
- **PATCH**: 向后兼容的问题修复

### 7.2 兼容性策略

```yaml
向后兼容承诺:
  - MINOR和PATCH版本保证向后兼容
  - 模块扩展标准只需在MAJOR版本升级时更新
  - 扩展点定义在MAJOR版本内保持稳定

升级指导:
  - 核心标准升级时提供迁移指南
  - 提供自动化工具辅助升级（如适用）
  - 保留至少一个MAJOR版本的兼容期
```

---

## 📞 8. 支持与反馈

### 8.1 问题报告

**遇到问题时**：
1. 检查模块扩展标准是否正确实现扩展点
2. 查看 [ADR文档](../../analysis/ai-ddd-universal-progress-management-adr.md) 了解设计决策
3. 提交Issue到项目仓库，标签：`standards/core`

### 8.2 改进建议

**如何贡献**：
1. 创建Issue描述改进建议
2. 说明改进的动机和价值
3. 如果涉及不兼容变更，说明影响范围
4. 参与讨论和设计

### 8.3 维护责任

```yaml
核心标准维护:
  责任人: Tech Lead
  评审周期: 每季度
  更新触发条件:
    - 发现设计缺陷
    - 新的通用需求
    - 重大架构升级

模块扩展维护:
  责任人: 各模块负责人
  评审周期: 按需
  更新触发条件:
    - 模块技术栈变更
    - 质量指标调整
    - 工作流程优化
```

---

## 📝 9. 附录

### 9.1 术语表

| 术语 | 定义 | 示例 |
|------|------|------|
| Phase | 项目生命周期的主要阶段 | Phase 3 - Development |
| Cycle | 阶段内的迭代周期 | Cycle 9 |
| Stage | 周期内的开发状态 | planning, development, testing |
| UPMv2-STATE | 统一进度管理机读接口 | YAML frontmatter片段 |
| Extension | 模块特定的扩展标准 | mobile-ai-ddd-extension.md |
| Subagent | 执行特定任务的AI代理 | backend-architect, qa-engineer |
| 扩展点 | 允许模块定制的标准化接口 | Module-Specific Tech Validation |

### 9.2 快速参考

**AI查询当前状态** (3步)：
```bash
Step 1: 识别模块 (mobile/backend/frontend/shared)
Step 2: 读取模块UPM (unified-progress-management.md)
Step 3: 解析UPMv2-STATE片段
```

详细查询流程 → `@docs/standards/core/ai-ddd-workflow-standards.md`

**创建新模块扩展标准**：
```bash
1. 复制模板: docs/standards/extensions/template-extension.md
2. 定义6个扩展点（见4.1节）
3. 提供可执行的验证命令
4. 提交代码审查
```

**升级核心标准**：
```bash
1. 阅读 ADR文档了解架构设计
2. 提交Issue说明升级理由
3. 评估对现有模块扩展的影响
4. 提供迁移指南
5. 更新版本号（遵循语义化版本）
```

### 9.3 变更历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 1.0.0-core | 2025-12-09 | 初始版本，从mobile v2.3.0提取通用内容，建立子文档系统 |

---

**文档维护者**: Tech Lead + AI Development Team
**最后更新**: 2025-12-09
**适用模块**: Mobile, Backend, Frontend, Shared
**继承关系**: mobile-ai-ddd-progress-management-system v2.3.0 → core v1.0.0
**文档体系**: 主文档 + 4个核心子文档
