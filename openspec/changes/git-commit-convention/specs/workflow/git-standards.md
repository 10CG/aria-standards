# Git Standards

## ADDED Requirements

### Requirement: Conventional Commits Format

All git commit messages MUST follow the Conventional Commits specification.

#### Format Structure

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Components**:
- `<type>`: Required - Describes the nature of the change
- `<scope>`: Optional - Component or module affected
- `<subject>`: Required - Brief description (imperative mood)
- `<body>`: Optional - Detailed explanation
- `<footer>`: Optional - References to issues, breaking changes

#### Allowed Types

The following commit types are permitted:

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add two-factor authentication` |
| `fix` | Bug fix | `fix(api): handle null values in task response` |
| `docs` | Documentation only | `docs(readme): update installation instructions` |
| `style` | Code style changes | `style(ui): format button component` |
| `refactor` | Code refactoring | `refactor(database): simplify query builder` |
| `test` | Adding or updating tests | `test(auth): add unit tests for login` |
| `chore` | Build, tooling, dependencies | `chore(deps): update flutter to 3.16` |

#### Scope Guidelines

Scope is **optional** but recommended for clarity:

- Use lowercase
- Keep concise (1-2 words)
- Match project structure when possible

**Examples**:
- `feat(api): ...` - Backend API changes
- `fix(ui): ...` - Mobile UI fixes
- `docs(workflow): ...` - Workflow documentation
- `chore(deps): ...` - Dependency updates

#### Subject Line Rules

The subject line MUST adhere to these rules:

1. **Use imperative mood**: "add feature" not "added feature"
2. **Lowercase**: First letter should be lowercase
3. **No period**: Do not end with a period
4. **Maximum 72 characters**: Keep it concise
5. **Be descriptive**: Clearly state what changed

**Good Examples**:
```
feat(auth): add password reset functionality
fix(database): prevent connection pool exhaustion
docs(api): document rate limiting endpoints
```

**Bad Examples**:
```
Added new feature.           # ❌ Not imperative, has period
Fix bug                      # ❌ Not descriptive enough
FEAT(UI): New Button         # ❌ Uppercase
feat(api): Added the new authentication system with JWT tokens and refresh token rotation # ❌ Too long
```

#### Body Guidelines (Optional)

When including a body:

- Separate from subject with blank line
- Explain **what** and **why**, not how
- Wrap at 72 characters
- Use bullet points for multiple changes

**Example**:
```
feat(api): add task filtering by priority

Implement query parameter support for filtering tasks by priority
level. This enables mobile app to show filtered task lists.

- Add priority query parameter validation
- Update database query to support filtering
- Add integration tests for new endpoint
```

#### Footer Guidelines (Optional)

Use footer for:

- **Issue references**: `Closes #123`, `Fixes #456`, `Refs #789`
- **Breaking changes**: `BREAKING CHANGE: API endpoint renamed`
- **Co-authors**: `Co-authored-by: Name <email>`

**Example**:
```
feat(api): redesign task creation endpoint

BREAKING CHANGE: POST /tasks now requires priority field.
Migration guide available in docs/migration/v2.0.md

Closes #234
```

### Requirement: Commit Message Validation

Projects MUST use automated validation to enforce the commit message format.

#### Validation Implementation

A pre-commit hook script SHALL be provided in `standards/tools/commit-msg-lint.sh` that validates:

1. **Type validation**: Type must be in the allowed list
2. **Subject format**: Must match pattern `<type>(<scope>): <subject>`
3. **Subject case**: Subject must start with lowercase letter
4. **Subject length**: Subject must not exceed 72 characters
5. **Subject punctuation**: Subject must not end with a period

#### Validation Rules

The validation script MUST check:

```bash
# Pattern: type(scope): subject
# - type: required, from allowed list
# - scope: optional, alphanumeric + hyphen
# - subject: required, starts lowercase, no trailing period

PATTERN="^(feat|fix|docs|style|refactor|test|chore)(\([a-z0-9-]+\))?: [a-z].{0,70}[^.]$"
```

#### Error Messages

Validation errors MUST provide helpful guidance:

```
❌ Invalid commit message format

Error: Commit type 'feature' is not allowed
Allowed types: feat, fix, docs, style, refactor, test, chore

Your message: feature(api): Add new endpoint

Suggestion: feat(api): add new endpoint

Format: <type>(<scope>): <subject>
See: standards/docs/git-commit-convention.md
```

#### Installation

Each repository MUST install the validation hook:

```bash
# Copy hook to .git/hooks/
cp standards/tools/commit-msg-lint.sh .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```

### Requirement: Cross-Repository Consistency

All repositories in the Todo App project MUST use the same commit message convention:

- `todo-app` (main repository)
- `standards` (standards submodule)
- `shared` (shared contracts submodule)
- `mobile` (mobile app submodule)
- `backend` (backend API submodule)

#### Enforcement

1. Each repository SHALL have the validation hook installed
2. CI/CD pipelines SHALL validate commit messages on PRs
3. CONTRIBUTING.md SHALL document the convention

### Requirement: Documentation

Each repository MUST document the commit convention in `CONTRIBUTING.md`:

1. Link to this standard
2. Include quick reference with examples
3. Provide installation instructions for validation hook
4. List common mistakes to avoid

## ADDED Examples

### Example 1: Simple Feature Addition

```
feat(auth): add email verification

Implement email verification flow for new user registration.
Sends verification email with time-limited token.

Closes #456
```

### Example 2: Bug Fix

```
fix(api): prevent duplicate task creation

Race condition allowed multiple tasks with same ID.
Add database constraint and duplicate check.

Fixes #789
```

### Example 3: Documentation Update

```
docs(readme): update Flutter installation steps

Reflect changes in Flutter 3.16 setup process.
```

### Example 4: Refactoring

```
refactor(database): extract query builder

Split monolithic database layer into focused modules
for better testability and maintainability.
```

### Example 5: Breaking Change

```
feat(api): redesign authentication endpoints

BREAKING CHANGE: Authentication endpoints moved from
/auth/* to /v2/auth/*. Old endpoints deprecated.

Migration guide: docs/migration/auth-v2.md
Closes #123
```

### Example 6: Chore with Scope

```
chore(deps): update dependencies

- flutter: 3.16.0 -> 3.16.5
- dio: 5.3.0 -> 5.4.0
- freezed: 2.4.5 -> 2.4.6
```

## Quality Gate Checklist

Before applying this change, verify:

- [x] **Simplicity**: Introduces ≤3 new concepts (type, scope, subject format)
- [x] **Clarity**: Format can be understood in 5 minutes
- [x] **Consistency**: Aligned with industry standards (Conventional Commits)
- [x] **Enforceability**: Can be validated automatically with script

## Implementation Status

- [x] Specification written
- [ ] Validation script created (`tools/commit-msg-lint.sh`)
- [ ] Tested in standards repository
- [ ] Rolled out to other repositories
- [ ] CI/CD integration complete
- [ ] Team training complete

## References

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Git Commit Best Practices](https://cbea.ms/git-commit/)
