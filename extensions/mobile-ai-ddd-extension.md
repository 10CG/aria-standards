# Mobile模块AI-DDD进度管理扩展规范

> **文档版本**: 3.0.0-mobile-extension
> **创建日期**: 2025-12-09
> **基于核心标准**: ai-ddd-progress-management-core.md v1.0.0
> **适用范围**: Mobile模块（Flutter/Dart技术栈）
> **责任人**: Mobile项目协调团队

## 📋 概述

本文档定义Mobile模块对AI-DDD进度管理核心标准的特定扩展，包括Mobile特定的阶段定义、质量指标、技术验证流程和文档结构。

### 关系说明

```yaml
架构层次:
  Layer 1 - 核心标准:
    文件: docs/standards/core/ai-ddd-progress-management-core.md
    定义: 跨模块通用的进度管理框架

  Layer 2 - Mobile扩展 (本文档):
    文件: docs/standards/extensions/mobile-ai-ddd-extension.md
    定义: Mobile模块特定的定制和扩展

  Layer 3 - 项目集成:
    文件: mobile/project-planning/unified-progress-management.md
    定义: Mobile模块的具体项目进度管理实例
```

---

## 🤖 AI引用导航（Mobile项目文档）

### 🔍 核心工作文档快速定位

```yaml
实时状态获取:
  UPM主文档: mobile/project-planning/unified-progress-management.md
    位置: UPMv2-STATE片段（文档顶部）
    作用: 获取module/stage/cycleNumber/kpiSnapshot/risks
    频率: 每次任务开始前必读

战略规划参考:
  开发计划: mobile/project-planning/mo-production-development-plan.md
    位置: 阶段快速参考表
    作用: 理解阶段目标和里程碑
    频率: Phase切换时或遇到战略决策时读取

任务执行指导:
  任务详情: mobile/project-planning/detailed-development-tasks.md
    位置: 按分组查找具体任务
    作用: 获取任务详细说明、验收标准、技术要点
    频率: 执行每个具体任务时读取

架构参考:
  架构文档: mobile/docs/architecture/ARCHITECTURE.md
    位置: 技术栈和目录结构说明
    作用: 理解项目架构和技术选型
    频率: 新功能设计或技术决策时读取
```

### 🏷️ AI标准化查询格式

```yaml
Step 1 - 状态感知（必须）:
  操作: 读取 @mobile/project-planning/unified-progress-management.md#UPMv2-STATE
  目标: 获取当前Phase/Cycle/Stage/KPI/Risks
  校验: 确认stateToken和lastUpdateAt

Step 2 - 战略对齐（按需）:
  操作: 读取 @mobile/project-planning/mo-production-development-plan.md#阶段快速参考表
  目标: 理解当前阶段的整体目标和约束
  触发条件: 新Phase开始或遇到战略决策

Step 3 - 任务细节（按需）:
  操作: 读取 @mobile/project-planning/detailed-development-tasks.md#{任务分组}
  目标: 获取具体任务的验收标准和技术要点
  触发条件: 执行具体开发任务时

Step 4 - 架构参考（按需）:
  操作: 读取 @mobile/docs/architecture/ARCHITECTURE.md
  目标: 了解技术栈、目录结构、架构决策
  触发条件: 新功能设计或需要架构决策时
```

### 📌 快速引用语法

```yaml
AI工具查询语法:
  # 使用@符号快速引用文档
  @unified-progress-management.md           # UPM主文档
  @mo-production-development-plan.md        # 战略规划
  @detailed-development-tasks.md            # 任务详情
  @architecture/ARCHITECTURE.md             # 架构文档

  # 使用#锚点定位具体章节
  @unified-progress-management.md#UPMv2-STATE              # 机读状态
  @mo-production-development-plan.md#阶段快速参考表         # 阶段表
  @detailed-development-tasks.md#B6-数据可视化              # 任务组

  # 使用行号范围精确定位
  @unified-progress-management.md#L1-L200    # 前200行（UPMv2-STATE）
  @detailed-development-tasks.md#L500-L600   # 特定任务区间
```

---

## 🔧 扩展点1: Mobile-Specific Stages

### 核心Stage扩展

基于核心标准的6个标准Stage（planning, development, testing, review, completed, blocked），Mobile模块添加以下特定Stage：

```yaml
Mobile特定Stage扩展:
  ui-review:
    描述: UI/UX设计审查阶段
    位置: 插入在development和testing之间
    主要活动:
      - UI设计一致性检查
      - 用户体验流程验证
      - 视觉规范符合性审查
      - 响应式布局检查
    退出条件:
      - UI设计通过审查
      - UX流程符合预期
      - 视觉规范达标

  device-testing:
    描述: 设备兼容性测试阶段
    位置: 插入在testing和review之间
    主要活动:
      - 多设备适配测试
      - 不同屏幕尺寸验证
      - Android/iOS平台兼容性
      - 性能基准测试
    退出条件:
      - 主流设备通过测试
      - 性能指标达标
      - 无严重兼容性问题

扩展后的Stage流程:
  planning → development → ui-review → testing → device-testing → review → completed
```

### Mobile阶段细化定义

```yaml
Phase 3 - Development (Mobile细化):
  Phase 3.1: UI组件开发
    持续时间: 2-3周
    主要产物: 可复用的UI Widget库

  Phase 3.2: 状态管理实现
    持续时间: 1-2周
    主要产物: 状态管理层代码

  Phase 3.3: 业务逻辑集成
    持续时间: 2-4周
    主要产物: 完整功能页面

  Phase 3.4: 性能优化
    持续时间: 1-2周
    主要产物: 性能优化报告
```

---

## 📊 扩展点2: Mobile-Specific Quality Metrics

### Mobile质量指标体系

```yaml
Mobile质量指标定义:
  代码质量指标:
    测试覆盖率:
      目标: ">= 85%"
      度量: flutter test --coverage
      权重: 30%

    代码分析通过率:
      目标: "100% (无fatal/error)"
      度量: flutter analyze --no-fatal-infos
      权重: 20%

    Widget测试覆盖:
      目标: "核心UI组件100%覆盖"
      度量: 自定义脚本统计
      权重: 15%

  性能指标:
    应用启动时间:
      目标: "<= 2.0s"
      度量: 性能监控工具
      权重: 15%

    内存使用:
      目标: "空闲 <= 150MB, 运行 <= 300MB"
      度量: DevTools Memory Profiler
      权重: 10%

    帧率稳定性:
      目标: ">= 55 FPS (99th percentile)"
      度量: Flutter Performance Overlay
      权重: 10%

  用户体验指标:
    页面完成度:
      目标: "计划功能100%实现"
      度量: 功能清单检查
      权重: 5%

    UI一致性:
      目标: "100%符合设计规范"
      度量: UI审查检查清单
      权重: 5%

KPI阈值定义:
  🟢 优秀: 所有指标达到目标的95%以上
  🟡 良好: 所有指标达到目标的85%以上
  🔴 需改进: 任意关键指标低于目标85%
```

### 质量门禁标准

```yaml
Phase转换质量门禁:
  Development → Testing:
    必需条件:
      - 代码分析100%通过（无fatal/error）
      - 单元测试覆盖率 >= 80%
      - Widget核心组件测试完整
      - 编译通过无警告

  Testing → Deployment:
    必需条件:
      - 测试覆盖率 >= 85%
      - 所有集成测试通过
      - 性能指标达标
      - 设备兼容性测试通过
      - UI审查完成
```

---

## 🔬 扩展点3: Mobile-Specific Tech Validation

### Flutter技术验证流程

```yaml
Mobile技术验证标准接口:
  任务开始前验证:
    命令序列:
      - flutter doctor -v            # 环境健康检查
      - flutter pub get              # 依赖安装
      - git status                   # 分支状态确认
      - flutter analyze              # 静态分析预检查

    通过条件:
      - Flutter环境无警告
      - 依赖完整无冲突
      - 工作树干净
      - 无预存在分析错误

  开发中持续验证:
    自动化检查:
      - 保存时静态分析 (IDE集成)
      - 热重载功能验证
      - 日志监控

    人工检查:
      - UI实时预览
      - 功能交互测试
      - 性能监控观察

  任务完成后验证:
    代码质量验证:
      命令: flutter analyze --no-fatal-infos
      标准: 0 errors, 0 fatal infos

    单元测试验证:
      命令: flutter test [相关测试] --reporter=compact --concurrency=1
      标准: 100% passed

    Widget测试验证:
      命令: flutter test test/widgets/ --reporter=compact --concurrency=1
      标准: 核心组件100% passed

    覆盖率验证:
      命令: flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
      标准: overall >= 85%

    集成测试验证 (可选):
      命令: flutter test integration_test/
      标准: 关键流程100% passed
```

### 验证失败处理策略

```yaml
验证失败分级处理:
  Level 1 - 阻塞性错误 (Fatal/Error):
    处理: 立即停止，任务状态回退到development
    修复优先级: P0
    示例: 编译错误、fatal infos、测试崩溃

  Level 2 - 质量问题 (Warnings/Low Coverage):
    处理: 标记为需改进，允许继续但限制合并
    修复优先级: P1
    示例: 代码警告、覆盖率不足、性能未达标

  Level 3 - 优化建议 (Hints/Suggestions):
    处理: 记录技术债务，不阻塞流程
    修复优先级: P2
    示例: 代码优化建议、测试扩展建议
```

---

## 📁 扩展点4: Mobile-Specific Doc Structure

### Mobile模块文档结构定义

```yaml
Mobile模块文档组织:
  项目规划文档:
    路径: mobile/project-planning/
    文件:
      - unified-progress-management.md      # UPM文档（遵循UPMv2-STATE规范）
      - mo-production-development-plan.md   # 战略规划
      - detailed-development-tasks.md       # 任务细节

  项目周期文档:
    路径: docs/project-lifecycle/week{N}/
    文件:
      - plan.md                 # 周计划
      - progress-report.md      # 进度报告
      - quality-review.md       # 质量验证
      - milestone-summary.md    # 里程碑总结
    命名规则:
      - 必须使用简洁命名（无week前缀）
      - 周信息在目录名中体现
      - 功能性命名优先

  架构文档:
    路径: mobile/docs/architecture/
    文件:
      - ARCHITECTURE.md         # 架构总览
      - design-decisions/       # ADR目录
      - patterns/               # 设计模式

  技术文档:
    路径: mobile/docs/technical/
    文件:
      - state-management.md     # 状态管理方案
      - testing-strategy.md     # 测试策略
      - performance-guide.md    # 性能优化指南
```

### Mobile UPM文档模板

```yaml
---
# UPMv2-STATE: 机读进度状态
module: "mobile"
stage: "Phase 3 - Development"
cycleNumber: 7
lastUpdateAt: "2025-12-09T15:00:00+08:00"
lastUpdateRef: "git:561f3dc-创建AI-DDD核心标准"
stateToken: "sha256:abc123..."

nextCycle:
  intent: "完成P2剩余页面与性能优化"
  candidates:
    - id: "mobile-B6-2#task-analytics-chart"
      rationale: "高优先级数据可视化功能"
    - id: "mobile-B7#ai-offline-online-switch"
      rationale: "关键AI功能切换"
  constraints:
    - "依赖B5/B6已验证"
    - "内存问题已解决"

kpiSnapshot:
  coverage: "87.2%"
  build: "green"
  analyzeErrors: 0
  analyzeFatals: 0
  perf:
    startup: "1.8s"
    memory: "280MB"
    fps: "58.5"

risks:
  - id: "MOBILE_MEMORY_P0"
    level: "P0"
    mitigation: "分批执行测试+优化内存使用"

pointers:
  upm: "mobile/project-planning/unified-progress-management.md"
  plan: "mobile/project-planning/mo-production-development-plan.md"
  tasks: "mobile/project-planning/detailed-development-tasks.md"
  lifecycle:
    current: "docs/project-lifecycle/week7/"
    prev: "docs/project-lifecycle/week6/"
---

# Mobile模块统一进度管理

[正文内容遵循核心标准的UPM文档结构...]
```

---

## 🤖 扩展点5: Mobile-Specific Subagent Mapping

### Mobile Subagent优先级定义

```yaml
Mobile模块Subagent映射规则:
  mobile-developer:
    优先级: 最高
    适用场景:
      - Flutter/Dart代码开发
      - UI组件实现
      - 状态管理
      - 移动端特定功能
    文件类型:
      - "mobile/**/*.dart"
      - "mobile/lib/**/*"
      - "mobile/test/**/*"
    能力要求:
      - Flutter框架精通
      - Dart语言专家
      - 移动端UI/UX理解
      - 性能优化经验

  qa-engineer:
    优先级: 高
    适用场景:
      - Widget测试编写
      - 集成测试设计
      - 测试覆盖率提升
      - 质量验证
    文件类型:
      - "mobile/test/**/*.dart"
      - "mobile/integration_test/**/*.dart"
    能力要求:
      - Flutter测试框架
      - 测试策略设计
      - 质量标准理解

  ui-ux-designer:
    优先级: 中
    适用场景:
      - UI设计审查
      - 用户体验优化
      - 视觉规范制定
      - 响应式布局
    文件类型:
      - "mobile/lib/widgets/**/*.dart"
      - "mobile/lib/screens/**/*.dart"
    能力要求:
      - UI/UX设计原则
      - Flutter布局系统
      - Material/Cupertino设计语言

  backend-architect:
    优先级: 中
    适用场景:
      - API调用逻辑
      - 数据模型设计
      - 后端集成
    文件类型:
      - "mobile/lib/services/**/*.dart"
      - "mobile/lib/models/**/*.dart"
    能力要求:
      - API设计理解
      - 数据模型设计
      - 网络通信

  knowledge-manager:
    优先级: 中
    适用场景:
      - 文档创建和维护
      - 架构文档同步
      - 进度文档更新
    文件类型:
      - "mobile/docs/**/*.md"
      - "mobile/README.md"
      - "docs/project-lifecycle/**/*.md"
    能力要求:
      - 技术文档写作
      - 架构理解
      - AI-DDD规范理解

Subagent选择逻辑:
  1. 根据文件路径匹配主责Subagent
  2. 考虑任务类型和复杂度
  3. 评估Subagent能力匹配度
  4. 优先选择优先级最高的匹配Subagent
  5. 复杂任务可分配多个Subagent协作
```

---

## 📈 扩展点6: Mobile-Specific Progress Metrics

### Mobile进度度量指标

```yaml
Mobile进度度量体系:
  开发进度指标:
    页面完成度:
      定义: 已完成页面 / 计划页面总数
      目标: 按阶段递进（A5: 60%, A6: 80%, A7: 100%）
      权重: 25%

    功能完成度:
      定义: 已实现功能点 / 计划功能点总数
      目标: 按阶段递进
      权重: 25%

    Widget覆盖度:
      定义: 已开发Widget / 设计Widget总数
      目标: >= 95%
      权重: 15%

  质量进度指标:
    测试编写进度:
      定义: 已编写测试 / 应编写测试总数
      目标: >= 90%
      权重: 15%

    缺陷修复进度:
      定义: 已修复缺陷 / 发现缺陷总数
      目标: >= 95% (阶段末)
      权重: 10%

    性能优化进度:
      定义: 已优化项 / 识别优化项总数
      目标: >= 80%
      权重: 10%

进度报告频率:
  日报: 任务状态更新（轻量）
  周报: 完整进度报告（详细）
  阶段报告: 里程碑达成报告（全面）
```

### 进度偏差管理

```yaml
Mobile进度偏差阈值:
  绿色区域 (正常):
    偏差范围: <= 10%
    处理策略: 正常监控

  黄色区域 (关注):
    偏差范围: 10% - 30%
    处理策略:
      - 分析偏差原因
      - 调整任务优先级
      - 增加资源投入

  红色区域 (警告):
    偏差范围: > 30%
    处理策略:
      - 立即停止新任务
      - 召开偏差分析会议
      - 制定恢复计划
      - 更新项目计划
      - 向相关方报告

偏差修正流程:
  1. 偏差识别: 自动监控 + 人工确认
  2. 原因分析: 技术/资源/计划
  3. 修正执行: 按智能混合策略
  4. 效果验证: 跟踪修正效果
  5. 经验总结: 更新最佳实践
```

---

## 🔗 与核心标准的集成

### 七步循环在Mobile中的应用

```yaml
Step 1: 项目状态感知 (Mobile)
  读取: mobile/project-planning/unified-progress-management.md
  解析: UPMv2-STATE机读片段
  识别: module="mobile", stage, cycleNumber

Step 2: 任务规划 (Mobile)
  读取: mobile/project-planning/detailed-development-tasks.md
  分解: 按Flutter组件/功能模块
  优先级: 基于Mobile特定的依赖关系

Step 3: Subagent分配 (Mobile)
  使用: Mobile Subagent映射规则
  优先: mobile-developer, qa-engineer, ui-ux-designer

Step 4: 执行验证 (Mobile)
  调用: Mobile技术验证流程
  标准: Flutter特定的质量门禁

Step 5: 架构同步 (Mobile)
  更新: mobile/docs/architecture/
  记录: ADR (architecture decision records)

Step 6: Git提交 (Mobile)
  格式: 标准Conventional Commits
  增强: 📱 Module: mobile, Agent: mobile-developer

Step 7: 进度更新 (Mobile)
  更新: UPMv2-STATE片段
  同步: 项目周期文档
  触发: 下一循环任务
```

---

## 🎯 Mobile最佳实践

### 开发流程最佳实践

```yaml
Widget开发最佳实践:
  1. 设计优先: 先完成UI设计和交互原型
  2. 组件化: 优先开发可复用的基础Widget
  3. 测试驱动: 关键Widget必须有测试覆盖
  4. 性能考虑: 避免不必要的rebuild
  5. 文档同步: 重要组件必须有文档说明

状态管理最佳实践:
  1. 选择合适的状态管理方案（Provider/Riverpod/Bloc）
  2. 明确状态范围（local/global）
  3. 避免过度状态共享
  4. 状态变更可追溯
  5. 测试状态逻辑

测试策略最佳实践:
  1. 单元测试: 覆盖所有业务逻辑
  2. Widget测试: 覆盖核心UI组件
  3. 集成测试: 覆盖关键用户流程
  4. 性能测试: 关注启动、内存、帧率
  5. 设备测试: 覆盖主流设备和系统版本
```

### 质量保证最佳实践

```yaml
代码质量保证:
  - 每次提交前运行flutter analyze
  - 使用Dart Formatter保持代码格式一致
  - Code Review必须通过后才能合并
  - 关注代码复杂度和可维护性

测试质量保证:
  - 测试覆盖率不低于85%
  - 核心Widget必须100%测试覆盖
  - 测试命名清晰描述测试意图
  - 使用AAA模式（Arrange-Act-Assert）
  - Mock外部依赖避免测试脆弱

性能质量保证:
  - 定期运行性能分析
  - 监控应用启动时间
  - 追踪内存使用情况
  - 确保UI流畅度（60fps）
  - 优化网络请求和数据加载
```

---

## 📚 附录

### Mobile扩展版本历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 3.0.0 | 2025-12-09 | 基于核心标准v1.0.0创建Mobile扩展 |

### 参考文档

- [AI-DDD进度管理核心标准](../core/ai-ddd-progress-management-core.md)
- [统一进度管理接口规范](../core/unified-progress-management-spec.md)
- [进度状态机定义](../core/progress-state-machine.md)
- [Mobile开发管理体系规范](../mobile-development-management-system.md)
- [Mobile项目统一进度管理](../../mobile/project-planning/unified-progress-management.md)

### 术语表

- **Widget**: Flutter中的UI组件基本单元
- **State Management**: 状态管理，管理应用数据和UI状态的机制
- **Hot Reload**: 热重载，Flutter的快速开发特性
- **Device Testing**: 设备测试，在真机或模拟器上的兼容性测试
- **Performance Profiling**: 性能分析，使用工具分析应用性能瓶颈

---

**文档维护者**: Mobile项目协调团队
**最后更新**: 2025-12-09
**适用标准**: ai-ddd-progress-management-core.md v1.0.0
