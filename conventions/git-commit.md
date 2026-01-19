# Git Commit 规范

> **Version**: 2.1.0
> **Status**: Active
> **Based on**: Conventional Commits + AI-DDD Enhanced Markers

---

## 1. 提交消息格式

### 1.1 基本结构

```
<type>(<scope>): <中文描述> / <English description>

<body>

[Enhanced Markers - 可选]

<footer>
```

### 1.2 Subject 行规范

| 组件 | 必需 | 说明 |
|------|------|------|
| `type` | ✅ | 变更类型 |
| `scope` | ⚠️ 推荐 | 影响范围 |
| `中文描述` | ✅ | 简洁中文说明 |
| `English description` | ✅ | 简洁英文说明 |

**格式要求**:
- 使用祈使语气 (动词原形)
- 不超过 72 字符
- 结尾不加句号
- 首字母小写 (英文部分)

---

## 2. Type 类型定义

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat(auth): 添加JWT认证 / Add JWT authentication` |
| `fix` | Bug修复 | `fix(api): 修复token过期问题 / Fix token expiration issue` |
| `docs` | 文档变更 | `docs(readme): 更新安装说明 / Update installation guide` |
| `style` | 代码格式 | `style: 统一代码缩进 / Unify code indentation` |
| `refactor` | 重构 | `refactor(service): 优化API结构 / Optimize API structure` |
| `perf` | 性能优化 | `perf(db): 添加查询索引 / Add query indexes` |
| `test` | 测试相关 | `test(auth): 添加登录测试 / Add login tests` |
| `build` | 构建/依赖 | `build: 升级Flutter到3.x / Upgrade Flutter to 3.x` |
| `ci` | CI配置 | `ci: 更新GitHub Actions / Update GitHub Actions` |
| `chore` | 其他杂项 | `chore: 更新.gitignore / Update .gitignore` |

---

## 3. Scope 范围定义

### 3.1 模块级 Scope

| Scope | 说明 |
|-------|------|
| `backend` | 后端服务 |
| `mobile` | 移动应用 |
| `shared` | 共享契约 |
| `standards` | 开发规范 |
| `docs` | 文档系统 |

### 3.2 功能级 Scope

| Scope | 说明 |
|-------|------|
| `auth` | 认证相关 |
| `api` | API接口 |
| `db` | 数据库 |
| `ui` | 用户界面 |
| `test` | 测试 |
| `config` | 配置 |

### 3.3 特殊 Scope

| Scope | 说明 |
|-------|------|
| `submodule` | 子模块更新 |
| `deps` | 依赖更新 |
| `openspec` | OpenSpec相关 |
| `architecture` | 架构文档 |

---

## 4. Body 正文规范

### 4.1 格式要求

- 与 Subject 之间空一行
- 每行不超过 72 字符
- 使用列表说明具体变更
- 解释 "为什么" 而非 "是什么"

### 4.2 示例

```
feat(backend): 实现用户认证服务 / Implement user authentication service

实现基于JWT的用户认证系统：

- 创建AuthService处理认证逻辑
- 实现token生成和验证
- 添加refresh token机制
- 配置token过期策略

选择JWT而非Session的原因：
- 支持无状态服务扩展
- 移动端友好
- 跨域支持更好
```

---

## 5. Enhanced Markers (增强标记)

### 5.1 何时使用

| 场景 | 使用增强标记 | 说明 |
|------|-------------|------|
| 跨模块提交 | ✅ 必须 | strategic-commit-orchestrator |
| 批量文档提交 | ✅ 必须 | strategic-commit-orchestrator |
| Phase/Cycle里程碑 | ✅ 必须 | strategic-commit-orchestrator |
| 单模块简单变更 | ❌ 不需要 | commit-msg-generator |
| 单文件Bug修复 | ❌ 不需要 | commit-msg-generator |

### 5.2 标记格式

```
🤖 Executed-By: {subagent_type} subagent

📋 Context: {Phase}-{Cycle} {context}

🔗 Module: {module_name}
```

**格式要求**:
- 每个标记单独一行
- 标记之间空一行
- `Executed-By` 必须以 "subagent" 结尾
- `Context` 使用单空格分隔 (非 " - ")
- `Module` 使用小写

### 5.3 可用 Subagent 类型

| Subagent | 使用场景 |
|----------|---------|
| `knowledge-manager` | 文档、架构文档 |
| `backend-architect` | 后端代码、API |
| `mobile-developer` | Flutter/Dart代码 |
| `api-documenter` | API文档、OpenAPI |
| `qa-engineer` | 测试代码 |
| `tech-lead` | 技术决策、重构 |
| `general-purpose` | 通用任务 |

### 5.4 完整示例

```
feat(backend): 实现聊天API端点 / Implement chat API endpoint

实现WebSocket聊天功能的后端API：

- 创建ChatService处理聊天逻辑
- 实现消息持久化
- 添加单元测试

🤖 Executed-By: backend-architect subagent

📋 Context: Phase3-Cycle5 backend-api-development

🔗 Module: backend

Closes #456
```

---

## 6. Footer 页脚规范

### 6.1 Issue 关联

```
Closes #123          # 关闭Issue
Fixes #456           # 修复Issue
Refs #789            # 引用Issue
```

### 6.2 Spec 关联

```
Spec: standards/openspec/changes/{feature}/spec.md
```

### 6.3 Breaking Changes

```
BREAKING CHANGE: API响应格式变更

原格式: { data: {...} }
新格式: { success: true, data: {...} }
```

---

## 7. Skill 选择指南

### 7.1 决策树

```
需要分组提交？
  ├─ 是 (跨模块/批量文档/里程碑)
  │   └─ 使用 strategic-commit-orchestrator
  │       - 智能分组变更
  │       - 添加增强标记
  │       - 并行/串行执行
  │
  └─ 否 (单模块/简单变更)
      └─ 使用 commit-msg-generator
          - 标准格式
          - 简洁高效
```

### 7.2 场景对照

| 场景 | 推荐 Skill |
|------|-----------|
| 单文件Bug修复 | commit-msg-generator |
| 单模块功能开发 | commit-msg-generator |
| Backend + Shared API变更 | strategic-commit-orchestrator |
| 批量架构文档创建 | strategic-commit-orchestrator |
| Phase/Cycle里程碑 | strategic-commit-orchestrator |

### 7.3 新工作流程相关提交

#### TDD 相关提交

当使用 TDD Enforcer 进行测试驱动开发时：

```bash
# RED Phase - 编写测试
test(auth): 添加用户登录失败测试 / Add login failure test

创建失败测试用例：
- 测试用户名为空时抛出异常
- 测试密码错误时返回401

TDD Phase: RED
```

```bash
# GREEN Phase - 最小实现
feat(auth): 实现基础用户验证 / Implement basic user validation

最小实现使测试通过：
- 添加用户名验证逻辑
- 添加密码验证逻辑
- 返回401状态码

TDD Phase: GREEN
```

```bash
# REFACTOR Phase - 代码重构
refactor(auth): 提取验证器为独立类 / Extract validator as separate class

重构代码结构：
- 创建UserValidator类
- 移动验证逻辑
- 保持测试通过

TDD Phase: REFACTOR
```

#### Hooks 相关提交

Hooks 系统相关变更使用特殊 scope：

```bash
# Hooks 配置更新
chore(hooks): 添加 session-start 环境检查 / Add session-start env check

更新hooks.json配置：
- 添加Git状态检查
- 添加依赖验证

Ref: aria/hooks/hooks.json
```

#### Auto-Trigger 相关提交

trigger-rules.json 更新：

```bash
chore(trigger): 添加"重构"关键词映射 / Add "refactor" keyword mapping

更新自动触发规则：
- 添加"重构"→arch-update映射
- 添加上下文加成规则

Ref: .claude/trigger-rules.json
```

#### 两阶段评审相关提交

完成 Phase B.2 两阶段评审：

```bash
chore(review): 通过规范合规性和代码质量评审 / Pass spec compliance and code quality review

Phase 1 - 规范合规性: ✅ 通过
  - OpenSpec格式正确
  - UPM已同步
  - 架构文档已更新

Phase 2 - 代码质量: ✅ 通过
  - 测试覆盖率≥85%
  - 无安全漏洞
  - 代码复杂度正常

Ref: .claude/skills/phase-b-developer/validators/

---

## 8. 禁止规则

### 8.1 绝对禁止

```yaml
❌ 禁止添加 AI 生成签名:
   - "🤖 Generated with [Claude Code]..."
   - "Co-Authored-By: Claude..."

❌ 禁止使用模糊消息:
   - "update"
   - "fix bug"
   - "WIP"
   - "misc changes"

❌ 禁止违反格式:
   - "Added new feature"     # 错误: 过去式+大写
   - "feat: add feature."    # 错误: 结尾句号
   - "FEAT(auth): Add..."    # 错误: type大写
```

### 8.2 应该避免

```yaml
⚠️ 避免过大的单次提交:
   - 50+ 文件变更应考虑拆分

⚠️ 避免混合不同类型的变更:
   - feat + fix 应分开提交

⚠️ 避免无意义的 scope:
   - "feat(stuff): ..."
   - "fix(misc): ..."
```

---

## 9. 示例库

### 9.1 简单模式 (commit-msg-generator)

```
# 功能开发
feat(auth): 添加OAuth登录支持 / Add OAuth login support

集成GitHub OAuth认证：
- 添加OAuth配置
- 实现回调处理
- 存储用户token

Closes #123
```

```
# Bug修复
fix(mobile): 修复列表滚动卡顿 / Fix list scroll lag

优化ListView渲染性能：
- 添加itemExtent固定高度
- 使用const构造器
- 移除不必要的rebuild

Fixes #456
```

### 9.2 增强模式 (strategic-commit-orchestrator)

```
docs(architecture): 创建后端架构文档 / Create backend architecture docs

创建后端L0和L1架构文档：
- L0: be-ref-architecture-overview.md
- L1: be-arch-api-layer.md
- L1: be-arch-service-layer.md
- L1: be-arch-data-layer.md

🤖 Executed-By: knowledge-manager subagent

📋 Context: Phase2-Cycle3 architecture-documentation

🔗 Module: backend

Refs: standards/openspec/changes/backend-arch/spec.md
```

---

## 10. 快速参考

### 10.1 检查清单

提交前确认:
- [ ] Type 正确
- [ ] Scope 合适
- [ ] Subject 双语
- [ ] Body 解释原因
- [ ] 无 AI 签名
- [ ] 关联 Issue/Spec

### 10.2 常用命令

```bash
# 标准提交
git commit -m "feat(scope): 中文 / English"

# 带 Body 的提交 (使用 HEREDOC)
git commit -m "$(cat <<'EOF'
feat(scope): 中文描述 / English description

详细说明...

Closes #123
EOF
)"

# 修改上次提交
git commit --amend
```

---

## 相关文档

- [Ten-Step Cycle - Phase C](../core/ten-step-cycle/phase-c-integration.md)
- [Branch Management Guide](../workflow/branch-management-guide.md)
- [commit-msg-generator Skill](../../.claude/skills/commit-msg-generator/)
- [strategic-commit-orchestrator Skill](../../.claude/skills/strategic-commit-orchestrator/)

---

**Version**: 2.1.0
**Created**: 2025-12-13
**Updated**: 2026-01-20
**Maintainer**: AI-DDD Development Team
