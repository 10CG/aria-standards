# Design: Documentation Integrity Validation System

> **Change ID**: validate-documentation-integrity
> **Version**: 1.0.0
> **Created**: 2025-12-27

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    validate-all.sh (入口)                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ validate-    │  │ validate-    │  │ validate-            │  │
│  │ agents.sh    │  │ skills.sh    │  │ standards.sh         │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘  │
│         │                 │                      │              │
│         └─────────────────┼──────────────────────┘              │
│                           │                                     │
│                    ┌──────▼───────┐                            │
│                    │ validate-    │                            │
│                    │ references.sh│                            │
│                    └──────────────┘                            │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                    Report Generator                             │
│              (Markdown / JSON output)                           │
└─────────────────────────────────────────────────────────────────┘
```

## 2. Core Components

### 2.1 Reference Extractor

提取文档中的所有引用路径。

**支持的引用格式**:

```regex
# @ 前缀路径 (项目根目录)
@docs/.*\.md
@standards/.*\.md
@\.claude/.*\.md
@mobile/.*
@backend/.*

# 相对路径
\.\./.*\.md
\./.*\.md

# Markdown 链接
\[.*\]\((.*\.md)\)
```

**实现逻辑**:

```bash
# 提取 @ 引用
extract_at_refs() {
    grep -oE '@[a-zA-Z0-9_./-]+\.(md|yaml|json)' "$1"
}

# 提取相对路径引用
extract_relative_refs() {
    grep -oE '\.\./[a-zA-Z0-9_./-]+\.(md|yaml|json)' "$1"
    grep -oE '\./[a-zA-Z0-9_./-]+\.(md|yaml|json)' "$1"
}

# 提取 Markdown 链接
extract_md_links() {
    grep -oE '\]\([^)]+\.md\)' "$1" | sed 's/\](\(.*\))/\1/'
}
```

### 2.2 Path Resolver

将引用路径解析为实际文件路径。

**路径映射规则**:

| 引用格式 | 解析规则 |
|---------|---------|
| `@docs/xxx` | `${PROJECT_ROOT}/docs/xxx` |
| `@standards/xxx` | `${PROJECT_ROOT}/standards/xxx` |
| `@.claude/xxx` | `${PROJECT_ROOT}/.claude/xxx` |
| `../xxx` | 相对于当前文件目录 |
| `./xxx` | 相对于当前文件目录 |

### 2.3 Validators

#### Agents Validator

```yaml
检查目标: .claude/agents/*.md

必需结构:
  - 文件名: {role-name}.md
  - 内容:
    - 角色描述
    - 核心职责
    - 相关文档引用

检查项:
  - [ ] 文件存在且非空
  - [ ] 包含角色描述
  - [ ] 内部引用有效
```

#### Skills Validator

```yaml
检查目标: .claude/skills/*/

必需结构:
  - SKILL.md (必需)
  - EXAMPLES.md (可选)
  - TEMPLATES.md (可选)
  - VALIDATION.md (可选)

SKILL.md 必需字段:
  frontmatter:
    - name: string
    - description: string
  内容:
    - 使用场景
    - 相关文档引用

检查项:
  - [ ] SKILL.md 存在
  - [ ] Frontmatter 完整
  - [ ] @ 引用有效
  - [ ] 相关文件引用有效
```

#### Standards Validator

```yaml
检查目标: standards/**/*.md

结构验证:
  - conventions/: 规范文档
  - core/: 核心规范
  - extensions/: 扩展规范
  - summaries/: 摘要文档
  - workflow/: 工作流文档

检查项:
  - [ ] README.md 存在于各目录
  - [ ] 内部交叉引用有效
  - [ ] 版本号格式规范 (x.y.z)
```

## 3. Configuration Schema

```yaml
# .doc-validator.yaml

# 验证范围
scope:
  agents: true
  skills: true
  standards: true

# 忽略规则
ignore:
  paths:
    - "**/*.backup"
    - "**/archived/**"
  references:
    - "http://*"
    - "https://*"

# 自定义规则
rules:
  require_frontmatter: true
  require_version: false
  max_reference_depth: 3

# 报告配置
report:
  format: "markdown"  # markdown | json
  output: "docs/generated/reports/doc-validation-report.md"
  include_passed: false
```

## 4. Output Format

### 4.1 Markdown Report

```markdown
# Documentation Validation Report

> Generated: 2025-12-27 10:30:00
> Scope: agents, skills, standards

## Summary

| Category | Passed | Failed | Warnings |
|----------|--------|--------|----------|
| Agents   | 10     | 1      | 2        |
| Skills   | 18     | 0      | 3        |
| Standards| 45     | 2      | 5        |
| **Total**| **73** | **3**  | **10**   |

## Errors (3)

### 1. Invalid Reference
- **File**: `.claude/skills/arch-update/SKILL.md`
- **Line**: 45
- **Reference**: `@docs/standards/old-file.md`
- **Issue**: File not found

...

## Warnings (10)

### 1. Missing Optional File
- **Skill**: `task-planner`
- **Missing**: `EXAMPLES.md`
- **Severity**: Low

...

## Passed Checks (73)

<details>
<summary>Click to expand</summary>

- [x] .claude/agents/tech-lead.md
- [x] .claude/agents/qa-engineer.md
...

</details>
```

### 4.2 JSON Report

```json
{
  "generated_at": "2025-12-27T10:30:00Z",
  "scope": ["agents", "skills", "standards"],
  "summary": {
    "total": 86,
    "passed": 73,
    "failed": 3,
    "warnings": 10
  },
  "errors": [
    {
      "type": "invalid_reference",
      "file": ".claude/skills/arch-update/SKILL.md",
      "line": 45,
      "reference": "@docs/standards/old-file.md",
      "message": "File not found"
    }
  ],
  "warnings": [...],
  "passed": [...]
}
```

## 5. Integration Points

### 5.1 Git Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

# 仅验证暂存的文件
STAGED_DOCS=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(md|yaml)$')

if [ -n "$STAGED_DOCS" ]; then
    echo "Validating documentation..."
    scripts/validate-all.sh --incremental "$STAGED_DOCS"

    if [ $? -ne 0 ]; then
        echo "Documentation validation failed. Please fix errors before committing."
        exit 1
    fi
fi
```

### 5.2 CI/CD Pipeline

```yaml
# .github/workflows/doc-validation.yml
name: Documentation Validation

on:
  pull_request:
    paths:
      - '.claude/**'
      - 'standards/**'
      - 'docs/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run validation
        run: ./scripts/validate-all.sh
      - name: Upload report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: doc-validation-report
          path: docs/generated/reports/doc-validation-report.md
```

## 6. Performance Considerations

### 6.1 Caching

```yaml
缓存策略:
  - 缓存已验证文件的哈希值
  - 增量验证仅检查变更文件
  - 缓存位置: .doc-validator-cache/
```

### 6.2 Parallel Execution

```bash
# 并行验证各模块
validate_all() {
    (validate_agents &)
    (validate_skills &)
    (validate_standards &)
    wait
    merge_reports
}
```

## 7. Error Handling

| 错误类型 | 退出码 | 说明 |
|---------|--------|------|
| 成功 | 0 | 所有检查通过 |
| 验证失败 | 1 | 存在失效引用或缺失文件 |
| 配置错误 | 2 | 配置文件格式错误 |
| 运行时错误 | 3 | 脚本执行异常 |

## 8. Future Enhancements

1. **语义验证**: 检查描述内容的一致性
2. **图谱可视化**: 生成文档依赖关系图
3. **自动修复**: 自动更新失效引用
4. **多语言支持**: 验证翻译文档的一致性
