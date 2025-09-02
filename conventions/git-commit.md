# Git提交消息规范

## 提交前缀

- `feat`: 新功能
- `fix`: 错误修复
- `docs`: 文档更新
- `test`: 测试相关
- `perf`: 性能优化
- `style`: 代码格式
- `refactor`: 重构
- `chore`: 构建/工具
- `ci`: 持续集成

## 格式结构

```
<type>(<scope>): <subject>

<body>

<footer>
```

## 示例

```
feat(auth): 添加OAuth登录支持

- 集成GitHub OAuth
- 添加用户认证流程
- 实现token管理

Closes #123
```
