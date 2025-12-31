# Tasks: Validate Documentation Integrity

> **Change ID**: validate-documentation-integrity
> **Status**: Completed
> **Last Updated**: 2025-12-27

## Phase 1: Skill 基础结构

- [x] 1.1 创建 Skill 目录结构
  - 创建 `.claude/skills/doc-integrity-validator/`
  - 创建 SKILL.md (核心定义)
  - 创建 EXAMPLES.md (使用示例)

- [x] 1.2 定义 Skill 接口
  - 输入参数设计 (扫描范围、验证级别)
  - 输出格式设计 (验证报告结构)
  - 交互模式设计 (检测 → 确认 → 修复)

## Phase 2: 路径有效性验证

- [x] 2.1 @ 引用提取器
  - 扫描 `.claude/agents/*.md`
  - 扫描 `.claude/skills/*/SKILL.md`
  - 扫描 `.claude/commands/*.md`
  - 提取所有 `@path/to/file` 格式引用

- [x] 2.2 路径解析与验证
  - 将 @ 路径解析为实际文件路径
  - 验证文件存在性
  - 处理 Windows/Linux 路径格式差异

- [x] 2.3 错误报告生成
  - 生成失效引用列表
  - 标注文件位置和行号
  - 提供可能的正确路径建议

## Phase 3: 层级合规性验证

- [x] 3.1 层级规则定义
  - 定义通用级资源: `@.claude/*`, `@standards/*`
  - 定义项目级资源: `@docs/*`
  - 定义可移植组件: Skills, Agents, Commands

- [x] 3.2 层级违规检测
  - 检测 Skills/Agents 中的 `@docs/*` 引用
  - 标记违规位置
  - 计算违规严重程度

- [x] 3.3 迁移建议生成
  - 分析项目级引用内容
  - 建议迁移到通用级路径
  - 或建议使用相对路径引用

## Phase 4: 语义完整性验证 (LLM)

- [x] 4.1 上下文分析
  - 读取组件描述和用途
  - 读取引用文档内容摘要
  - 构建验证提示词

- [x] 4.2 LLM 相关性评估
  - 调用 LLM 分析引用相关性
  - 检测过时或无关的引用
  - 检测缺失的必要引用

- [x] 4.3 智能建议生成
  - 生成引用优化建议
  - 推荐替代文档
  - 建议补充引用

## Phase 5: 交互修复系统

- [x] 5.1 报告格式化
  - 分类展示: 错误 / 警告 / 建议
  - Markdown 格式输出
  - 支持摘要视图和详细视图

- [x] 5.2 交互确认流程
  - 逐项展示问题和建议
  - 用户选择: 接受 / 修改 / 跳过
  - 批量操作支持

- [x] 5.3 自动修复执行
  - 执行用户确认的修复
  - 更新文件内容
  - 生成变更摘要

## Phase 6: 配置与文档

- [x] 6.1 配置文件支持
  - 创建 `.doc-validator.yaml` 配置模板
  - 支持路径忽略规则
  - 支持规则严格程度配置

- [x] 6.2 使用文档编写
  - Skill 调用说明
  - 配置选项说明
  - 使用示例

---

## 验收标准

| 阶段 | 验收标准 | 状态 |
|------|---------|------|
| Phase 1 | Skill 目录结构完整，可被 Claude Code 识别 | ✅ |
| Phase 2 | 能够检测所有失效的 @ 引用路径 | ✅ |
| Phase 3 | 能够检测 Skills/Agents 中的层级违规 | ✅ |
| Phase 4 | LLM 能够分析引用的语义相关性 | ✅ |
| Phase 5 | 用户确认后能够自动修复问题 | ✅ |
| Phase 6 | 配置和文档完整，可供其他项目参考 | ✅ |

## 实现产物

```
.claude/skills/doc-integrity-validator/
├── SKILL.md           # 核心 Skill 定义和使用说明
├── EXAMPLES.md        # 详细使用示例
├── EXECUTION.md       # 执行流程指南
└── VALIDATION_LOGIC.md # 验证规则详细说明

.doc-validator.yaml    # 项目级配置模板
```

## 依赖项

- Claude Code 运行时环境
- LLM API 访问 (用于语义验证)
- 文件系统读写权限

## 复杂度评估

| 阶段 | 复杂度 | 备注 |
|------|--------|------|
| Phase 1 | 低 | Skill 结构标准化 |
| Phase 2 | 低 | 正则提取 + 文件检查 |
| Phase 3 | 中 | 规则引擎设计 |
| Phase 4 | 高 | LLM 提示词工程 |
| Phase 5 | 中 | 交互流程设计 |
| Phase 6 | 低 | 文档编写 |
