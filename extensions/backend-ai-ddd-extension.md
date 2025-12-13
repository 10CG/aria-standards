# Backend模块AI-DDD进度管理扩展规范

> **文档版本**: 3.0.0-backend-extension
> **创建日期**: 2025-12-09
> **基于核心标准**: ai-ddd-progress-management-core.md v1.0.0
> **适用范围**: Backend模块（Python/Node.js/FastAPI等技术栈）
> **责任人**: Backend开发团队

## 📋 概述

本文档定义Backend模块对AI-DDD进度管理核心标准的特定扩展，包括Backend特定的阶段定义、质量指标、技术验证流程和文档结构。

### 关系说明

```yaml
架构层次:
  Layer 1 - 核心标准:
    文件: docs/standards/core/ai-ddd-progress-management-core.md
    定义: 跨模块通用的进度管理框架

  Layer 2 - Backend扩展 (本文档):
    文件: docs/standards/extensions/backend-ai-ddd-extension.md
    定义: Backend模块特定的定制和扩展

  Layer 3 - 项目集成:
    文件: backend/project-planning/unified-progress-management.md
    定义: Backend模块的具体项目进度管理实例
```

---

## 🔧 扩展点1: Backend-Specific Stages

### 核心Stage扩展

基于核心标准的6个标准Stage（planning, development, testing, review, completed, blocked），Backend模块添加以下特定Stage：

```yaml
Backend特定Stage扩展:
  api-contract-design:
    描述: API契约设计和文档编写阶段
    位置: 插入在planning和development之间
    主要活动:
      - OpenAPI/Swagger规范编写
      - API端点定义
      - 请求/响应模型设计
      - API版本策略制定
    退出条件:
      - API契约文档完整
      - 与前端团队评审通过
      - 数据模型设计确认

  database-migration:
    描述: 数据库迁移和schema更新阶段
    位置: 在development过程中并行执行
    主要活动:
      - 数据库schema设计
      - 迁移脚本编写
      - 数据迁移策略制定
      - 回滚方案准备
    退出条件:
      - 迁移脚本通过测试
      - 回滚脚本验证
      - 性能影响评估完成

  api-documentation:
    描述: API文档生成和更新阶段
    位置: 插入在testing和review之间
    主要活动:
      - 生成OpenAPI文档
      - 创建API使用示例
      - 更新集成指南
      - 版本变更说明
    退出条件:
      - API文档与代码同步
      - 示例代码可运行
      - 文档审查通过

扩展后的Stage流程:
  planning → api-contract-design → development → testing → api-documentation → review → completed
  (database-migration在development中并行执行)
```

### Backend阶段细化定义

```yaml
Phase 3 - Development (Backend细化):
  Phase 3.1: API契约设计
    持续时间: 1-2周
    主要产物: OpenAPI规范文档

  Phase 3.2: 核心功能开发
    持续时间: 2-4周
    主要产物: 业务逻辑实现

  Phase 3.3: API端点实现
    持续时间: 2-3周
    主要产物: RESTful/GraphQL API

  Phase 3.4: 文档同步
    持续时间: 1周
    主要产物: 完整的API文档和集成指南
```

---

## 📊 扩展点2: Backend-Specific Quality Metrics

### Backend质量指标体系

```yaml
Backend质量指标定义:
  代码质量指标:
    单元测试覆盖率:
      目标: ">= 90%"
      度量: pytest --cov (Python) / jest --coverage (Node.js)
      权重: 30%

    代码风格检查:
      目标: "100% 符合PEP8/ESLint"
      度量: flake8 / pylint / eslint
      权重: 15%

    类型检查通过率:
      目标: "100% (无type errors)"
      度量: mypy (Python) / TypeScript compiler
      权重: 15%

    安全扫描通过:
      目标: "无高危和中危漏洞"
      度量: bandit / safety / npm audit
      权重: 10%

  API质量指标:
    API文档完整性:
      目标: "100% 端点有文档"
      度量: OpenAPI规范覆盖率
      权重: 10%

    API响应时间:
      目标: "P95 <= 200ms"
      度量: 性能测试工具
      权重: 10%

    API可用性:
      目标: ">= 99.9%"
      度量: 健康检查和监控
      权重: 5%

  数据质量指标:
    数据库查询性能:
      目标: "慢查询 <= 1%"
      度量: 数据库性能监控
      权重: 5%

KPI阈值定义:
  🟢 优秀: 所有指标达到目标的95%以上
  🟡 良好: 所有指标达到目标的85%以上
  🔴 需改进: 任意关键指标低于目标85%
```

### 质量门禁标准

```yaml
Phase转换质量门禁:
  API Contract Design → Development:
    必需条件:
      - OpenAPI规范完整且符合标准
      - API评审通过
      - 数据模型设计确认
      - 依赖服务接口明确

  Development → Testing:
    必需条件:
      - 单元测试覆盖率 >= 85%
      - 代码风格检查100%通过
      - 类型检查无错误
      - 安全扫描无高危漏洞

  Testing → Deployment:
    必需条件:
      - 集成测试100%通过
      - API文档与代码同步
      - 性能测试达标
      - 数据库迁移验证完成
      - 安全审查通过
```

---

## 🔬 扩展点3: Backend-Specific Tech Validation

### Backend技术验证流程

```yaml
Backend技术验证标准接口:
  Python/FastAPI项目验证:
    任务开始前验证:
      命令序列:
        - python --version              # Python版本确认
        - pip install -r requirements.txt  # 依赖安装
        - pytest --collect-only         # 测试发现
        - mypy --version                # 类型检查工具
        - git status                    # 分支状态

      通过条件:
        - Python版本 >= 3.9
        - 依赖安装无冲突
        - 测试可被发现
        - 工作树干净

    开发中持续验证:
      自动化检查:
        - flake8 . --max-line-length=100    # 代码风格
        - mypy .                             # 类型检查
        - bandit -r . -f json                # 安全扫描
        - pytest tests/unit -v               # 单元测试

    任务完成后验证:
      代码质量验证:
        命令: flake8 . && mypy . && bandit -r .
        标准: 0 errors, 0 warnings

      单元测试验证:
        命令: pytest tests/unit --cov=src --cov-report=term-missing
        标准: coverage >= 90%, all tests passed

      集成测试验证:
        命令: pytest tests/integration -v
        标准: all tests passed

      API文档验证:
        命令: 检查OpenAPI规范与代码一致性
        标准: 100% 端点有文档

  Node.js/Express项目验证:
    任务开始前验证:
      命令序列:
        - node --version
        - npm install
        - npm run lint -- --dry-run
        - npm test -- --listTests

    任务完成后验证:
      - npm run lint
      - npm run type-check
      - npm test -- --coverage
      - npm audit
```

### Backend验证失败处理策略

```yaml
验证失败分级处理:
  Level 1 - 阻塞性错误:
    处理: 立即停止，任务状态回退
    修复优先级: P0
    示例:
      - 单元测试失败
      - 类型检查错误
      - 高危安全漏洞
      - API契约不一致

  Level 2 - 质量问题:
    处理: 标记为需改进，限制合并
    修复优先级: P1
    示例:
      - 覆盖率不足
      - 代码风格问题
      - 中危安全漏洞
      - 性能未达标

  Level 3 - 优化建议:
    处理: 记录技术债务，不阻塞
    修复优先级: P2
    示例:
      - 代码复杂度警告
      - 文档补充建议
      - 低危安全提示
```

---

## 📁 扩展点4: Backend-Specific Doc Structure

### Backend模块文档结构定义

```yaml
Backend模块文档组织:
  项目规划文档:
    路径: backend/project-planning/
    文件:
      - unified-progress-management.md      # UPM文档（遵循UPMv2-STATE规范）
      - api-development-plan.md             # API开发计划
      - database-schema-plan.md             # 数据库设计计划

  API契约文档:
    路径: backend/docs/api/
    文件:
      - openapi.yaml                # OpenAPI 3.0规范
      - api-guide.md                # API使用指南
      - authentication.md           # 认证授权文档
      - versioning.md               # 版本管理策略

  架构文档:
    路径: backend/docs/architecture/
    文件:
      - ARCHITECTURE.md             # 架构总览
      - design-decisions/           # ADR目录
      - data-models/                # 数据模型文档

  技术文档:
    路径: backend/docs/technical/
    文件:
      - database-design.md          # 数据库设计
      - deployment-guide.md         # 部署指南
      - monitoring-setup.md         # 监控配置
      - testing-strategy.md         # 测试策略
```

### Backend UPM文档模板

```yaml
---
# UPMv2-STATE: 机读进度状态
module: "backend"
stage: "Phase 3 - Development"
cycleNumber: 5
lastUpdateAt: "2025-12-09T15:00:00+08:00"
lastUpdateRef: "git:561f3dc-创建AI-DDD核心标准"
stateToken: "sha256:def456..."

nextCycle:
  intent: "完成用户认证API和数据库迁移"
  candidates:
    - id: "backend-AUTH-1#user-login-api"
      rationale: "核心认证功能，优先级最高"
    - id: "backend-AUTH-2#token-refresh-api"
      rationale: "依赖登录API，次优先级"
  constraints:
    - "数据库迁移必须完成"
    - "与前端API契约已确认"

kpiSnapshot:
  coverage: "92.5%"
  build: "green"
  lintErrors: 0
  typeErrors: 0
  securityIssues:
    high: 0
    medium: 0
    low: 2
  api:
    endpoints: 15
    documented: 15
    responseTime_p95: "180ms"

risks:
  - id: "BACKEND_SECURITY_P1"
    level: "P1"
    mitigation: "修复2个低危安全问题"

pointers:
  upm: "backend/project-planning/unified-progress-management.md"
  api: "backend/docs/api/openapi.yaml"
  architecture: "backend/docs/architecture/ARCHITECTURE.md"
  lifecycle:
    current: "docs/project-lifecycle/week5/"
    prev: "docs/project-lifecycle/week4/"
---

# Backend模块统一进度管理

[正文内容遵循核心标准的UPM文档结构...]
```

---

## 🤖 扩展点5: Backend-Specific Subagent Mapping

### Backend Subagent优先级定义

```yaml
Backend模块Subagent映射规则:
  backend-architect:
    优先级: 最高
    适用场景:
      - RESTful/GraphQL API设计
      - 数据库schema设计
      - 系统架构设计
      - 性能优化
    文件类型:
      - "backend/**/*.py"
      - "backend/**/*.js"
      - "backend/**/*.ts"
      - "backend/src/**/*"
    能力要求:
      - 后端架构设计
      - API设计最佳实践
      - 数据库设计精通
      - 性能优化经验

  api-documenter:
    优先级: 高
    适用场景:
      - OpenAPI规范编写
      - API文档生成
      - API使用指南编写
      - SDK文档创建
    文件类型:
      - "backend/docs/api/**/*.yaml"
      - "backend/docs/api/**/*.md"
    能力要求:
      - OpenAPI 3.0规范
      - 技术文档写作
      - API设计理解
      - SDK使用经验

  qa-engineer:
    优先级: 高
    适用场景:
      - 单元测试编写
      - 集成测试设计
      - API测试自动化
      - 性能测试
    文件类型:
      - "backend/tests/**/*.py"
      - "backend/tests/**/*.js"
      - "backend/tests/**/*.spec.ts"
    能力要求:
      - 测试框架精通（pytest/jest）
      - API测试工具（Postman/Insomnia）
      - 性能测试经验
      - 测试策略设计

  knowledge-manager:
    优先级: 中
    适用场景:
      - 架构文档维护
      - ADR编写
      - 技术决策记录
      - 文档同步更新
    文件类型:
      - "backend/docs/architecture/**/*.md"
      - "backend/docs/technical/**/*.md"
      - "backend/README.md"
    能力要求:
      - 架构文档写作
      - ADR格式理解
      - 技术决策分析
      - 文档管理经验

  mobile-developer:
    优先级: 低
    适用场景:
      - 移动端API集成支持
      - 客户端SDK设计
    能力要求:
      - 理解移动端需求
      - API易用性设计

Subagent选择逻辑:
  1. API相关任务优先选择backend-architect或api-documenter
  2. 测试相关任务选择qa-engineer
  3. 文档相关任务选择knowledge-manager或api-documenter
  4. 数据库相关任务选择backend-architect
  5. 复杂任务可组合多个Subagent
```

---

## 📈 扩展点6: Backend-Specific Progress Metrics

### Backend进度度量指标

```yaml
Backend进度度量体系:
  开发进度指标:
    API端点完成度:
      定义: 已实现端点 / 计划端点总数
      目标: 按阶段递进
      权重: 30%

    数据模型完成度:
      定义: 已实现模型 / 设计模型总数
      目标: >= 95%
      权重: 20%

    数据库迁移完成度:
      定义: 已完成迁移 / 计划迁移总数
      目标: 100%
      权重: 15%

  质量进度指标:
    API文档覆盖率:
      定义: 已文档化端点 / 总端点数
      目标: 100%
      权重: 15%

    安全问题修复进度:
      定义: 已修复漏洞 / 发现漏洞总数
      目标: 高危100%, 中危95%
      权重: 10%

    性能优化进度:
      定义: 达标端点 / 总端点数
      目标: >= 90%
      权重: 10%

进度报告频率:
  日报: API端点状态更新
  周报: 完整开发和质量报告
  阶段报告: API版本发布报告
```

### Backend进度偏差管理

```yaml
Backend进度偏差阈值:
  绿色区域 (正常):
    偏差范围: <= 10%
    处理策略: 正常监控

  黄色区域 (关注):
    偏差范围: 10% - 30%
    处理策略:
      - 分析API开发瓶颈
      - 评估数据库性能影响
      - 检查依赖服务状态
      - 调整开发优先级

  红色区域 (警告):
    偏差范围: > 30%
    处理策略:
      - 暂停新功能开发
      - 技术债务评估
      - 架构问题诊断
      - 资源重新分配
      - 制定恢复计划

偏差修正流程:
  1. 偏差识别: API监控 + 代码审查
  2. 原因分析: 技术/设计/依赖
  3. 修正执行: 代码重构 + 设计调整
  4. 效果验证: 性能测试 + 质量检查
  5. 经验总结: ADR记录 + 最佳实践更新
```

---

## 🔗 与核心标准的集成

### 七步循环在Backend中的应用

```yaml
Step 1: 项目状态感知 (Backend)
  读取: backend/project-planning/unified-progress-management.md
  解析: UPMv2-STATE机读片段
  识别: module="backend", stage, cycleNumber

Step 2: 任务规划 (Backend)
  读取: backend/project-planning/api-development-plan.md
  分解: 按API端点/数据模型
  优先级: 基于API依赖关系和前端需求

Step 3: Subagent分配 (Backend)
  使用: Backend Subagent映射规则
  优先: backend-architect, api-documenter, qa-engineer

Step 4: 执行验证 (Backend)
  调用: Backend技术验证流程
  标准: Python/Node.js特定的质量门禁

Step 5: 架构同步 (Backend)
  更新: backend/docs/architecture/
  记录: ADR, API变更日志

Step 6: Git提交 (Backend)
  格式: 标准Conventional Commits
  增强: 🔧 Module: backend, Agent: backend-architect

Step 7: 进度更新 (Backend)
  更新: UPMv2-STATE片段
  同步: API文档和OpenAPI规范
  触发: 下一循环任务
```

---

## 🎯 Backend最佳实践

### API开发最佳实践

```yaml
RESTful API设计原则:
  1. 资源导向: 使用名词表示资源，避免动词
  2. HTTP方法: 正确使用GET/POST/PUT/PATCH/DELETE
  3. 状态码: 使用标准HTTP状态码
  4. 版本管理: URL或Header中包含版本号
  5. 错误处理: 统一的错误响应格式
  6. 分页排序: 支持标准的分页和排序参数
  7. 文档优先: 先设计OpenAPI规范再实现

数据库设计最佳实践:
  1. 规范化: 适度的数据库范式设计
  2. 索引策略: 为常用查询字段建立索引
  3. 迁移管理: 使用版本化的迁移脚本
  4. 回滚方案: 每个迁移必须有回滚脚本
  5. 性能考虑: N+1查询问题预防
  6. 数据完整性: 使用约束和外键

测试策略最佳实践:
  1. 单元测试: 覆盖所有业务逻辑（>= 90%）
  2. 集成测试: 覆盖API端点和数据库交互
  3. 契约测试: 验证API契约一致性
  4. 性能测试: 关注响应时间和并发处理
  5. 安全测试: 定期安全扫描和渗透测试
```

### 质量保证最佳实践

```yaml
代码质量保证:
  - 每次提交前运行linter和type checker
  - 使用代码格式化工具（black/prettier）
  - Code Review必须至少一人通过
  - 关注代码复杂度（McCabe < 10）
  - 依赖定期更新和安全审计

API质量保证:
  - OpenAPI规范与代码自动同步
  - API版本管理策略严格执行
  - 每个端点必须有示例和测试
  - 响应时间监控和告警
  - API Breaking Changes提前通知

安全质量保证:
  - 输入验证和清洗
  - 认证和授权机制完善
  - SQL注入防护
  - XSS/CSRF防护
  - 敏感数据加密存储
  - 定期安全审计和更新
```

---

## 📚 附录

### Backend扩展版本历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 3.0.0 | 2025-12-09 | 基于核心标准v1.0.0创建Backend扩展 |

### 参考文档

- [AI-DDD进度管理核心标准](../core/ai-ddd-progress-management-core.md)
- [统一进度管理接口规范](../core/unified-progress-management-spec.md)
- [进度状态机定义](../core/progress-state-machine.md)
- [Backend项目统一进度管理](../../backend/project-planning/unified-progress-management.md)

### 术语表

- **OpenAPI**: RESTful API的规范描述格式
- **RESTful**: 表述性状态传递，一种API设计风格
- **GraphQL**: 查询语言和API运行时
- **ORM**: 对象关系映射，数据库访问层
- **Migration**: 数据库版本管理和schema变更
- **Contract Testing**: 验证API提供者和消费者之间的契约

---

**文档维护者**: Backend开发团队
**最后更新**: 2025-12-09
**适用标准**: ai-ddd-progress-management-core.md v1.0.0
