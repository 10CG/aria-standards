# Git 子模块工作流规范

> **Version**: 1.0.0
> **Status**: Active
> **Purpose**: 定义 Git 子模块的标准工作流程，确保多仓库协作的一致性

---

## 1. 概述

Git 子模块允许将一个 Git 仓库作为另一个仓库的子目录，同时保持提交历史的独立。本文档定义了子模块的标准工作流程。

---

## 2. Git 子模块基础

### 2.1 核心概念

```yaml
子模块机制:
  - 主仓库不存储子模块的实际代码
  - 主仓库只记录子模块的 commit 哈希值
  - 需要时从子模块仓库拉取对应版本的代码

关键文件:
  - .gitmodules: 子模块配置文件
  - .git/config: 本地子模块配置
  - .git/modules/: 子模块 Git 数据
```

### 2.2 配置文件示例

```ini
# .gitmodules
[submodule "module-name"]
    path = module-name
    url = https://git-server/org/module-name.git
    branch = main
```

---

## 3. 子模块操作

### 3.1 添加子模块

```bash
# 在主仓库中添加子模块
cd main-repo

# 添加子模块
git submodule add <repository-url> <path>

# 示例
git submodule add https://git-server/org/shared.git shared

# 提交子模块配置
git add .gitmodules shared
git commit -m "chore: 添加 shared 子模块"
git push origin main
```

### 3.2 克隆包含子模块的仓库

```bash
# 方法1：克隆时自动初始化子模块（推荐）
git clone --recurse-submodules <repository-url>

# 方法2：先克隆，再初始化子模块
git clone <repository-url>
cd repo-name
git submodule init
git submodule update

# 方法3：一次性初始化并更新
git submodule update --init --recursive
```

### 3.3 更新子模块

```bash
# 更新所有子模块到远程最新版本
git submodule update --remote --merge

# 更新特定子模块
git submodule update --remote <submodule-path>

# 查看子模块状态
git submodule status

# 进入子模块查看详情
cd <submodule-path>
git log -1
git branch
```

### 3.4 在子模块中开发

```bash
# 1. 进入子模块目录
cd <submodule-path>

# 2. 切换到开发分支（子模块默认是 detached HEAD）
git checkout main

# 3. 创建功能分支并开发
git checkout -b feature/my-feature
# 编辑代码...
git add .
git commit -m "feat: 新功能"
git push origin feature/my-feature

# 4. 回到主仓库，提交子模块引用更新
cd ..
git add <submodule-path>
git commit -m "chore: 更新子模块到最新版本"
git push origin main
```

### 3.5 删除子模块

```bash
# 1. 取消注册子模块
git submodule deinit <submodule-path>

# 2. 删除子模块目录
git rm <submodule-path>

# 3. 提交更改
git commit -m "chore: 移除子模块"

# 4. 清理 .git/modules 目录（可选）
rm -rf .git/modules/<submodule-path>
```

---

## 4. 日常开发工作流

### 4.1 场景1：在独立仓库中开发

```bash
# 1. 进入独立仓库目录
cd /path/to/module-repo

# 2. 确保在最新的主分支
git checkout main
git pull origin main

# 3. 创建功能分支
git checkout -b feature/new-feature

# 4. 开发并提交（多次提交）
# 编辑代码...
git add <files>
git commit -m "feat(module): 添加新功能"

# 5. 推送功能分支
git push origin feature/new-feature

# 6. 创建 Pull Request 并合并

# 7. 合并后更新本地
git checkout main
git pull origin main
```

### 4.2 场景2：使用子模块集成开发

```bash
# 1. 克隆主仓库（包含子模块）
git clone --recurse-submodules <main-repo-url>

# 2. 进入主仓库
cd main-repo

# 3. 查看子模块状态
git submodule status

# 4. 更新所有子模块到最新版本
git submodule update --remote --merge

# 5. 在子模块中工作
cd <submodule-path>
git checkout -b feature/my-feature
# 开发...
git commit -m "feat: 新功能"
git push origin feature/my-feature

# 6. 回到主仓库，提交子模块引用更新
cd ..
git add <submodule-path>
git commit -m "chore: 更新子模块到最新版本"
git push origin main
```

### 4.3 场景3：契约变更流程

```bash
# 1. 先更新共享契约仓库
cd shared-repo
git checkout develop
git pull origin develop
git checkout -b feature/new-api

# 编辑契约文件...
git add contracts/
git commit -m "feat(contracts): 添加新API定义"
git push origin feature/new-api
# PR合并后...

# 2. 实现后端
cd backend-repo
git checkout develop
git pull origin develop
git checkout -b feature/implement-api

# 编辑后端代码...
git add .
git commit -m "feat(backend): 实现新API"
git push origin feature/implement-api

# 3. 实现前端/移动端
cd frontend-repo
git checkout main
git pull origin main
git checkout -b feature/use-new-api

# 编辑前端代码...
git add .
git commit -m "feat(frontend): 集成新API"
git push origin feature/use-new-api
```

---

## 5. 双远程管理策略

### 5.1 远程配置规范

```bash
# 查看当前远程配置
git remote -v

# 标准配置示例
# origin: 主开发仓库（用于日常开发）
# mirror: 镜像仓库（用于备份/公开）

# 添加远程仓库
git remote add origin <primary-repo-url>
git remote add mirror <mirror-repo-url>

# 修改远程仓库URL
git remote set-url origin <new-url>
```

### 5.2 单向同步原则

```yaml
核心原则:
  - 主仓库是唯一的开发仓库
  - 镜像仓库仅作为只读镜像
  - 不接受镜像仓库上的直接提交或PR

日常操作:
  ✅ 正确:
    - git push origin feature/my-feature
    - git push origin main
    - git push mirror main  # 同步主分支到镜像

  ❌ 错误:
    - git push mirror feature/my-feature  # 不推送功能分支到镜像
```

### 5.3 子模块多远程同步

子模块作为独立仓库，各自拥有 origin + mirror 双远程。发版或合并到主分支后，
**必须将子模块推送到所有远程**，否则下游消费者 (如插件市场) 会获取到过期版本。

```yaml
触发时机:
  - 子模块 master/main 有新提交合并后
  - 主项目发版流程中更新子模块指针后

推送顺序 (先 origin 后 mirror):
  1. git -C <submodule> push origin master
  2. git -C <submodule> push github master    # mirror
  3. 主项目: git push origin master && git push github master

检查命令:
  # 查看子模块是否落后于 mirror
  git -C <submodule> log --oneline github/master..master
  # 输出为空 = 已同步; 有输出 = 需要推送
```

> **教训**: 2026-04-10 aria 插件 v1.11.1 发版后仅推送 Forgejo (origin)，
> 未推送 GitHub (mirror)，导致 Claude Code 插件市场停留在旧版本。

---

## 6. 分支管理

### 6.1 功能分支开发

```bash
# 创建功能分支
git checkout -b feature/my-feature

# 定期同步主分支更新
git fetch origin
git rebase origin/main  # 或 git merge origin/main

# 推送功能分支
git push origin feature/my-feature

# 功能完成后清理
git branch -d feature/my-feature  # 删除本地
git push origin --delete feature/my-feature  # 删除远程
```

### 6.2 分支命名规范

```yaml
分支类型:
  feature/{desc}: 新功能开发
  bugfix/{desc}: Bug修复
  hotfix/{desc}: 紧急修复
  release/{version}: 发布准备

示例:
  - feature/user-auth
  - bugfix/login-error
  - hotfix/security-patch
  - release/v1.2.0
```

---

## 7. 提交规范

### 7.1 Conventional Commits 格式

```bash
# 格式
<type>(<scope>): <subject>

# 示例
git commit -m "feat(auth): 添加用户认证功能"
git commit -m "fix(api): 修复响应超时问题"
git commit -m "docs(readme): 更新安装说明"
git commit -m "chore(deps): 更新依赖版本"
```

### 7.2 提交类型

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat(user): 添加用户注册` |
| `fix` | Bug修复 | `fix(auth): 修复登录失败` |
| `docs` | 文档更新 | `docs(api): 更新API文档` |
| `style` | 代码格式 | `style: 格式化代码` |
| `refactor` | 重构 | `refactor(db): 优化查询` |
| `test` | 测试 | `test(user): 添加单元测试` |
| `chore` | 构建/工具 | `chore: 更新子模块` |

---

## 8. 常见问题处理

### 8.1 子模块显示 "detached HEAD"

```bash
# 原因：子模块默认检出特定commit，不在分支上

# 解决方法
cd <submodule-path>
git checkout main  # 或其他目标分支
git pull origin main
```

### 8.2 子模块更新后主仓库未同步

```bash
# 在主仓库中
git add <submodule-path>
git commit -m "chore: 更新子模块引用"
git push origin main
```

### 8.3 撤销子模块更新

```bash
# 查看子模块引用历史
git log --oneline -- <submodule-path>

# 回退子模块到特定版本
cd <submodule-path>
git checkout <commit-hash>
cd ..
git add <submodule-path>
git commit -m "chore: 回退子模块到稳定版本"
```

### 8.4 克隆后子模块目录为空

```bash
# 初始化并更新子模块
git submodule init
git submodule update

# 或一次性完成
git submodule update --init --recursive
```

---

## 9. 最佳实践

### 9.1 应该做的 ✅

```yaml
频繁提交:
  - 每个提交只包含一个逻辑变更
  - 提交信息清晰描述变更内容

提交前检查:
  - git status  # 查看修改文件
  - git diff    # 查看具体修改

定期同步:
  - 每天开始工作前拉取最新代码
  - 每天结束工作后推送代码

子模块开发:
  - 在子模块中开发完成后更新主仓库引用
  - 使用标签标记重要版本
```

### 9.2 不应该做的 ❌

```yaml
避免:
  - 提交大文件（二进制、日志等）
  - 提交敏感信息（密码、密钥）
  - 直接在 main 分支上开发
  - 忘记初始化/更新子模块
  - 在镜像仓库上直接修改
```

---

## 10. 常用命令速查

### 10.1 子模块命令

```bash
# 添加子模块
git submodule add <url> <path>

# 初始化子模块
git submodule init

# 更新子模块
git submodule update
git submodule update --remote --merge

# 查看子模块状态
git submodule status

# 删除子模块
git submodule deinit <path>
git rm <path>
```

### 10.2 远程仓库命令

```bash
# 查看远程
git remote -v

# 添加远程
git remote add <name> <url>

# 删除远程
git remote remove <name>

# 修改远程URL
git remote set-url <name> <new-url>
```

### 10.3 分支命令

```bash
# 创建分支
git checkout -b <branch-name>

# 切换分支
git checkout <branch-name>

# 删除本地分支
git branch -d <branch-name>

# 删除远程分支
git push origin --delete <branch-name>

# 查看所有分支
git branch -a
```

---

## 11. Git 配置建议

### 11.1 全局配置

```bash
# 用户信息
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 默认分支
git config --global init.defaultBranch main

# 拉取时使用 rebase
git config --global pull.rebase true

# 子模块递归操作
git config --global submodule.recurse true

# 启用颜色输出
git config --global color.ui auto
```

### 11.2 常用别名

```bash
# 添加别名
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --graph --oneline --decorate"

# 子模块别名
git config --global alias.supdate "submodule update --remote --merge"
```

---

## 相关文档

- [Git Commit 规范](../conventions/git-commit.md)
- [AI 开发工作流](./ai-development-workflow.md)
- [分支管理指南](./branch-management-guide.md)

---

**Version**: 1.0.0
**Created**: 2025-12-14
**Maintainer**: AI-DDD Development Team
