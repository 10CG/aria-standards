# Extensions Summary

> **Sources**: `standards/extensions/*.md`

## Mobile Extension (Flutter/Dart)

**Quality Targets**:
- Test coverage: ≥ 85%
- Code analysis: 0 errors
- Performance: startup < 2s, memory < 300MB

**Validation Commands**:
```bash
flutter analyze --no-fatal-infos
flutter test --coverage --reporter=compact --concurrency=1
flutter build apk --debug
```

**Key Stages**: planning → development → ui-review → testing → device-testing → review → completed

## Backend Extension (Python/FastAPI)

**Quality Targets**:
- Test coverage: ≥ 90%
- No type errors (mypy)
- No security issues (high/medium)

**Validation Commands**:
```bash
flake8 . && mypy . && bandit -r .
pytest tests/unit --cov=src --cov-report=term-missing
pytest tests/integration -v
```

**Key Stages**: planning → api-contract-design → development → testing → api-documentation → review → completed

## Common Subagents

| Agent | Use For |
|-------|---------|
| backend-architect | API, DB, architecture |
| mobile-developer | Flutter, UI, state |
| qa-engineer | Tests, quality |
| api-documenter | OpenAPI, SDK docs |
| knowledge-manager | Docs, architecture |

---
*For details: `standards/extensions/`*
