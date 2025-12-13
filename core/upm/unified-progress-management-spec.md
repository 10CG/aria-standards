# UPMv2-STATE统一进度管理接口规范

> **文档版本**: 1.0.0-spec
> **创建日期**: 2025-12-09
> **适用范围**: 所有模块的UPM文档
> **核心标准**: ai-ddd-progress-management-core.md v1.0.0
> **架构设计**: @docs/analysis/ai-ddd-universal-progress-management-adr.md
> **责任人**: Tech Lead + AI Development Team

## 📋 规范概述

### 目标

定义统一的、模块无关的进度管理机读接口（UPMv2-STATE），确保：
- ✅ 所有模块UPM文档遵循统一格式
- ✅ AI能以标准化方式读取任意模块的进度状态
- ✅ 支持跨模块进度追踪和同步
- ✅ 接口版本化，便于未来扩展

### 适用文档

所有模块的统一进度管理文档必须包含UPMv2-STATE机读片段。

**路径规范（基于Submodule架构）**:

```yaml
路径模板:
  {module}/[docs/]project-planning/unified-progress-management.md

实际路径示例:
  Mobile:   mobile/docs/project-planning/unified-progress-management.md
  Backend:  backend/project-planning/unified-progress-management.md
  Frontend: frontend/project-planning/unified-progress-management.md (待创建)
  Shared:   shared/project-planning/unified-progress-management.md (待创建)

路径说明:
  - Mobile: 在submodule内部有docs/子目录（历史遗留结构）
  - Backend/Frontend/Shared: 直接在submodule根目录下的project-planning/
  - 所有路径从主项目根目录开始计算
```

**支持的模块**:
- `mobile` - 移动端模块（Flutter/Dart）
- `backend` - 后端模块（Python/FastAPI）
- `frontend` - 前端模块（待创建）
- `shared` - 共享模块（跨端通用代码）
- 其他自定义模块名

---

## 🔧 接口规范定义

### 1. UPMv2-STATE机读片段

**位置要求**：必须位于文档开头，在任何Markdown标题之前

**格式要求**：YAML frontmatter格式，使用三个短横线包围

**完整示例**：
```yaml
---
# UPMv2-STATE: 机读进度状态
module: "mobile"
stage: "Phase 4 - Sprint Development"
cycleNumber: 9
lastUpdateAt: "2025-12-09T15:30:00+08:00"
lastUpdateRef: "git:1d475f5-更新backend子模块架构文档"
stateToken: "sha256:a1b2c3d4e5f6..."
---
```

### 2. 必需字段定义

#### 2.1 module (必需)

**类型**: `string`
**值域**: `"mobile" | "backend" | "frontend" | "shared" | {custom}`
**说明**: 模块标识符，用于区分不同模块的进度状态

**示例**:
```yaml
module: "mobile"      # 移动端模块
module: "backend"     # 后端模块
module: "frontend"    # 前端模块
module: "shared"      # 共享模块
```

**约束**:
- 必须是小写字母
- 建议使用单个英文单词
- 跨多个子模块可使用连字符，如 `mobile-app`

#### 2.2 stage (必需)

**类型**: `string`
**格式**: `"Phase {N} - {Stage Name}"`
**说明**: 当前项目阶段，包含Phase编号和阶段名称

**标准格式**:
```yaml
# 格式: "Phase {integer} - {stage name}"
stage: "Phase 1 - Planning"          # 规划阶段
stage: "Phase 2 - Design"            # 设计阶段
stage: "Phase 3 - Development"       # 开发阶段
stage: "Phase 4 - Testing"           # 测试阶段
stage: "Phase 5 - Deployment"        # 部署阶段
```

**自定义阶段名**:
```yaml
stage: "Phase 3 - Sprint Development"     # 自定义：冲刺开发
stage: "Phase 4 - Beta Testing"           # 自定义：Beta测试
stage: "Phase 2 - API Design"             # 自定义：API设计
```

**约束**:
- Phase编号必须是正整数
- 阶段名称建议使用Title Case
- 整个字符串必须用引号包围

#### 2.3 cycleNumber (必需)

**类型**: `integer`
**值域**: 正整数，从1开始
**说明**: 当前阶段内的迭代周期编号

**示例**:
```yaml
cycleNumber: 1     # 第1个周期
cycleNumber: 9     # 第9个周期
cycleNumber: 15    # 第15个周期
```

**约束**:
- 必须是正整数（> 0）
- 在同一阶段内单调递增
- 切换到新阶段时重置为1

**周期切换示例**:
```yaml
# Phase 3 - Cycle 9
stage: "Phase 3 - Development"
cycleNumber: 9

# 进入Phase 4后，周期重置
stage: "Phase 4 - Testing"
cycleNumber: 1
```

#### 2.4 lastUpdateAt (必需)

**类型**: `string`
**格式**: ISO 8601日期时间格式
**时区**: 建议使用 `+08:00` (中国标准时间)
**说明**: UPM文档最后更新的时间戳

**标准格式**:
```yaml
lastUpdateAt: "2025-12-09T15:30:00+08:00"
```

**格式说明**:
```
YYYY-MM-DDTHH:mm:ss+08:00
│    │  │ │  │  │  └─────── 时区偏移
│    │  │ │  │  └────────── 秒 (00-59)
│    │  │ │  └───────────── 分钟 (00-59)
│    │  │ └──────────────── 小时 (00-23)
│    │  └─────────────────── 日 (01-31)
│    └────────────────────── 月 (01-12)
└─────────────────────────── 年 (四位数)
```

**约束**:
- 必须是有效的ISO 8601格式
- 建议精确到秒
- 时区建议明确指定

#### 2.5 stateToken (必需)

**类型**: `string`
**格式**: `"sha256:{hex_string}"`
**说明**: 状态内容的SHA-256哈希值，用于检测状态变更

**计算方法**:
```javascript
// 伪代码
const stateContent = `${module}|${stage}|${cycleNumber}|${activeTasks}`;
const hash = sha256(stateContent);
const stateToken = `sha256:${hash}`;
```

**示例**:
```yaml
stateToken: "sha256:a1b2c3d4e5f6789..."
```

**用途**:
- 快速检测状态是否变更
- 验证文档完整性
- 支持缓存机制

**约束**:
- 前缀必须是 `sha256:`
- 哈希值必须是有效的十六进制字符串（64个字符）

### 3. 可选字段定义

#### 3.1 lastUpdateRef (推荐)

**类型**: `string`
**格式**: `"git:{commit-hash}-{brief-description}"`
**说明**: 最后更新对应的Git提交引用

**示例**:
```yaml
lastUpdateRef: "git:1d475f5-更新backend子模块架构文档"
lastUpdateRef: "git:abc1234-完成用户认证功能开发"
```

**格式说明**:
```
git:{7-char-hash}-{brief-description}
│   │            └────────────────── 简要描述（中文或英文）
│   └─────────────────────────────── 7位短提交哈希
└─────────────────────────────────── git前缀
```

**约束**:
- commit-hash建议使用7位短哈希
- brief-description应简洁明了（<50字符）
- 整个字符串用引号包围

#### 3.2 其他自定义字段

模块可以添加自定义字段，但必须在模块扩展标准中明确定义：

**示例**:
```yaml
# Mobile模块自定义字段
currentSprint: "Sprint 5"
releaseVersion: "v2.1.0-beta"

# Backend模块自定义字段
apiVersion: "v1.2.0"
deploymentEnv: "staging"
```

**约束**:
- 自定义字段名使用camelCase
- 必须在模块扩展标准中文档化
- 不应与必需字段冲突

---

## 📄 完整文档结构

### 4. UPM文档完整示例

```markdown
---
# UPMv2-STATE: 机读进度状态
module: "backend"
stage: "Phase 3 - Development"
cycleNumber: 1
lastUpdateAt: "2025-12-09T15:30:00+08:00"
lastUpdateRef: "git:1d475f5-创建Backend架构文档"
stateToken: "sha256:a1b2c3d4e5f6789abcdef..."
---

# Backend统一进度管理

> **最后更新**: 2025-12-09
> **当前阶段**: Phase 3 - Development, Cycle 1
> **维护者**: Backend Team

## 当前项目状态

**阶段**: Phase 3 - Development
**周期**: Cycle 1
**时间**: 2025-12-09
**主要目标**: 完成LLM Provider抽象层和FastAPI基础框架

### 活跃任务

- [ ] BE-001: 创建LLM Provider核心接口 - In Progress
- [ ] BE-002: 实现Claude Provider - Planning
- [ ] BE-003: 创建FastAPI应用结构 - Planning

### 已完成任务

- [x] BE-000: Backend架构文档创建 - 完成于 2025-12-09

### KPI仪表板

| 指标 | 当前值 | 目标值 | 状态 |
|------|--------|--------|------|
| 架构文档覆盖率 | 100% | 100% | ✅ 达标 |
| 测试覆盖率 | 0% | ≥80% | ⏳ 进行中 |
| API文档覆盖率 | 0% | 100% | ⏳ 进行中 |

## 详细任务状态

### BE-001: 创建LLM Provider核心接口

**状态**: In Progress
**优先级**: P0
**负责人**: backend-architect subagent
**预计完成**: 2025-12-10

**任务描述**:
创建LLM Provider的抽象基类和核心接口定义...

### BE-002: 实现Claude Provider

**状态**: Planning
**优先级**: P1
**依赖**: BE-001
**预计开始**: 2025-12-10

**任务描述**:
实现Claude Provider，封装Anthropic SDK...
```

### 5. 章节结构要求

**必需章节**:
1. **UPMv2-STATE机读片段** (YAML frontmatter)
2. **当前项目状态** - 概要信息
   - 阶段、周期、时间
   - 主要目标
   - 活跃任务列表
   - 已完成任务列表
   - KPI仪表板
3. **详细任务状态** - 每个任务的详细信息

**推荐章节**:
- 阶段计划概览
- 风险和问题追踪
- 里程碑状态
- 团队分工

**可选章节**:
- 技术债务记录
- 决策日志
- 性能指标趋势

---

## 🔄 状态更新流程

### 6. 何时更新UPM文档

**必须更新的场景**:
1. 完成一个任务（标记为completed）
2. 开始新任务（标记为in progress）
3. 阶段或周期转换
4. KPI指标显著变化（±10%）
5. 添加或删除任务

**建议更新的场景**:
1. 每日工作结束时
2. 重要提交后
3. 遇到阻塞问题时
4. 里程碑达成时

### 7. 更新步骤

**Step 1: 更新必需字段**
```yaml
# 更新时间戳
lastUpdateAt: "2025-12-09T16:00:00+08:00"  # 当前时间

# 更新Git引用
lastUpdateRef: "git:abc1234-完成BE-001任务"  # 最新提交

# 重新计算stateToken
# （如果状态内容变化）
stateToken: "sha256:new_hash_value..."
```

**Step 2: 更新任务状态**
```markdown
### 已完成任务
- [x] BE-001: 创建LLM Provider核心接口 - 完成于 2025-12-09

### 活跃任务
- [ ] BE-002: 实现Claude Provider - In Progress  # 状态更新
```

**Step 3: 更新KPI指标**
```markdown
| 指标 | 当前值 | 目标值 | 状态 |
|------|--------|--------|------|
| 测试覆盖率 | 45% | ≥80% | ⏳ 进行中 |  # 更新数值
```

**Step 4: 提交变更**
```bash
git add docs/maintained/development/backend/project-planning/unified-progress-management.md
git commit -m "docs(backend): 更新进度状态 - 完成BE-001

更新Backend UPM文档：
- 标记BE-001为已完成
- 更新BE-002状态为In Progress
- 更新测试覆盖率为45%

📋 Context: Phase3-Cycle1 API-development
🔗 Module: backend
"
```

---

## ✅ 验证与检查

### 8. UPMv2-STATE格式验证

**YAML语法验证**:
```bash
# 使用YAML linter验证语法
yamllint docs/maintained/development/{module}/project-planning/unified-progress-management.md
```

**必需字段检查**:
```javascript
// 伪代码
function validateUPMv2STATE(yamlContent) {
  const required = ['module', 'stage', 'cycleNumber', 'lastUpdateAt', 'stateToken'];

  for (const field of required) {
    if (!yamlContent[field]) {
      throw new Error(`Missing required field: ${field}`);
    }
  }

  // 验证格式
  if (!yamlContent.stage.startsWith('Phase ')) {
    throw new Error('Invalid stage format');
  }

  if (yamlContent.cycleNumber < 1) {
    throw new Error('cycleNumber must be >= 1');
  }

  if (!isValidISO8601(yamlContent.lastUpdateAt)) {
    throw new Error('Invalid ISO 8601 timestamp');
  }

  if (!yamlContent.stateToken.startsWith('sha256:')) {
    throw new Error('Invalid stateToken format');
  }
}
```

### 9. 常见错误与修复

**错误1: YAML格式错误**
```yaml
# ❌ 错误：缺少引号
module: mobile

# ✅ 正确：字符串值必须用引号
module: "mobile"
```

**错误2: stage格式不规范**
```yaml
# ❌ 错误：缺少Phase前缀
stage: "Development"

# ✅ 正确：必须包含Phase编号
stage: "Phase 3 - Development"
```

**错误3: lastUpdateAt格式错误**
```yaml
# ❌ 错误：缺少时区信息
lastUpdateAt: "2025-12-09 15:30:00"

# ✅ 正确：ISO 8601格式
lastUpdateAt: "2025-12-09T15:30:00+08:00"
```

**错误4: stateToken格式错误**
```yaml
# ❌ 错误：缺少sha256前缀
stateToken: "a1b2c3d4..."

# ✅ 正确：必须包含sha256前缀
stateToken: "sha256:a1b2c3d4..."
```

---

## 🔌 AI读取接口

### 10. 标准读取流程

**Step 1: 定位UPM文档**
```python
# 伪代码 - 动态路径解析
def get_upm_path(module: str) -> str:
    """
    根据模块名返回实际的UPM文档路径

    路径规则:
    - Mobile: mobile/docs/project-planning/unified-progress-management.md (历史遗留)
    - 其他模块: {module}/project-planning/unified-progress-management.md
    """
    if module == "mobile":
        return "mobile/docs/project-planning/unified-progress-management.md"
    else:
        # backend, frontend, shared等
        return f"{module}/project-planning/unified-progress-management.md"

# 使用示例
upm_path_backend = get_upm_path("backend")   # backend/project-planning/unified-progress-management.md
upm_path_mobile = get_upm_path("mobile")     # mobile/docs/project-planning/unified-progress-management.md
```

**Step 2: 解析YAML frontmatter**
```python
import yaml
import re

def parse_upmv2_state(file_content: str) -> dict:
    # 提取YAML frontmatter
    match = re.search(r'^---\n(.*?)\n---', file_content, re.DOTALL)
    if not match:
        raise ValueError("No UPMv2-STATE found")

    yaml_content = match.group(1)
    state = yaml.safe_load(yaml_content)

    return state
```

**Step 3: 验证和使用**
```python
state = parse_upmv2_state(file_content)

# 验证必需字段
validate_upmv2_state(state)

# 使用状态信息
print(f"Module: {state['module']}")
print(f"Stage: {state['stage']}")
print(f"Cycle: {state['cycleNumber']}")
```

### 11. 跨模块状态查询

**查询所有模块状态**:
```python
def get_all_modules_state() -> dict:
    modules = ['mobile', 'backend', 'frontend', 'shared']
    states = {}

    for module in modules:
        try:
            upm_path = get_upm_path(module)
            content = read_file(upm_path)
            states[module] = parse_upmv2_state(content)
        except FileNotFoundError:
            # 模块UPM文档不存在
            states[module] = None

    return states
```

**生成跨模块进度报告**:
```python
def generate_cross_module_report(states: dict) -> str:
    report = "# 全项目进度概览\n\n"

    for module, state in states.items():
        if state:
            report += f"- **{module.title()}**: {state['stage']}, Cycle {state['cycleNumber']}\n"
        else:
            report += f"- **{module.title()}**: 未初始化\n"

    return report
```

---

## 📚 接口版本管理

### 12. 版本演进

**当前版本**: UPMv2-STATE v1.0.0

**版本历史**:
- v1.0.0 (2025-12-09): 初始规范定义

**未来版本规划**:
- v1.1.0: 可能添加任务依赖关系字段
- v2.0.0: 如需不兼容变更，升级到v2

### 13. 向后兼容性

**承诺**:
- 同一MAJOR版本内保持向后兼容
- 新增可选字段不视为破坏性变更
- 必需字段变更必须升级MAJOR版本

**升级策略**:
```yaml
# v1.x → v2.x升级时
# 提供自动迁移工具
python scripts/migrate_upm_v1_to_v2.py

# 或保持v1格式（兼容期）
# 同时支持v1和v2解析
```

---

## 📞 支持与反馈

### 问题报告

如果发现规范问题或需要澄清：
1. 查看 [ADR文档](../../analysis/ai-ddd-universal-progress-management-adr.md)
2. 查看 [核心标准](./ai-ddd-progress-management-core.md)
3. 提交Issue，标签：`standards/core/upm-spec`

### 规范改进

如需改进接口规范：
1. 提交Issue说明改进理由
2. 评估对现有文档的影响
3. 提供迁移方案（如涉及不兼容变更）

---

## 📝 附录

### A. 完整YAML Schema

```yaml
# UPMv2-STATE YAML Schema (JSON Schema格式)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["module", "stage", "cycleNumber", "lastUpdateAt", "stateToken"],
  "properties": {
    "module": {
      "type": "string",
      "pattern": "^[a-z][a-z0-9-]*$",
      "description": "Module identifier"
    },
    "stage": {
      "type": "string",
      "pattern": "^Phase \\d+ - .+$",
      "description": "Current phase and stage"
    },
    "cycleNumber": {
      "type": "integer",
      "minimum": 1,
      "description": "Iteration cycle number within phase"
    },
    "lastUpdateAt": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 timestamp of last update"
    },
    "lastUpdateRef": {
      "type": "string",
      "pattern": "^git:[a-f0-9]{7}-.+$",
      "description": "Git commit reference"
    },
    "stateToken": {
      "type": "string",
      "pattern": "^sha256:[a-f0-9]{64}$",
      "description": "SHA-256 hash of state content"
    }
  },
  "additionalProperties": true
}
```

### B. 快速参考卡片

```yaml
# UPMv2-STATE快速参考

必需字段（5个）:
  module:        "mobile"
  stage:         "Phase 3 - Development"
  cycleNumber:   9
  lastUpdateAt:  "2025-12-09T15:30:00+08:00"
  stateToken:    "sha256:abc123..."

可选字段（推荐）:
  lastUpdateRef: "git:1d475f5-任务描述"

格式要求:
  - YAML frontmatter (--- ... ---)
  - 位于文档开头
  - 字符串值用引号包围
  - 时间戳使用ISO 8601格式
```

### C. 变更历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 1.0.0-spec | 2025-12-09 | 初始UPMv2-STATE接口规范定义 |

---

**文档维护者**: Tech Lead + AI Development Team
**最后更新**: 2025-12-09
**规范版本**: v1.0.0
**适用标准**: ai-ddd-progress-management-core.md v1.0.0
