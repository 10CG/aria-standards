# AI-DDD工作流标准

> **文档版本**: 1.0.0-workflow
> **创建日期**: 2025-12-09
> **基于**: ai-ddd-progress-management-core.md v1.0.0
> **适用范围**: 所有模块（mobile/backend/frontend/shared）
> **责任人**: Tech Lead + AI Development Team

## 📋 概述

本文档详细定义AI-DDD七步循环开发模型的完整流程，包括每步的详细操作、输入输出、标准流程和最佳实践。

**相关文档**：
- **主标准** → `@docs/standards/core/ai-ddd-progress-management-core.md`
- **状态管理** → `@docs/standards/core/ai-ddd-state-management.md`
- **文档同步** → `@docs/standards/core/document-sync-mechanisms.md`

---

## 🔄 七步循环详细流程

### Step 1: 项目状态感知

**目标**: AI获取当前项目状态和任务上下文

#### 1.1 标准流程

```yaml
第一步：识别工作模块
  操作:
    - 检查当前工作目录路径
    - 分析git变更范围（git diff --name-only）
    - 确定涉及的模块标识

  输出:
    - 主要模块: mobile/backend/frontend/shared
    - 次要模块: 如有跨模块变更

第二步：读取模块UPM文档
  路径模式:
    - 标准路径: {module}/project-planning/unified-progress-management.md
    - 备选路径: {module}/[docs/]project-planning/unified-progress-management.md

  读取优先级:
    1. UPMv2-STATE机读片段（YAML frontmatter，必读）
    2. 当前项目状态章节
    3. 活跃任务列表
    4. KPI仪表板
    5. 风险与问题

  读取策略:
    - 优先读取顶部UPMv2-STATE（200行以内）
    - 快速定位关键章节
    - 避免全文读取（使用滚动窗口策略）

第三步：解析状态信息
  从UPMv2-STATE提取:
    - module: string（模块标识）
    - stage: "Phase {N} - {Stage Name}"
    - cycleNumber: integer（循环编号）
    - lastUpdateAt: ISO 8601时间戳
    - lastUpdateRef: 最后更新引用
    - stateToken: 状态哈希值
    - nextCycle: 候选任务集
    - kpiSnapshot: KPI快照
    - risks: 风险列表
    - pointers: 文档指针

  状态解析:
    - 解析Phase编号和名称
    - 解析Cycle编号
    - 识别当前Stage
    - 解析活跃任务ID列表

第四步：检查前置条件
  前置任务检查:
    - 查询任务依赖关系
    - 确认前置任务状态（已完成/验证中/阻塞）
    - 评估是否可以开始当前任务

  依赖模块检查:
    - 识别跨模块依赖
    - 读取依赖模块的UPM状态
    - 确认依赖接口是否就绪

  文档偏差检查:
    - 检查lastUpdateAt时间（建议<48小时）
    - 检查是否存在偏差标识
    - 评估文档准确性
```

#### 1.2 输出

```yaml
状态感知输出:
  当前状态:
    module: "mobile"
    phase: 3
    phaseName: "Development"
    cycle: 7
    stage: "development"

  活跃任务:
    - id: "mobile-B6-2#task-analytics-chart"
      status: "in_progress"
      priority: "P1"
    - id: "mobile-B7#ai-offline-online-switch"
      status: "pending"
      priority: "P1"

  项目上下文:
    lastUpdate: "2025-12-09T15:00:00+08:00"
    kpi:
      coverage: "87.2%"
      build: "green"
    risks:
      - level: "P0"
        description: "内存溢出问题"

  决策建议:
    canProceed: true
    blockers: []
    warnings:
      - "测试覆盖率需关注"
```

---

### Step 2: 任务规划

**目标**: 基于当前状态分解和规划开发任务

#### 2.1 任务分解标准

```yaml
分解原则:
  时间粒度: 4-8小时内可完成
  复杂度: 单一职责，便于验证
  可测试性: 必须有明确的验证标准

分解方法:
  功能维度:
    - 按用户故事分解
    - 按技术组件分解
    - 按接口边界分解

  技术维度:
    - UI层 → UI组件开发
    - 逻辑层 → 业务逻辑实现
    - 数据层 → 数据模型和持久化
    - 测试层 → 单元测试和集成测试

  验证维度:
    - 每个子任务有独立的验证标准
    - 验证标准可量化
    - 验证可自动化

分解示例:
  原始需求: "实现用户登录功能"

  分解后:
    - Task 1: 设计登录UI组件 (4h)
      验证: UI符合设计稿，响应式布局正常

    - Task 2: 实现登录API调用 (3h)
      验证: API调用成功，错误处理完整

    - Task 3: 实现Token管理 (3h)
      验证: Token存储、刷新、过期处理正常

    - Task 4: 添加登录测试 (4h)
      验证: 单元测试和Widget测试通过，覆盖率≥85%
```

#### 2.2 优先级评估

```yaml
优先级定义:
  P0 (Critical):
    定义: 阻塞其他任务，必须立即完成
    示例:
      - 解决阻塞性Bug
      - 完成前置依赖任务
      - 修复构建失败
    时限: 立即处理（当日完成）

  P1 (High):
    定义: 当前Cycle的核心任务
    示例:
      - Cycle计划内的主要功能
      - 关键路径上的任务
      - 里程碑依赖任务
    时限: Cycle内完成（1-2周）

  P2 (Medium):
    定义: 重要但不紧急的任务
    示例:
      - 性能优化
      - 代码重构
      - 技术债务偿还
    时限: Phase内完成（4-8周）

  P3 (Low):
    定义: 优化和改进类任务
    示例:
      - 文档完善
      - 代码注释
      - 工具脚本优化
    时限: 按需安排

优先级评估因子:
  依赖关系权重 (40%):
    - 被依赖任务数量
    - 在关键路径位置
    - 阻塞风险评估

  业务价值权重 (30%):
    - 对用户的价值
    - 对业务目标的贡献
    - ROI评估

  时间紧迫性权重 (30%):
    - 距离里程碑时间
    - 预计完成时间
    - 缓冲时间余量
```

#### 2.3 依赖分析

```yaml
依赖类型:
  串行依赖:
    定义: Task B必须等Task A完成后才能开始
    示例:
      - API设计 → API实现
      - 数据模型 → 数据访问层
      - UI组件 → 页面集成
    处理: 按依赖顺序排序任务

  并行依赖:
    定义: Task A和Task B可以同时进行
    示例:
      - UI开发 || 后端API开发（使用Mock）
      - 不同模块的独立功能
      - 不同子系统的开发
    处理: 分配给不同Subagent并行执行

  外部依赖:
    定义: 依赖其他模块或第三方服务
    示例:
      - 等待Backend API完成
      - 等待设计资源交付
      - 等待第三方SDK更新
    处理: 标记依赖，设置检查点，使用Mock解耦

依赖关系图:
  格式: 有向无环图（DAG）
  节点: 任务ID
  边: 依赖关系（A → B表示A完成后才能开始B）

  示例:
    API设计 → API实现 → API测试
                ↘          ↗
                  API文档
```

#### 2.4 资源分配与候选集获取

```yaml
候选任务获取策略:
  优先级1 - 从UPM的nextCycle.candidates读取:
    优势: 轻量级索引，快速定位
    来源: UPMv2-STATE中的nextCycle字段
    示例:
      nextCycle:
        candidates:
          - id: "mobile-B6-2#task-analytics-chart"
            rationale: "高优先级数据可视化功能"
          - id: "mobile-B7#ai-offline-online-switch"
            rationale: "关键AI功能切换"

  优先级2 - 按需扫描任务文档:
    触发条件: nextCycle.candidates为空或不完整
    来源: @detailed-development-tasks.md或类似任务文档
    策略:
      - 使用pointers.tasks快速定位任务文档
      - 基于过滤条件扫描（状态=pending, 优先级≥P1）
      - 避免全量扫描

  优先级3 - 动态生成候选:
    触发条件: 无预定义候选任务
    方法: 基于当前状态和项目目标推断下一步任务

资源评估:
  任务复杂度评估:
    简单 (S): 1-2小时，单文件修改
    中等 (M): 3-5小时，多文件修改
    复杂 (L): 6-8小时，跨模块或架构变更
    超大 (XL): >8小时，需要拆分

  所需时间估算:
    基于历史数据: 参考类似任务的实际耗时
    考虑风险因素: 不确定性、技术难度
    留有缓冲余量: 估算值 × 1.2-1.5

  Subagent分配预判:
    - 识别任务所需的专业技能
    - 匹配合适的Subagent类型
    - 考虑Subagent当前负载
```

#### 2.5 输出

```yaml
任务规划输出:
  任务列表:
    - id: "mobile-B6-2#task-analytics-chart"
      title: "实现分析图表组件"
      priority: "P1"
      complexity: "M"
      estimatedHours: 5
      dependencies: ["mobile-B5#data-service"]
      assignedSubagent: "mobile-developer"

    - id: "mobile-B7#ai-offline-online-switch"
      title: "AI离线/在线切换"
      priority: "P1"
      complexity: "L"
      estimatedHours: 7
      dependencies: []
      assignedSubagent: "mobile-developer"

  依赖关系图:
    mobile-B5 → mobile-B6-2 → mobile-B6-3
                      ↓
                  mobile-B7

  执行计划:
    Phase: "并行执行mobile-B6-2和mobile-B7"
    顺序: "mobile-B6-2优先（有依赖方）"
    预计完成: "Cycle 7内完成"
```

---

### Step 3: Subagent分配

**目标**: 将任务分配给最合适的AI Subagent

#### 3.1 通用Subagent能力映射

```yaml
knowledge-manager:
  核心能力:
    - 文档创建和组织
    - 架构文档维护
    - 规范标准编写
    - 知识库管理

  适用文件类型:
    - docs/**/*.md
    - **/ARCHITECTURE.md
    - **/README.md
    - *.md（项目级文档）

  适用任务场景:
    - 创建项目文档
    - 更新架构文档
    - 编写规范标准
    - 文档重构和优化

  能力评级:
    文档写作: ⭐⭐⭐⭐⭐
    架构理解: ⭐⭐⭐⭐
    技术深度: ⭐⭐⭐

backend-architect:
  核心能力:
    - 后端API设计
    - 数据库设计
    - 服务架构设计
    - 微服务设计

  适用文件类型:
    - backend/**/*.py
    - backend/**/*.java
    - backend/**/*.go
    - backend/**/*.js
    - docs/api/**/*.yaml

  适用任务场景:
    - API端点设计和实现
    - 数据库schema设计
    - 服务层架构
    - API文档编写

  能力评级:
    API设计: ⭐⭐⭐⭐⭐
    数据库设计: ⭐⭐⭐⭐⭐
    性能优化: ⭐⭐⭐⭐

mobile-developer:
  核心能力:
    - 移动端UI/UX实现
    - Flutter/Dart开发
    - 状态管理
    - 移动端架构

  适用文件类型:
    - mobile/**/*.dart
    - mobile/**/*.swift
    - mobile/**/*.kotlin
    - mobile/lib/**/*

  适用任务场景:
    - UI组件开发
    - 页面实现
    - 状态管理实现
    - 移动端性能优化

  能力评级:
    UI开发: ⭐⭐⭐⭐⭐
    Flutter框架: ⭐⭐⭐⭐⭐
    性能优化: ⭐⭐⭐⭐

frontend-developer:
  核心能力:
    - 前端组件开发
    - Web UI实现
    - 前端架构
    - 用户体验优化

  适用文件类型:
    - frontend/**/*.{js,ts,jsx,tsx}
    - frontend/**/*.vue
    - frontend/**/*.css
    - frontend/src/**/*

  适用任务场景:
    - React/Vue组件开发
    - Web页面实现
    - 前端状态管理
    - 前端性能优化

  能力评级:
    Web开发: ⭐⭐⭐⭐⭐
    前端框架: ⭐⭐⭐⭐⭐
    用户体验: ⭐⭐⭐⭐

qa-engineer:
  核心能力:
    - 测试用例编写
    - 质量验证
    - Bug修复
    - 测试策略设计

  适用文件类型:
    - **/test/**/*
    - **/tests/**/*
    - **/*.test.*
    - **/*.spec.*

  适用任务场景:
    - 编写单元测试
    - 编写集成测试
    - 测试覆盖率提升
    - 质量问题分析

  能力评级:
    测试设计: ⭐⭐⭐⭐⭐
    质量分析: ⭐⭐⭐⭐⭐
    自动化测试: ⭐⭐⭐⭐

api-documenter:
  核心能力:
    - API文档编写
    - OpenAPI规范
    - SDK文档
    - 接口说明

  适用文件类型:
    - docs/api/**/*.yaml
    - docs/api/**/*.json
    - docs/contracts/**/*.md
    - **/openapi.yaml

  适用任务场景:
    - 编写OpenAPI规范
    - 生成API文档
    - 更新接口说明
    - SDK文档维护

  能力评级:
    API文档: ⭐⭐⭐⭐⭐
    OpenAPI: ⭐⭐⭐⭐⭐
    技术写作: ⭐⭐⭐⭐

tech-lead:
  核心能力:
    - 架构决策
    - 技术规划
    - 跨模块协调
    - 战略性提交规划

  适用场景:
    - 重大技术决策
    - 跨模块变更协调
    - 架构重构规划
    - 技术债务管理

  能力评级:
    架构设计: ⭐⭐⭐⭐⭐
    技术决策: ⭐⭐⭐⭐⭐
    团队协调: ⭐⭐⭐⭐⭐
```

#### 3.2 分配策略

```yaml
基于文件类型的自动匹配:
  规则:
    - 匹配文件扩展名和路径模式
    - 多个Subagent匹配时选择优先级最高的
    - 考虑模块特定的优先级配置

  示例:
    文件: mobile/lib/widgets/chart_widget.dart
    匹配: mobile-developer（最高优先级）

    文件: docs/api/user-api.yaml
    匹配: api-documenter（最高优先级）

基于任务复杂度的匹配:
  规则:
    - 简单任务: 优先general-purpose
    - 复杂任务: 优先专业Subagent
    - 跨模块任务: 优先tech-lead协调

  示例:
    任务: 修改配置文件
    复杂度: 简单
    分配: general-purpose

    任务: 重构状态管理架构
    复杂度: 复杂
    分配: mobile-developer或tech-lead

模块特定优先级覆盖:
  机制: 模块扩展标准可以覆盖默认优先级

  示例（Mobile模块）:
    mobile-developer: 最高优先级
    qa-engineer: 高优先级
    ui-ux-designer: 中优先级

  应用: 当多个Subagent都匹配时，使用模块特定优先级

并行执行支持:
  规则:
    - 独立任务分配给不同Subagent
    - 允许并行执行无依赖任务
    - 避免资源冲突

  示例:
    Task A (UI): mobile-developer
    Task B (测试): qa-engineer
    → 可以并行执行
```

#### 3.3 输出

```yaml
Subagent分配结果:
  - taskId: "mobile-B6-2#task-analytics-chart"
    assignedSubagent: "mobile-developer"
    rationale: "Flutter Widget开发，匹配mobile-developer核心能力"
    priority: "highest"
    canParallel: true

  - taskId: "mobile-B7#ai-offline-online-switch"
    assignedSubagent: "mobile-developer"
    rationale: "移动端状态管理，mobile-developer专长"
    priority: "highest"
    canParallel: true

  - taskId: "mobile-test-coverage-improvement"
    assignedSubagent: "qa-engineer"
    rationale: "测试覆盖率提升，qa-engineer专长"
    priority: "high"
    canParallel: true
```

---

### Step 4: 执行验证

**目标**: 确保代码质量和功能正确性

详细验证命令和质量门禁由各模块扩展标准定义。本节定义通用验证框架。

#### 4.1 通用验证流程

```yaml
验证层次:
  Level 1 - 静态检查:
    - 代码格式检查
    - Lint规则验证
    - 类型检查（如适用）
    命令示例（模块特定）:
      - mobile: flutter analyze
      - backend: mypy app/ && flake8
      - frontend: eslint src/

  Level 2 - 单元测试:
    - 运行相关单元测试
    - 确保测试覆盖率达标
    - 验证新增测试通过
    命令示例（模块特定）:
      - mobile: flutter test [相关测试]
      - backend: pytest tests/unit/
      - frontend: jest --coverage

  Level 3 - 集成测试:
    - 运行相关集成测试
    - 验证模块间接口正确性
    命令示例（模块特定）:
      - mobile: flutter test integration_test/
      - backend: pytest tests/integration/
      - frontend: cypress run

  Level 4 - 构建验证:
    - 确保项目可构建
    - 验证无编译错误
    命令示例（模块特定）:
      - mobile: flutter build apk --debug
      - backend: python -m build
      - frontend: npm run build

验证顺序:
  1. 静态检查（快速失败）
  2. 单元测试（核心验证）
  3. 集成测试（接口验证）
  4. 构建验证（最终确认）
```

#### 4.2 错误处理

```yaml
验证失败处理:
  Level 1 - 阻塞性错误（立即终止）:
    触发条件:
      - 编译错误
      - Fatal级别的静态检查错误
      - 核心测试崩溃

    处理流程:
      1. 立即终止验证流程
      2. 记录详细错误信息
      3. 任务状态回退到development
      4. 通知相关人员
      5. 不允许提交代码

    示例:
      flutter analyze → 1 fatal error
      → 立即终止，不允许继续

  Level 2 - 警告级别（允许继续但需修复）:
    触发条件:
      - Warning级别的静态检查
      - 测试覆盖率不达标
      - 性能指标未达标

    处理流程:
      1. 记录警告信息
      2. 标记任务为"需改进"
      3. 允许继续但限制合并到主分支
      4. 创建技术债务任务

    示例:
      测试覆盖率 80% < 目标 85%
      → 允许提交，但创建改进任务

  Level 3 - 建议级别（不阻塞）:
    触发条件:
      - Info级别的静态检查
      - 代码优化建议
      - 性能优化建议

    处理流程:
      1. 记录建议信息
      2. 不影响任务状态
      3. 可选择性采纳

    示例:
      flutter analyze → 3 hints
      → 记录但不阻塞
```

**模块特定验证详细定义** → 各模块扩展标准文档

---

### Step 5: 架构同步

**目标**: 保持架构文档与代码实现同步

#### 5.1 架构变更识别

```yaml
触发条件:
  结构性变更:
    - 新增模块或组件
    - 删除模块或组件
    - 重命名或重组模块

  接口变更:
    - 修改模块公共接口
    - 变更模块间通信协议
    - 更新API契约

  技术栈变更:
    - 引入新的依赖库
    - 升级主要依赖版本
    - 替换技术方案

  设计决策变更:
    - 架构模式调整
    - 设计原则变更
    - 技术选型调整

自动检测:
  基于git diff:
    - 检测新增/删除的目录
    - 检测package/dependency变更
    - 检测配置文件变更

  基于代码分析:
    - 检测public API变更
    - 检测模块导入关系变更
    - 检测架构层级变更
```

#### 5.2 更新架构文档

```yaml
文档位置模式（模块特定）:
  L0端级架构:
    - {module}/ARCHITECTURE.md
    - 描述模块整体架构

  L1模块架构:
    - {module}/{component}/ARCHITECTURE.md
    - 描述组件详细架构

  设计文档:
    - docs/architecture/{module}-{topic}.md
    - 描述特定主题的设计

更新内容:
  架构图更新:
    - 组件关系图
    - 数据流图
    - 部署架构图

  文档说明更新:
    - 组件职责描述
    - 接口规范说明
    - 技术选型说明

  代码示例更新:
    - 更新示例代码
    - 更新使用说明
    - 更新最佳实践
```

#### 5.3 记录设计决策（ADR）

```yaml
ADR创建时机:
  - 重大技术选型
  - 架构模式调整
  - 重要权衡决策
  - 问题解决方案

ADR格式:
  标题: ADR-{编号}: {简要标题}

  状态: [提议中|已接受|已弃用|已替代]

  上下文:
    - 当前面临的问题
    - 相关背景信息
    - 约束条件

  决策:
    - 选择的方案
    - 决策理由

  后果:
    - 正面影响
    - 负面影响
    - 风险分析

  替代方案:
    - 方案A及其优缺点
    - 方案B及其优缺点

  参考:
    - 相关资料链接

ADR存放位置:
  - {module}/docs/architecture/design-decisions/
  - 文件名: ADR-{编号}-{简要标题}.md
```

---

### Step 6: Git提交

**目标**: 创建规范的、可追溯的Git提交记录

详细提交规范见主标准文档第3.3节。

#### 6.1 分组提交策略

```yaml
按职责分组:
  原则: 相关变更一起提交
  示例:
    - 提交1: feat(mobile): 实现图表组件UI
    - 提交2: test(mobile): 添加图表组件测试
    - 提交3: docs(mobile): 更新图表组件文档

按依赖分组:
  原则: 有依赖关系的串行提交
  示例:
    - 提交1: refactor(mobile): 重构数据模型
    - 提交2: feat(mobile): 基于新模型实现功能
    - 提交3: test(mobile): 更新相关测试

按模块分组:
  原则: 不同模块分开提交
  示例:
    - 提交1: feat(mobile): 移动端功能
    - 提交2: feat(backend): 后端API
    - 提交3: docs(shared): 共享文档
```

---

### Step 7: 进度更新

**目标**: 同步项目进度和状态信息

详细状态管理机制见状态管理标准文档。

#### 7.1 标准更新流程

```yaml
第一步：更新UPM文档
  必须更新字段:
    - lastUpdateAt: 当前时间戳（ISO 8601格式）
    - lastUpdateRef: "git:{commit-hash}-{brief-description}"
    - stateToken: 重新计算SHA256哈希值

  可能更新字段:
    - stage: 如果Phase/Cycle转换
    - cycleNumber: 如果Cycle递增
    - activeTasks: 任务状态变更
    - kpiSnapshot: KPI指标更新
    - risks: 风险状态变更

第二步：同步项目仪表板
  更新KPI指标:
    - 计算完成百分比
    - 更新测试覆盖率
    - 更新质量指标
    - 更新性能指标

  更新进度百分比:
    已完成任务 / 总任务数 × 100%

  更新里程碑状态:
    - 检查里程碑完成条件
    - 标记已达成的里程碑
    - 更新下一个里程碑

第三步：触发后续任务
  检查依赖任务:
    - 查询依赖当前任务的后续任务
    - 更新后续任务状态为可执行（pending）
    - 更新nextCycle候选任务集

  通知相关方:
    - 团队成员（如有）
    - 依赖模块负责人（如跨模块）
    - 项目管理工具（如有集成）

第四步：跨模块同步（如适用）
  触发条件:
    - 当前任务影响其他模块接口
    - 完成了跨模块依赖任务
    - 变更了共享资源

  同步操作:
    - 更新跨模块进度追踪文档
    - 通知依赖模块的变更
    - 更新接口契约文档
```

---

## 🔍 开发前后标准检查流程

### 开发前标准检查流程

详见主标准文档第4.1节。

**三层检查**:
1. 状态确认检查（必读UPM）
2. 文档偏差预检查（评估准确性）
3. 技术准备确认（模块特定命令）

### 开发后标准更新流程

详见主标准文档第4.2节。

**两步更新**:
1. 状态同步（更新任务和UPM）
2. 进度报告（更新KPI和生成报告）

---

## 📝 附录

### A.1 七步循环快速参考卡

```yaml
Step 1: 项目状态感知
  → 读取UPM → 解析状态 → 检查前置
  输出: 当前状态 + 活跃任务

Step 2: 任务规划
  → 任务分解 → 优先级 → 依赖分析
  输出: 任务列表 + 执行计划

Step 3: Subagent分配
  → 能力匹配 → 优先级配置
  输出: 任务-Subagent映射

Step 4: 执行验证
  → 静态检查 → 测试 → 构建
  输出: 验证报告

Step 5: 架构同步
  → 识别变更 → 更新文档 → ADR
  输出: 更新的架构文档

Step 6: Git提交
  → 分组策略 → 规范消息
  输出: 提交记录

Step 7: 进度更新
  → 更新UPM → 同步KPI → 触发后续
  输出: 更新的UPM文档
```

### A.2 变更历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 1.0.0-workflow | 2025-12-09 | 初始版本，详细定义七步循环 |

---

**文档维护者**: Tech Lead + AI Development Team
**最后更新**: 2025-12-09
**适用模块**: Mobile, Backend, Frontend, Shared
**相关文档**: ai-ddd-progress-management-core.md, ai-ddd-state-management.md
