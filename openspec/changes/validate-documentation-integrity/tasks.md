# Tasks: Validate Documentation Integrity

> **Change ID**: validate-documentation-integrity
> **Status**: Planned
> **Last Updated**: 2025-12-27

## Phase 1: 基础验证脚本

- [ ] 1.1 创建 @ 引用提取器
  - 从 .md 文件中提取所有 `@path/to/file` 格式的引用
  - 支持多种引用格式：`@docs/`, `@standards/`, `@.claude/`

- [ ] 1.2 创建路径存在性验证器
  - 验证提取的路径是否指向存在的文件
  - 输出失效引用列表

- [ ] 1.3 创建相对路径验证器
  - 验证 `../` 和 `./` 格式的相对路径
  - 考虑文件所在位置计算实际路径

## Phase 2: 模块专项验证

- [ ] 2.1 Agents 验证脚本 (validate-agents.sh)
  - 检查 .claude/agents/*.md 文件
  - 验证必需字段存在
  - 检查内部引用有效性

- [ ] 2.2 Skills 验证脚本 (validate-skills.sh)
  - 检查每个 skill 目录结构
  - 验证 SKILL.md frontmatter
  - 检查关联文件存在性 (EXAMPLES.md, TEMPLATES.md 等)

- [ ] 2.3 Standards 验证脚本 (validate-standards.sh)
  - 检查 standards/ 目录结构
  - 验证内部交叉引用
  - 检查版本号格式

## Phase 3: 综合验证与报告

- [ ] 3.1 创建综合验证入口 (validate-all.sh)
  - 调用所有模块验证脚本
  - 汇总验证结果
  - 生成统一报告

- [ ] 3.2 实现报告格式
  - 支持 Markdown 报告输出
  - 支持 JSON 格式输出（供 CI/CD 使用）
  - 分类展示：错误 / 警告 / 通过

## Phase 4: 配置与集成

- [ ] 4.1 创建配置文件支持
  - 定义 `.doc-validator.yaml` 配置格式
  - 支持忽略规则
  - 支持自定义验证规则

- [ ] 4.2 Git Hooks 集成
  - 提供 pre-commit hook 示例
  - 支持增量验证模式

## Phase 5: 文档与测试

- [ ] 5.1 编写使用文档
  - 命令行使用说明
  - 配置选项说明
  - 常见问题解答

- [ ] 5.2 创建测试用例
  - 准备测试数据
  - 验证各种边界情况

---

## 验收标准

| 阶段 | 验收标准 |
|------|---------|
| Phase 1 | 能够提取并验证所有 @ 引用 |
| Phase 2 | 三个模块验证脚本独立可运行 |
| Phase 3 | 综合报告清晰展示所有问题 |
| Phase 4 | 配置文件生效，hooks 可用 |
| Phase 5 | 文档完整，测试通过 |

## 依赖项

- Bash shell (或 PowerShell for Windows)
- grep/ripgrep
- Python 3.x (可选，用于复杂验证逻辑)

## 估算

| 阶段 | 复杂度 | 备注 |
|------|--------|------|
| Phase 1 | 低 | 基础文本处理 |
| Phase 2 | 中 | 需要理解各模块结构 |
| Phase 3 | 低 | 整合已有脚本 |
| Phase 4 | 中 | 配置解析和 hooks |
| Phase 5 | 低 | 文档编写 |
