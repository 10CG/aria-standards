# AI任务执行模板库

> **文档版本**: 1.0.0  
> **创建日期**: 2025-08-07  
> **文档类型**: 执行模板集合  
> **配套规范**: AI项目状态识别与任务执行系统规范  
> **用途**: 提供标准化的任务执行模板

## 📋 **1. 状态识别模板**

### 1.1 项目状态快速识别模板

```yaml
# 用于快速获取项目当前状态
task_template:
  name: "项目状态识别"
  subagent: "general-purpose"
  prompt: |
    请执行项目状态识别：
    
    1. 读取统一进度管理文档：
       @docs/maintained/development/mobile/project-planning/unified-progress-management.md
    
    2. 提取以下关键信息：
       - 当前阶段和周次
       - 总体完成度百分比
       - 发布就绪度评分
       - 当前进行中的任务
       - 待验证的任务
       - 主要风险和阻塞项
    
    3. 输出格式：
       ```yaml
       项目状态:
         阶段: 第X阶段第Y周
         完成度: XX%
         就绪度: XX%
         进行中: [任务列表]
         待验证: [任务列表]
         风险项: [风险列表]
       ```
```

### 1.2 任务依赖分析模板

```yaml
task_template:
  name: "任务依赖关系分析"
  subagent: "tech-lead"
  prompt: |
    分析以下任务的依赖关系：
    
    任务列表：[提供任务列表]
    
    请完成：
    1. 识别任务间的依赖关系
    2. 确定关键路径
    3. 计算任务优先级
    4. 生成执行顺序建议
    
    输出格式：
    - 依赖关系图（mermaid格式）
    - 优先级排序列表
    - 并行执行建议
```

## 🚀 **2. 开发执行模板**

### 2.1 Flutter功能开发模板

```yaml
task_template:
  name: "Flutter功能开发"
  subagent: "mobile-developer"
  prompt: |
    实现Flutter功能：[功能名称]
    
    要求：
    1. 功能描述：[详细描述]
    2. 技术要求：
       - 使用Provider状态管理
       - 遵循MVVM架构
       - 支持深色模式
    
    3. 实现步骤：
       - 创建数据模型（使用Freezed）
       - 实现业务逻辑层
       - 开发UI组件
       - 添加单元测试
    
    4. 验收标准：
       - 功能正常工作
       - 测试覆盖率>80%
       - 通过flutter analyze
    
    5. 输出要求：
       - 完整的代码实现
       - 测试用例
       - 简要实现说明
```

### 2.2 AI功能集成模板

```yaml
task_template:
  name: "AI功能集成"
  subagent: "ai-engineer"
  prompt: |
    集成AI功能：[功能名称]
    
    需求：
    1. 功能目标：[目标描述]
    2. AI能力要求：
       - LLM模型选择
       - 推理策略
       - 响应时间要求
    
    3. 集成要求：
       - API接口设计
       - 错误处理机制
       - 性能优化策略
    
    4. 实现内容：
       - AI服务封装
       - 提示词工程
       - 结果处理逻辑
       - 缓存策略
    
    验收标准：
    - 功能可用性验证
    - 响应时间<3秒
    - 准确率>85%
```

### 2.3 性能优化模板

```yaml
task_template:
  name: "性能优化实施"
  subagent: "mobile-developer"
  prompt: |
    执行性能优化：[优化目标]
    
    当前状况：
    - 性能指标：[当前数据]
    - 瓶颈分析：[问题描述]
    
    优化方案：
    1. 内存优化
       - 减少内存占用
       - 优化对象生命周期
    
    2. 渲染优化
       - 减少重建次数
       - 使用const构造器
    
    3. 网络优化
       - 实现缓存机制
       - 优化请求策略
    
    目标指标：
    - 启动时间<3秒
    - 内存占用<150MB
    - 帧率>50fps
    
    验证方法：
    - 性能测试脚本
    - 对比测试数据
```

## 🧪 **3. 测试验证模板**

### 3.1 单元测试编写模板

```yaml
task_template:
  name: "单元测试完善"
  subagent: "qa-engineer"
  prompt: |
    为以下模块编写单元测试：[模块名称]
    
    测试要求：
    1. 覆盖率目标：>85%
    2. 测试场景：
       - 正常流程
       - 边界条件
       - 异常处理
    
    3. 测试框架：
       - 使用Flutter test
       - Mock依赖项
       - 使用AAA模式
    
    4. 具体任务：
       - 分析代码逻辑
       - 设计测试用例
       - 编写测试代码
       - 验证覆盖率
    
    输出：
    - 完整测试文件
    - 覆盖率报告
    - 测试说明文档
```

### 3.2 集成测试模板

```yaml
task_template:
  name: "集成测试执行"
  subagent: "qa-engineer"
  prompt: |
    执行集成测试验证
    
    测试范围：
    1. 端到端流程测试
    2. API集成测试
    3. 数据库操作测试
    
    执行步骤：
    1. 准备测试环境
    2. 执行测试套件
    3. 分析测试结果
    4. 生成测试报告
    
    关注点：
    - 功能完整性
    - 数据一致性
    - 性能表现
    - 错误处理
    
    输出要求：
    - 测试执行日志
    - 问题列表
    - 改进建议
```

### 3.3 质量评估模板

```yaml
task_template:
  name: "代码质量评估"
  subagent: "qa-engineer"
  prompt: |
    评估代码质量：[模块/功能]
    
    评估维度：
    1. 代码规范性
       - 命名规范
       - 代码风格
       - 注释完整性
    
    2. 架构合理性
       - 模块划分
       - 依赖关系
       - 设计模式
    
    3. 可维护性
       - 代码复杂度
       - 重复代码
       - 技术债务
    
    4. 测试质量
       - 测试覆盖率
       - 测试有效性
       - 测试可维护性
    
    输出报告：
    - 质量评分（A-F）
    - 问题清单
    - 改进建议
    - 优先级排序
```

## 📝 **4. 文档管理模板**

### 4.1 架构文档更新模板

```yaml
task_template:
  name: "架构文档同步"
  subagent: "api-documenter"
  prompt: |
    更新架构文档以反映最新变更
    
    变更内容：[列出变更]
    
    更新任务：
    1. 更新ARCHITECTURE.md
       - 模块结构图
       - 依赖关系
       - 技术栈说明
    
    2. 更新API文档
       - 接口变更
       - 数据模型
       - 错误码
    
    3. 更新开发指南
       - 新功能使用
       - 配置说明
       - 示例代码
    
    要求：
    - 保持文档一致性
    - 更新版本号
    - 添加变更日志
```

### 4.2 进度报告生成模板

```yaml
task_template:
  name: "周进度报告生成"
  subagent: "general-purpose"
  prompt: |
    生成本周进度报告
    
    报告内容：
    1. 本周完成情况
       - 完成的任务列表
       - 达成的里程碑
       - 解决的问题
    
    2. 关键指标
       - 完成度变化
       - 测试覆盖率
       - 质量指标
    
    3. 下周计划
       - 计划任务
       - 风险项
       - 依赖项
    
    格式要求：
    - Markdown格式
    - 包含数据表格
    - 添加进度图表
    
    输出位置：
    docs/project-lifecycle/week{N}/progress-report.md
```

### 4.3 技术决策记录模板

```yaml
task_template:
  name: "技术决策记录"
  subagent: "tech-lead"
  prompt: |
    记录技术决策：[决策主题]
    
    记录内容：
    1. 背景和问题
       - 问题描述
       - 影响范围
       - 约束条件
    
    2. 方案对比
       - 方案A：[描述]
       - 方案B：[描述]
       - 优缺点分析
    
    3. 决策结果
       - 选择的方案
       - 决策理由
       - 实施计划
    
    4. 影响评估
       - 技术影响
       - 进度影响
       - 风险评估
    
    输出格式：
    - ADR格式（Architecture Decision Record）
    - 保存到：docs/decisions/ADR-{编号}-{主题}.md
```

## 🔧 **5. 分支管理模板**

### 5.1 功能分支创建模板

```bash
# 功能分支创建脚本模板
#!/bin/bash

FEATURE_NAME="$1"
BASE_BRANCH="mobile/develop"

# 检查参数
if [ -z "$FEATURE_NAME" ]; then
    echo "错误：请提供功能名称"
    exit 1
fi

# 更新基础分支
git checkout $BASE_BRANCH
git pull origin $BASE_BRANCH

# 创建功能分支
git checkout -b "mobile/feature/$FEATURE_NAME"

# 初始化功能结构
mkdir -p "mobile/app/lib/features/$FEATURE_NAME"
mkdir -p "mobile/app/test/features/$FEATURE_NAME"

# 创建初始文件
cat > "mobile/app/lib/features/$FEATURE_NAME/README.md" << EOF
# $FEATURE_NAME Feature

## 概述
[功能描述]

## 架构
[架构说明]

## 使用方法
[使用说明]
EOF

echo "功能分支 mobile/feature/$FEATURE_NAME 创建成功"
```

### 5.2 分支合并模板

```yaml
task_template:
  name: "分支合并操作"
  subagent: "general-purpose"
  prompt: |
    执行分支合并：[源分支] -> [目标分支]
    
    合并前检查：
    1. 确认测试通过
    2. 代码审查完成
    3. 文档已更新
    
    合并步骤：
    1. 拉取最新代码
    2. 解决冲突（如有）
    3. 运行测试验证
    4. 执行合并
    5. 推送到远程
    
    合并后操作：
    1. 删除功能分支
    2. 更新进度文档
    3. 通知相关人员
```

### 5.3 版本发布模板

```yaml
task_template:
  name: "版本发布准备"
  subagent: "tech-lead"
  prompt: |
    准备版本发布：v[版本号]
    
    发布检查清单：
    □ 所有功能完成
    □ 测试全部通过
    □ 文档已更新
    □ 性能达标
    □ 安全检查通过
    
    发布步骤：
    1. 创建发布分支
       git checkout -b mobile/release/v[版本号]
    
    2. 版本号更新
       - pubspec.yaml
       - 版本说明文档
    
    3. 最终测试
       - 回归测试
       - 性能测试
       - 兼容性测试
    
    4. 生成发布包
       - Android APK
       - iOS IPA
    
    5. 发布准备
       - 发布说明
       - 更新日志
       - 用户指南
```

## 🛠 **6. 故障处理模板**

### 6.1 构建失败处理模板

```yaml
task_template:
  name: "构建失败修复"
  subagent: "mobile-developer"
  prompt: |
    修复构建失败问题
    
    错误信息：[提供错误日志]
    
    诊断步骤：
    1. 分析错误日志
    2. 识别失败原因
    3. 确定影响范围
    
    修复方案：
    1. 依赖问题
       - 更新依赖版本
       - 清理缓存
       - 重新安装
    
    2. 代码问题
       - 语法错误修复
       - 类型错误处理
       - 导入路径修正
    
    3. 配置问题
       - 环境变量检查
       - 构建配置调整
       - 平台配置修复
    
    验证步骤：
    1. 本地构建测试
    2. CI构建验证
    3. 多平台测试
```

### 6.2 测试失败分析模板

```yaml
task_template:
  name: "测试失败分析"
  subagent: "qa-engineer"
  prompt: |
    分析测试失败原因
    
    失败信息：
    - 失败测试数：[数量]
    - 测试套件：[名称]
    - 错误类型：[类型]
    
    分析任务：
    1. 失败原因分类
       - 代码缺陷
       - 测试问题
       - 环境问题
       - 数据问题
    
    2. 影响评估
       - 功能影响
       - 用户影响
       - 发布影响
    
    3. 修复建议
       - 优先级排序
       - 修复方案
       - 责任分配
    
    输出报告：
    - 问题根因
    - 修复计划
    - 预防措施
```

### 6.3 性能问题排查模板

```yaml
task_template:
  name: "性能问题诊断"
  subagent: "mobile-developer"
  prompt: |
    诊断性能问题：[问题描述]
    
    性能指标：
    - 当前值：[数据]
    - 期望值：[目标]
    - 差距：[百分比]
    
    排查步骤：
    1. 性能分析
       - CPU使用率
       - 内存占用
       - 网络延迟
       - 渲染性能
    
    2. 瓶颈定位
       - 代码热点
       - 资源竞争
       - I/O阻塞
       - 算法复杂度
    
    3. 优化方案
       - 代码优化
       - 架构调整
       - 缓存策略
       - 异步处理
    
    验证方法：
    - 基准测试
    - 对比分析
    - 持续监控
```

## 💡 **7. 组合执行模板**

### 7.1 完整功能开发流程模板

```yaml
composite_template:
  name: "端到端功能开发"
  steps:
    - step: 1
      template: "功能分支创建"
      subagent: "general-purpose"
      
    - step: 2
      template: "Flutter功能开发"
      subagent: "mobile-developer"
      
    - step: 3
      template: "单元测试编写"
      subagent: "qa-engineer"
      
    - step: 4
      template: "代码质量评估"
      subagent: "qa-engineer"
      
    - step: 5
      template: "架构文档更新"
      subagent: "api-documenter"
      
    - step: 6
      template: "分支合并操作"
      subagent: "general-purpose"
      
    - step: 7
      template: "进度报告更新"
      subagent: "general-purpose"
```

### 7.2 紧急修复流程模板

```yaml
composite_template:
  name: "紧急问题修复"
  steps:
    - step: 1
      name: "问题诊断"
      subagent: "tech-lead"
      priority: "P0"
      
    - step: 2
      name: "创建hotfix分支"
      subagent: "general-purpose"
      command: "git checkout -b mobile/hotfix/issue-xxx"
      
    - step: 3
      name: "实施修复"
      subagent: "mobile-developer"
      
    - step: 4
      name: "快速测试"
      subagent: "qa-engineer"
      
    - step: 5
      name: "合并到主分支"
      subagent: "general-purpose"
      
    - step: 6
      name: "生成修复报告"
      subagent: "api-documenter"
```

### 7.3 周度交付流程模板

```yaml
composite_template:
  name: "周度交付流程"
  schedule: "每周五执行"
  steps:
    - step: 1
      name: "收集本周完成任务"
      subagent: "general-purpose"
      
    - step: 2
      name: "执行完整测试"
      subagent: "qa-engineer"
      
    - step: 3
      name: "性能基准测试"
      subagent: "mobile-developer"
      
    - step: 4
      name: "生成质量报告"
      subagent: "qa-engineer"
      
    - step: 5
      name: "创建稳定基线"
      subagent: "general-purpose"
      
    - step: 6
      name: "生成周报告"
      subagent: "api-documenter"
      
    - step: 7
      name: "规划下周任务"
      subagent: "tech-lead"
```

## 📊 **8. 监控与报告模板**

### 8.1 日常监控模板

```yaml
monitoring_template:
  name: "项目健康度监控"
  frequency: "每日"
  metrics:
    - 构建状态
    - 测试通过率
    - 代码覆盖率
    - 性能指标
    - 文档更新状态
    
  alerts:
    - condition: "测试通过率 < 95%"
      action: "触发测试修复流程"
      
    - condition: "构建失败"
      action: "立即修复"
      
    - condition: "性能退化 > 10%"
      action: "性能优化分析"
```

### 8.2 KPI报告模板

```yaml
kpi_template:
  name: "项目KPI报告"
  indicators:
    完成度:
      current: "[当前值]%"
      target: "100%"
      trend: "上升/下降"
      
    质量指标:
      test_coverage: "[覆盖率]%"
      code_quality: "A/B/C"
      bug_density: "[数量]/KLOC"
      
    效率指标:
      velocity: "[故事点]/周"
      cycle_time: "[天数]"
      lead_time: "[天数]"
      
    发布就绪度:
      feature_complete: "[百分比]%"
      test_complete: "[百分比]%"
      doc_complete: "[百分比]%"
```

## 📌 **使用指南**

### 快速选择模板

1. **状态识别阶段** → 使用第1节模板
2. **开发执行阶段** → 使用第2节模板
3. **测试验证阶段** → 使用第3节模板
4. **文档更新阶段** → 使用第4节模板
5. **分支管理阶段** → 使用第5节模板
6. **故障处理阶段** → 使用第6节模板
7. **复杂流程** → 使用第7节组合模板

### 模板使用原则

1. **选择合适的模板** - 根据任务类型选择对应模板
2. **填充具体信息** - 将模板中的占位符替换为实际内容
3. **调整执行参数** - 根据实际情况调整模板参数
4. **记录执行结果** - 保存执行日志供后续参考

### 模板扩展方法

```yaml
custom_template:
  base: "基础模板名称"
  extensions:
    - 添加特定检查项
    - 自定义输出格式
    - 增加验证步骤
  overrides:
    - 修改默认参数
    - 调整执行顺序
```

---

本模板库将持续更新和优化，确保覆盖项目开发的各个场景，提高AI执行效率和质量。