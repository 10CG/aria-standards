#!/bin/bash

# 标准规范集成脚本
# 用于将标准规范集成到项目中

set -e

PROJECT_PATH="${1:-.}"
STANDARDS_REPO="ssh://forgejo@forgejo.10cg.pub/10CG/ai-dev-standards.git"

echo "🔗 集成标准规范到项目..."

cd "${PROJECT_PATH}"

# 添加为Git Submodule
if [ ! -d "standards" ]; then
    git submodule add "${STANDARDS_REPO}" standards
    git submodule update --init --recursive
fi

# 创建或更新CLAUDE.md
if [ ! -f "CLAUDE.md" ]; then
    cat > CLAUDE.md << 'CLAUDE_EOF'
# 项目AI配置

## 标准规范引用
@standards/core/ten-step-cycle/
@standards/workflow/
@standards/conventions/

## 项目特定配置
# 在此添加项目特定的配置
CLAUDE_EOF
else
    echo "⚠️ CLAUDE.md已存在，请手动添加标准规范引用"
fi

echo "✅ 标准规范集成完成"
