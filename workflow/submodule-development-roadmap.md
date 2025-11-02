---
created_at: '2025-11-02'
updated_at: '2025-11-02'
classification: 开发规范
subcategory: 工作流程
status: active
version: 1.0.0
document_type: 开发路线图
priority_level: S级
---

# Todo App 子模块开发路线图

> **文档类型**: 开发规范
> **重要级别**: S级
> **创建时间**: 2025-11-02
> **适用范围**: 所有开发人员、AI 助手

## 📋 目录

1. [文档目的](#文档目的)
2. [核心原则](#核心原则)
3. [执行顺序总览](#执行顺序总览)
4. [Phase 1: 巩固基石 (standards)](#phase-1-巩固基石-standards)
5. [Phase 2: 搭建桥梁 (shared)](#phase-2-搭建桥梁-shared)
6. [Phase 3: 并行实现 (backend & mobile)](#phase-3-并行实现-backend--mobile)
7. [验收标准](#验收标准)
8. [常见问题](#常见问题)

---

## 文档目的

本文档定义了 Todo App 项目在完成多仓库架构拆分后，各子模块的**优先完善顺序**和**具体行动计划**。

在多仓库、子模块的架构下，明确的开发路线图至关重要。它能够：
- ✅ 避免无序开发导致的依赖混乱
- ✅ 最大化发挥"契约先行"架构的优势
- ✅ 实现 `backend` 和 `mobile` 的真正并行开发
- ✅ 确保所有模块都遵循统一的规范和流程

---

## 核心原则

子模块开发的优先级遵循以下核心原则：

### 1. 依赖关系优先 (Dependency-First)

```
standards (规则) → shared (契约) → backend & mobile (实现)
```

必须按照依赖链的顺序来完善模块，确保下游模块始终有清晰的上游定义可依赖。

### 2. 契约先行 (Contract-First)

任何涉及 `backend` 和 `mobile` 协作的功能，都**必须**先在 `shared` 模块中定义契约，然后才能开始实现。

### 3. 规范驱动 (Standard-Driven)

所有开发活动都应该遵循 `standards` 模块中定义的流程、模板和约定。

---

## 执行顺序总览

| 执行顺序 | 子模块 | 核心任务 | 预计工作量 | 状态 |
| :---: | :--- | :--- | :---: | :---: |
| **Phase 1** | `standards` | 完善并固化开发规范、流程和模板 | 2-3 天 | 🟡 进行中 |
| **Phase 2** | `shared` | 定义核心API契约、数据模型和常量 | 3-5 天 | ⚪ 待开始 |
| **Phase 3** | `backend` & `mobile` | 基于契约并行开发各自的功能 | 持续 | ⚪ 待开始 |

**关键里程碑**:
- ✅ **Milestone 1**: `standards` v1.0 发布 → 团队拥有统一的开发规范
- ⚪ **Milestone 2**: `shared` v1.0 发布 → 前后端拥有第一版稳定契约
- ⚪ **Milestone 3**: 第一个端到端 MVP 功能上线 → 验证架构可行性

---

## 风险控制与回退机制

### 为什么需要回退机制？

在探索新的开发模式（如 OpenSpec）或架构变更时，我们需要确保：
- ✅ 实验失败时能快速恢复到稳定状态
- ✅ 学习成果得以保留，即使不继续使用新方案
- ✅ 团队心理安全，敢于尝试创新

### 回退方案

#### 方案 A：Git 分支试验（推荐）⭐

**适用场景**: 在 standards 子模块试点新的组织方式（如 OpenSpec）

**操作步骤**:
```bash
# 1. 进入 standards 子模块
cd standards

# 2. 创建实验分支
git checkout -b experiment/openspec

# 3. 在实验分支上进行所有试点工作
# - 初始化 OpenSpec
# - 创建第一个变更提案
# - 评估效果

# 4. 评估结果
# 如果成功 → 合并到 master
git checkout master
git merge experiment/openspec
git tag v2.0.0-openspec
git push origin master --tags

# 如果失败 → 切回 master，删除实验分支
git checkout master
git branch -D experiment/openspec
# 零损失，继续使用传统方式
```

**优势**:
- ✅ **零风险**: master 分支保持稳定，随时可切回
- ✅ **保留历史**: 实验分支记录完整的探索过程
- ✅ **灵活决策**: 可以随时终止或继续实验

#### 方案 B：完全回退（如果已经在 master 分支试验）

**适用场景**: 已在 master 分支进行试点，需要撤销

**操作步骤**:
```bash
cd standards

# 查看提交历史，找到需要回退到的提交
git log --oneline -10

# 选项1: 硬回退（完全删除试验提交）
git reset --hard <commit-hash>
git push --force origin master
# ⚠️ 警告：这会丢失试验期间的所有提交

# 选项2: 软回退（保留代码改动，撤销提交）
git reset --soft <commit-hash>
git status  # 可以看到改动还在
# 可以选择性地保留有用的内容

# 选项3: Revert（创建新提交撤销）
git revert <commit-hash>
git push origin master
# ✅ 推荐：保留完整历史，包括回退记录
```

**选择建议**:
- 如果是个人仓库且确定不需要保留 → 使用选项1
- 如果想保留部分有用内容 → 使用选项2
- 如果是团队仓库或需要审计追踪 → 使用选项3

#### 方案 C：保留学习成果（部分采纳）

**适用场景**: OpenSpec 试点中发现部分有价值的思路，但不完全采用

**操作步骤**:
```bash
# 不完全回退，而是选择性保留

# 1. 保留有价值的文档
mkdir -p docs/references/
cp openspec/AGENTS.md docs/references/openspec-learnings.md
cp openspec/project.md docs/references/project-context.md

# 2. 删除 OpenSpec 结构
rm -rf openspec/

# 3. 按传统方式重组
# 但融入从 OpenSpec 学到的理念（如 Delta 机制、变更隔离等）

# 4. 提交保留的成果
git add docs/references/
git commit -m "docs: 保留 OpenSpec 试点中的学习成果作为参考"
```

### 回退时机判断

**何时应该考虑回退？**

| 信号 | 说明 | 建议 |
|------|------|------|
| AI 生成 Delta 错误率 > 30% | OpenSpec 的核心机制不适配当前 AI | 🔴 考虑回退 |
| 团队理解成本 > 2 天 | 新方式学习曲线太陡 | 🟡 简化或回退 |
| 工具链频繁出错 | OpenSpec CLI 或验证工具不稳定 | 🟡 暂缓，等工具成熟 |
| 发现更优方案 | 在试验中发现了更好的组织方式 | 🟢 调整方向，不一定回退 |
| 试点成功但不适合全面推广 | 小范围有效，但不适合整个项目 | 🟢 局部保留，其他区域使用传统方式 |

### 回退后的行动

**即使回退，也要总结经验**:

1. **记录试点报告**: 创建 `docs/experiment-reports/openspec-pilot-YYYY-MM-DD.md`
   - 试点目标
   - 实际效果
   - 失败/成功原因
   - 可保留的思路

2. **提取有价值的概念**:
   - 即使不用 OpenSpec，Delta 思维可能仍有价值
   - 变更隔离的理念可以用其他方式实现

3. **更新决策记录**: 在 `docs/architecture-decisions/` 记录为什么选择回退

---

## Phase 1: 巩固基石 (standards)

### 为什么优先做这个？

`standards` 模块是项目的"宪法"。如果规则不清晰，后续的所有工作都会产生混乱和不一致。我们必须先确保拥有一套稳定、可执行的开发流程。

### 关键产出

- [ ] **核心规范审查完成**: 七步循环、AI 工作流协议等核心文档已审核并定稿
- [ ] **规范变更流程定义**: 建立了一套修改和演进规范本身的流程
- [ ] **核心模板就绪**: 至少完成 3 个核心模板（PR 模板、Spec 模板、README 模板）
- [ ] **自动化工具原型**: 至少实现 1 个自动化验证工具（如 commit message linter）

### 具体行动清单

#### 1.1 审查并最终确定核心规范

**目标**: 确保现有规范完整、准确、可执行

**检查清单**:
- [ ] 阅读 `core/seven-step-cycle/README.md`，确认七步循环的定义是否完整
- [ ] 阅读 `workflow/ai-workflow-protocol.md`，确认 AI 协作流程是否清晰
- [ ] 识别缺失或不清晰的部分，进行补充或澄清
- [ ] 在团队（或与 AI）中进行一次"规范演练"，确保可执行性

**验收标准**:
- ✅ 所有核心规范文档无 `[TODO]` 或 `[NEEDS CLARIFICATION]` 标记
- ✅ 能够向新成员（或新的 AI 助手）清晰解释完整的开发流程

#### 1.2 定义"规范的变更流程"

**目标**: 让规范本身也可以安全、有序地演进

**任务**:
1. 在 `workflow/` 目录下创建 `standards-evolution-process.md` 文档
2. 定义以下流程：
   - 谁可以提议修改规范？
   - 修改提议如何审核？
   - 如何确保修改不破坏现有工作流？
   - 如何通知所有相关人员规范已更新？

**示例流程**:
```
1. 在 standards 仓库创建 issue，描述提议的变更和理由
2. 创建 feature 分支，修改相关文档
3. 提交 PR，标题格式：[STANDARD-CHANGE] <变更描述>
4. 至少 1 人审核通过（如果是团队）或 AI 验证通过
5. 合并后，更新 standards/CHANGELOG.md
6. 通知所有子模块更新 standards 子模块引用
```

#### 1.3 补充核心模板 (`templates/`)

**目标**: 为常见的文档和流程提供标准模板

**必须创建的模板**:

1.  **Pull Request 模板** (`templates/pull-request-template.md`):
    ```markdown
    ## 变更类型
    - [ ] feat: 新功能
    - [ ] fix: Bug 修复
    - [ ] docs: 文档更新
    - [ ] refactor: 重构
    - [ ] chore: 构建/工具

    ## 变更描述
    [简要描述本次变更]

    ## 测试
    - [ ] 已通过所有现有测试
    - [ ] 已添加新测试（如适用）

    ## 检查清单
    - [ ] 代码符合项目规范
    - [ ] 已更新相关文档
    - [ ] Commit 信息符合规范
    ```

2.  **功能规范模板** (`templates/feature-spec-template.md`):
    参考 OpenSpec 或 Spec-Kit 的格式，定义一个轻量级的功能规范模板。

3.  **README 模板** (`templates/readme-template.md`):
    定义子模块 README 的标准结构（项目简介、安装、使用、开发、贡献等）。

**验收标准**:
- ✅ `templates/` 目录至少包含 3 个可用模板
- ✅ 每个模板都有清晰的使用说明

#### 1.4 构思自动化工具 (`tools/`)

**目标**: 将能自动化的规范检查自动化

**优先级工具列表**:

1.  **Commit Message Linter** (`tools/commit-msg-lint.sh`):
    - 检查 commit 信息是否符合 Conventional Commits 规范
    - 可以作为 Git pre-commit hook 使用

2.  **Schema Validator** (`tools/validate-schemas.py`):
    - 验证 `shared/schemas/` 中的 JSON Schema 文件是否格式正确
    - 可以在 CI 中运行

3.  **OpenAPI Linter** (`tools/validate-openapi.sh`):
    - 验证 `shared/contracts/openapi/` 中的 OpenAPI 文件是否符合规范
    - 可以在 CI 中运行

**Phase 1 行动**: 至少实现其中的 **Commit Message Linter**，其他工具可以在后续迭代中完成。

**验收标准**:
- ✅ `tools/commit-msg-lint.sh` 已创建并可正常工作
- ✅ 该工具已集成到主仓库和至少一个子模块的 Git hooks 中

### Phase 1 完成标志

- ✅ 所有核心规范文档已审核并定稿
- ✅ 规范变更流程已定义并文档化
- ✅ 至少 3 个核心模板已创建
- ✅ 至少 1 个自动化工具已实现并集成
- ✅ `standards` 子模块打上 `v1.0.0` 标签并推送到远程

**预计耗时**: 2-3 天

---

## Phase 2: 搭建桥梁 (shared)

### 为什么第二步做这个？

`shared` 模块是 `mobile` 和 `backend` 之间的"通用语言"和"法律合同"。只有这份合同清晰无误，两个团队才能真正地并行开发而不会互相等待或产生误解。

### 关键产出

- [ ] **核心数据模型定义**: 至少完成 `Task` 和 `User` 的 JSON Schema
- [ ] **V1 版本 API 契约**: 定义出 5-10 个核心 API 端点
- [ ] **通用常量定义**: 定义任务状态、优先级等枚举值
- [ ] **代码生成策略确定**: 明确如何从 Schema 生成 Dart/Python 代码

### 具体行动清单

#### 2.1 完善核心数据模型 (`schemas/`)

**目标**: 定义项目中最重要的业务实体

**必须完成的 Schema**:

1.  **Task Schema** (`schemas/task.schema.json`):
    ```json
    {
      "$schema": "http://json-schema.org/draft-07/schema#",
      "$id": "https://example.com/task.schema.json",
      "title": "Task",
      "description": "A task in the todo application",
      "type": "object",
      "required": ["id", "title", "status"],
      "properties": {
        "id": {
          "type": "string",
          "format": "uuid",
          "description": "Unique identifier for the task"
        },
        "title": {
          "type": "string",
          "minLength": 1,
          "maxLength": 200,
          "description": "Title of the task"
        },
        "description": {
          "type": "string",
          "maxLength": 2000,
          "description": "Detailed description"
        },
        "status": {
          "type": "string",
          "enum": ["PENDING", "IN_PROGRESS", "COMPLETED", "ARCHIVED"],
          "description": "Current status of the task"
        },
        "priority": {
          "type": "string",
          "enum": ["LOW", "NORMAL", "HIGH", "URGENT"],
          "description": "Priority level"
        },
        "created_at": {
          "type": "string",
          "format": "date-time"
        },
        "updated_at": {
          "type": "string",
          "format": "date-time"
        }
      }
    }
    ```

2.  **User Schema** (`schemas/user.schema.json`):
    定义用户的基本信息（id, username, email 等）

**验收标准**:
- ✅ `schemas/task.schema.json` 已创建并通过 Schema Validator 验证
- ✅ `schemas/user.schema.json` 已创建并通过 Schema Validator 验证

#### 2.2 定义 V1 版本的核心 API (`contracts/`)

**目标**: 使用 OpenAPI 格式定义第一批核心 API

**必须完成的 API 端点** (`contracts/openapi/tasks.yaml`):

```yaml
openapi: 3.0.3
info:
  title: Todo App API
  version: 1.0.0
  description: Core API for Todo App

servers:
  - url: http://localhost:8000/api/v1
    description: Development server

paths:
  /tasks:
    get:
      summary: Get all tasks
      operationId: listTasks
      tags:
        - tasks
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [PENDING, IN_PROGRESS, COMPLETED, ARCHIVED]
      responses:
        '200':
          description: List of tasks
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Task'

    post:
      summary: Create a new task
      operationId: createTask
      tags:
        - tasks
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/TaskCreate'
      responses:
        '201':
          description: Task created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Task'

  /tasks/{taskId}:
    get:
      summary: Get a task by ID
      operationId: getTask
      tags:
        - tasks
      parameters:
        - name: taskId
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Task details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Task'
        '404':
          description: Task not found

components:
  schemas:
    Task:
      # 引用 schemas/task.schema.json 的定义
      type: object
      # ... (与 JSON Schema 保持一致)

    TaskCreate:
      type: object
      required: [title]
      properties:
        title:
          type: string
        description:
          type: string
        priority:
          type: string
          enum: [LOW, NORMAL, HIGH, URGENT]
```

**验收标准**:
- ✅ `contracts/openapi/tasks.yaml` 已创建并通过 OpenAPI Linter 验证
- ✅ 至少定义了 5 个核心端点（list, create, get, update, delete）

#### 2.3 确定通用常量 (`constants/`)

**目标**: 定义全局常量和枚举值

**文件**: `constants/app_constants.json`

```json
{
  "task_statuses": {
    "PENDING": "待处理",
    "IN_PROGRESS": "进行中",
    "COMPLETED": "已完成",
    "ARCHIVED": "已归档"
  },
  "task_priorities": {
    "LOW": "低",
    "NORMAL": "普通",
    "HIGH": "高",
    "URGENT": "紧急"
  },
  "api_version": "1.0.0",
  "default_page_size": 20,
  "max_page_size": 100
}
```

**验收标准**:
- ✅ `constants/app_constants.json` 已创建
- ✅ 常量值与 Schema 和 OpenAPI 定义保持一致

#### 2.4 研究并确定代码生成策略

**目标**: 确定如何从 Schema 自动生成 Dart 和 Python 代码

**研究方向**:

1.  **Dart 代码生成**:
    - 工具选项: `json_serializable`, `freezed`, 或自定义脚本
    - 决策: 选择哪个工具？为什么？

2.  **Python 代码生成**:
    - 工具选项: `dataclasses-json`, `pydantic`, 或自定义脚本
    - 决策: 选择哪个工具？为什么？

3.  **OpenAPI 客户端生成**:
    - 工具选项: `openapi-generator`, `swagger-codegen`
    - 是否需要为 `mobile` 生成 API 客户端代码？

**行动**:
1. 调研以上工具
2. 在 `shared/src/dart/` 和 `shared/src/python/` 中创建示例代码
3. 在 `shared/README.md` 中文档化选择的策略和使用方法

**验收标准**:
- ✅ 已选定代码生成工具并文档化
- ✅ 已创建示例代码，验证策略可行性

### Phase 2 完成标志

- ✅ 核心数据模型 Schema 已定义并验证
- ✅ V1 版本 API 契约已定义并验证
- ✅ 通用常量已定义
- ✅ 代码生成策略已确定并文档化
- ✅ `shared` 子模块打上 `v1.0.0` 标签并推送到远程

**预计耗时**: 3-5 天

---

## Phase 3: 并行实现 (backend & mobile)

### 为什么最后做这个？

因为现在"规则"（`standards`）和"合同"（`shared`）都已经就位，`backend` 和 `mobile` 团队可以放心地、独立地、并行地进行开发。

### 开发原则

- ✅ **所有开发必须基于 `shared` 中定义的契约**
- ✅ **不得擅自修改 `shared` 中的定义**（如需修改，必须先在 `shared` 中提 PR 并合并）
- ✅ **使用 Mock 数据实现前后端分离开发**

### Backend 模块行动清单

#### 3.1 实现 API

**任务**:
1. 根据 `shared/contracts/openapi/tasks.yaml` 实现所有定义的端点
2. 使用 `shared/schemas/` 中的定义来设计数据库表结构
3. 确保 API 响应格式与契约完全一致

**技术栈**: Python + FastAPI + PostgreSQL

**验收标准**:
- ✅ 所有 API 端点已实现
- ✅ API 响应通过契约测试（Contract Testing）
- ✅ 单元测试覆盖率 > 80%

#### 3.2 构建数据库

**任务**:
1. 根据 `shared/schemas/task.schema.json` 创建 `tasks` 表
2. 根据 `shared/schemas/user.schema.json` 创建 `users` 表
3. 编写数据库迁移脚本

**验收标准**:
- ✅ 数据库 schema 与 `shared/schemas/` 保持一致
- ✅ 迁移脚本可以正常执行

#### 3.3 编写测试

**任务**:
1. 为每个 API 端点编写单元测试
2. 编写集成测试，验证完整的请求-响应流程
3. 使用工具（如 `openapi-spec-validator`）验证 API 实现与契约的一致性

**验收标准**:
- ✅ 所有测试通过
- ✅ 契约测试通过

### Mobile 模块行动清单

#### 3.4 搭建 UI 框架

**任务**:
1. 创建核心页面（任务列表、任务详情、创建任务等）
2. 创建通用组件（按钮、卡片、表单等）

**技术栈**: Flutter + Dart

**验收标准**:
- ✅ 核心页面框架已搭建
- ✅ UI 组件库初步完成

#### 3.5 开发客户端服务

**任务**:
1. 根据 `shared/contracts/openapi/tasks.yaml` 编写网络请求代码
2. 使用代码生成工具（如果已确定）自动生成 API 客户端
3. 创建数据仓库层（Repository），封装网络请求

**验收标准**:
- ✅ API 客户端已实现
- ✅ 数据仓库层已完成

#### 3.6 使用共享模型

**任务**:
1. 使用代码生成工具从 `shared/schemas/` 生成 Dart 模型类
2. 确保模型类与后端返回的数据格式完全一致

**验收标准**:
- ✅ Dart 模型类已生成
- ✅ 模型类可以正确序列化/反序列化 JSON

#### 3.7 Mock 开发

**任务**:
1. 在后端 API 尚未完成时，创建一个本地 Mock Server
2. Mock Server 返回的数据格式必须符合 `shared/contracts/` 中的定义

**工具**: `json-server`, `mockoon`, 或自定义 Mock

**验收标准**:
- ✅ Mock Server 已搭建并可正常运行
- ✅ `mobile` 可以使用 Mock Server 进行独立开发和测试

### Phase 3 完成标志

- ✅ `backend` 实现了所有 V1 API 端点，并通过契约测试
- ✅ `mobile` 实现了核心 UI 和数据层，可以与 `backend` 或 Mock Server 交互
- ✅ **第一个端到端的功能可以跑通**（例如：创建任务 → 显示任务列表 → 查看任务详情）

**预计耗时**: 持续迭代

---

## 验收标准

### Phase 1 验收标准

- [ ] `standards` 子模块已打 `v1.0.0` 标签
- [ ] 核心规范文档无遗留问题
- [ ] 至少 3 个模板已创建
- [ ] 至少 1 个自动化工具已实现

### Phase 2 验收标准

- [ ] `shared` 子模块已打 `v1.0.0` 标签
- [ ] 核心数据模型 Schema 已完成
- [ ] V1 API 契约已定义
- [ ] 代码生成策略已确定

### Phase 3 验收标准

- [ ] 第一个端到端功能可以正常运行
- [ ] `backend` 所有 API 通过契约测试
- [ ] `mobile` 可以成功调用 `backend` API

---

## 常见问题

### Q1: 如果在 Phase 3 发现 `shared` 中的契约定义有问题怎么办？

**A**: 立即在 `shared` 仓库中提出修改 PR，合并后，`backend` 和 `mobile` 同步更新 `shared` 子模块引用。**绝不**在各自的仓库中独立修改契约定义。

### Q2: Phase 1 和 Phase 2 可以并行进行吗？

**A**: 不建议。`shared` 中的契约定义应该遵循 `standards` 中的规范（例如，Schema 的命名约定、API 端点的设计原则等）。如果 `standards` 还未稳定，`shared` 的定义可能需要返工。

### Q3: 如果我是一个人同时开发 `backend` 和 `mobile`，还需要这么严格的流程吗？

**A**: 是的。即使是一个人，遵循这个流程也能：
- 避免前后端定义不一致导致的 Bug
- 让 AI 助手更好地理解你的意图和上下文
- 为未来可能加入的团队成员提供清晰的协作基础

---

**最后更新**: 2025-11-02
**维护者**: 技术团队
**版本**: v1.0.0
