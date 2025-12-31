# 命名规范

> **Version**: 1.0.0
> **Status**: Active
> **Purpose**: 统一项目中所有命名的规范和约定

---

## 1. 通用原则

### 1.1 核心原则

| 原则 | 说明 | 示例 |
|------|------|------|
| **清晰性** | 名称应明确表达用途 | `getUserById` 而非 `getData` |
| **一致性** | 同类事物使用相同模式 | 所有服务类都用 `*Service` |
| **简洁性** | 避免不必要的冗长 | `userId` 而非 `theUserIdentifier` |
| **可搜索** | 便于全局搜索定位 | 使用有意义的前缀 |

### 1.2 语言选择

| 场景 | 语言 | 说明 |
|------|------|------|
| 代码标识符 | 英文 | 变量、函数、类名 |
| 注释 | 中文/英文 | 根据团队偏好 |
| 文档标题 | 中文 | 面向团队的文档 |
| 文件名 | 英文 | 技术文件 |
| Git分支 | 英文 | 统一规范 |

---

## 2. 文件命名

### 2.1 文档文件 (Markdown)

#### 四段式命名 (推荐)

对于复杂项目的技术文档，**推荐**使用四段式命名模式：

```
[领域代码]-[类型代码]-[主题]-[子主题].md
```

> **适用场景**: 大型项目、需要精确分类的文档
> **可选**: 小型项目或简单文档可使用描述性名称 (如 `api-design.md`)

#### 领域代码 (Domain)

| 代码 | 全称 | 适用范围 | 示例 |
|------|------|----------|------|
| `be` | backend | 后端相关文档 | `be-dev-api-design.md` |
| `fe` | frontend | 前端相关文档 | `fe-ref-overview.md` |
| `mo` | mobile | 移动端相关文档 | `mo-test-component-plan.md` |
| `da` | data | 数据相关文档 | `da-dev-database-schema.md` |
| `pr` | project | 项目整体文档 | `pr-arch-overview.md` |
| `to` | tools | 工具相关文档 | `to-dev-css-optimizer.md` |
| `do` | docs | 文档元信息 | `do-ref-style.md` |

#### 类型代码 (Type)

| 代码 | 全称 | 用途说明 | 示例 |
|------|------|----------|------|
| `dev` | development | 开发过程文档 | `be-dev-api-design.md` |
| `ref` | reference | 参考文档、概览 | `fe-ref-overview.md` |
| `impl` | implementation | 实施状态文档 | `pr-impl-migration.md` |
| `test` | testing | 测试相关文档 | `mo-test-component-plan.md` |
| `arch` | architecture | 架构设计文档 | `pr-arch-overview.md` |
| `plan` | planning | 计划文档 | `be-plan-release.md` |
| `tech` | technical | 技术规范文档 | `da-tech-naming-standards.md` |

#### 特殊文件

| 模式 | 格式 | 示例 |
|------|------|------|
| README | `README.md` | 固定大写 |
| 索引文件 | `index.md` | 固定小写 |
| 报告文件 | `{name}-report-{date}.md` | `test-status-report-2025-07-28.md` |

#### 示例

```yaml
✅ 四段式 (复杂项目):
  - be-dev-api-design.md        # 后端API设计开发文档
  - mo-test-component-plan.md   # 移动端组件测试计划
  - pr-arch-overview.md         # 项目架构概览

✅ 简洁式 (小型项目/模块):
  - api-design.md               # API设计文档
  - architecture.md             # 架构文档
  - database-schema.md          # 数据库模式

❌ 不推荐:
  - database_structure.md       # 使用下划线（应用连字符）
  - DatabaseStructure.md        # 使用驼峰
  - dev plan.md                 # 使用空格
```

### 2.2 代码文件

#### Python (Backend)

```python
# 文件命名: snake_case
user_service.py
auth_middleware.py
database_config.py

# 测试文件
test_user_service.py
test_auth_middleware.py
```

#### Dart/Flutter (Mobile)

```dart
// 文件命名: snake_case
user_service.dart
auth_provider.dart
home_screen.dart

// 测试文件
user_service_test.dart
home_screen_test.dart

// Widget文件
user_card_widget.dart
custom_button.dart
```

### 2.3 配置文件

| 类型 | 命名 | 示例 |
|------|------|------|
| 环境配置 | `.env.{environment}` | `.env.development` |
| 项目配置 | `{tool}.config.{ext}` | `jest.config.js` |
| CI配置 | `.{tool}.yml` | `.github/workflows/ci.yml` |

---

## 3. 代码命名

### 3.1 变量命名

#### Python

```python
# 变量: snake_case
user_name = "John"
max_retry_count = 3
is_authenticated = True

# 常量: SCREAMING_SNAKE_CASE
MAX_CONNECTIONS = 100
DEFAULT_TIMEOUT = 30
API_BASE_URL = "https://api.example.com"

# 私有变量: _前缀
_internal_cache = {}
_session_manager = None
```

#### Dart/Flutter

```dart
// 变量: camelCase
String userName = "John";
int maxRetryCount = 3;
bool isAuthenticated = true;

// 常量: lowerCamelCase 或 SCREAMING_SNAKE_CASE
const int maxConnections = 100;
const String apiBaseUrl = "https://api.example.com";

// 私有变量: _前缀
String _internalCache;
final _sessionManager = SessionManager();
```

### 3.2 函数/方法命名

#### Python

```python
# 函数: snake_case, 动词开头
def get_user_by_id(user_id: int) -> User:
    pass

def create_new_session(user: User) -> Session:
    pass

def is_valid_email(email: str) -> bool:
    pass

def calculate_total_price(items: List[Item]) -> Decimal:
    pass

# 私有函数: _前缀
def _validate_input(data: dict) -> bool:
    pass
```

#### Dart/Flutter

```dart
// 方法: camelCase, 动词开头
User getUserById(int userId) {
  // ...
}

Session createNewSession(User user) {
  // ...
}

bool isValidEmail(String email) {
  // ...
}

// 私有方法: _前缀
bool _validateInput(Map<String, dynamic> data) {
  // ...
}
```

### 3.3 类命名

#### Python

```python
# 类: PascalCase
class UserService:
    pass

class AuthenticationMiddleware:
    pass

class DatabaseConnection:
    pass

# 异常类: 以Error或Exception结尾
class ValidationError(Exception):
    pass

class AuthenticationException(Exception):
    pass
```

#### Dart/Flutter

```dart
// 类: PascalCase
class UserService {
  // ...
}

class AuthenticationProvider extends ChangeNotifier {
  // ...
}

// Widget类
class UserProfileCard extends StatelessWidget {
  // ...
}

class HomeScreen extends StatefulWidget {
  // ...
}

// 异常类
class ValidationException implements Exception {
  // ...
}
```

### 3.4 接口/抽象类

```dart
// Dart: 接口用 abstract class
abstract class IUserRepository {
  Future<User?> findById(int id);
  Future<void> save(User user);
}

// 实现类
class UserRepositoryImpl implements IUserRepository {
  // ...
}
```

```python
# Python: 使用 ABC
from abc import ABC, abstractmethod

class IUserRepository(ABC):
    @abstractmethod
    def find_by_id(self, user_id: int) -> Optional[User]:
        pass

# 实现类
class UserRepositoryImpl(IUserRepository):
    pass
```

---

## 4. Git 分支命名

### 4.1 分支类型

| 类型 | 格式 | 示例 |
|------|------|------|
| 功能 | `feature/{module}/{task-id}-{desc}` | `feature/backend/TASK-001-user-auth` |
| 修复 | `bugfix/{module}/{issue}-{desc}` | `bugfix/mobile/ISSUE-42-login-crash` |
| 热修复 | `hotfix/{version}-{desc}` | `hotfix/v1.2.1-security-patch` |
| 发布 | `release/{version}` | `release/v1.3.0` |
| 实验 | `experiment/{name}` | `experiment/openspec-pilot` |

### 4.2 模块标识

| 标识 | 模块 |
|------|------|
| `backend` | 后端服务 |
| `mobile` | 移动应用 |
| `shared` | 共享契约 |
| `docs` | 文档 |
| `cross` | 跨模块 |

### 4.3 描述规范

```yaml
规则:
  - 使用小写字母
  - 使用连字符分隔单词
  - 简洁但有意义
  - 不超过30字符

✅ 正确:
  - feature/backend/TASK-001-user-auth
  - bugfix/mobile/ISSUE-42-scroll-fix
  - feature/cross/TASK-100-e2e-tests

❌ 错误:
  - feature/TASK001                    # 缺少模块和描述
  - Feature/Backend/UserAuth           # 大写错误
  - feature/backend/implement_the_user_authentication_system  # 太长
```

---

## 5. API 命名

### 5.1 RESTful 端点

```yaml
格式: /{version}/{resource}/{id?}/{sub-resource?}

规则:
  - 资源名使用复数名词
  - 使用小写和连字符
  - 避免动词 (用 HTTP 方法表达)

示例:
  GET    /v1/users              # 获取用户列表
  GET    /v1/users/123          # 获取单个用户
  POST   /v1/users              # 创建用户
  PUT    /v1/users/123          # 更新用户
  DELETE /v1/users/123          # 删除用户
  GET    /v1/users/123/orders   # 获取用户订单
```

### 5.2 API 参数

```yaml
Query 参数: camelCase
  GET /v1/users?pageSize=10&sortBy=createdAt

Path 参数: camelCase
  GET /v1/users/{userId}/orders/{orderId}

Request Body: camelCase
  {
    "userName": "john",
    "emailAddress": "john@example.com"
  }
```

### 5.3 响应字段

```json
{
  "success": true,
  "data": {
    "userId": 123,
    "userName": "john",
    "createdAt": "2025-12-14T10:00:00Z"
  },
  "meta": {
    "totalCount": 100,
    "pageSize": 10,
    "currentPage": 1
  }
}
```

---

## 6. 数据库命名

### 6.1 表命名

```sql
-- 格式: snake_case, 复数形式
CREATE TABLE users (
    ...
);

CREATE TABLE user_sessions (
    ...
);

CREATE TABLE order_items (
    ...
);

-- 关联表: {table1}_{table2}
CREATE TABLE users_roles (
    ...
);
```

### 6.2 列命名

```sql
-- 格式: snake_case
CREATE TABLE users (
    id              SERIAL PRIMARY KEY,
    user_name       VARCHAR(50) NOT NULL,
    email_address   VARCHAR(100) UNIQUE,
    password_hash   VARCHAR(255),
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP,
    deleted_at      TIMESTAMP  -- 软删除
);

-- 外键: {referenced_table}_id
CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER REFERENCES users(id),
    product_id  INTEGER REFERENCES products(id)
);
```

### 6.3 索引命名

```sql
-- 格式: idx_{table}_{columns}
CREATE INDEX idx_users_email ON users(email_address);
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at);

-- 唯一索引: uq_{table}_{columns}
CREATE UNIQUE INDEX uq_users_email ON users(email_address);
```

---

## 7. 测试命名

### 7.1 测试文件

| 语言 | 格式 | 示例 |
|------|------|------|
| Python | `test_{module}.py` | `test_user_service.py` |
| Dart | `{module}_test.dart` | `user_service_test.dart` |

### 7.2 测试函数/方法

```python
# Python: test_{action}_{condition}_{expected}
def test_get_user_with_valid_id_returns_user():
    pass

def test_create_user_with_duplicate_email_raises_error():
    pass

def test_login_with_wrong_password_returns_unauthorized():
    pass
```

```dart
// Dart: {action} {condition} {expected}
void main() {
  test('getUserById with valid id returns user', () {
    // ...
  });

  test('createUser with duplicate email throws exception', () {
    // ...
  });

  group('Authentication', () {
    test('login with valid credentials succeeds', () {
      // ...
    });

    test('login with wrong password fails', () {
      // ...
    });
  });
}
```

### 7.3 测试数据

```yaml
命名规则:
  - 前缀: test_, mock_, fake_, stub_
  - 清晰表达数据用途

示例:
  test_user_valid = User(name="Test User")
  mock_api_response = {"status": "ok"}
  fake_repository = FakeUserRepository()
```

---

## 8. 文档特殊命名

### 8.1 架构文档层级

| 层级 | 前缀 | 示例 |
|------|------|------|
| L0 (总览) | `*-ref-*` | `be-ref-architecture-overview.md` |
| L1 (模块) | `*-arch-*` | `be-arch-api-layer.md` |
| L2 (详细) | `*-impl-*` | `be-impl-auth-service.md` |

### 8.2 OpenSpec 文件

```yaml
目录结构:
  standards/openspec/
  ├── changes/{feature}/
  │   ├── spec.md           # 规范定义
  │   ├── proposal.md       # 提案
  │   └── tasks.md          # 任务分解
  └── archive/{feature}/
      └── spec.md           # 已归档规范
```

### 8.3 UPM 文件

```yaml
固定命名:
  - unified-progress-management.md

位置:
  - backend: project-planning/unified-progress-management.md
  - mobile: docs/project-planning/unified-progress-management.md
```

---

## 9. 快速参考

### 9.1 命名风格对照表

| 风格 | 格式 | 示例 | 使用场景 |
|------|------|------|----------|
| camelCase | 首字母小写 | `userName` | JS/Dart 变量 |
| PascalCase | 首字母大写 | `UserService` | 类名 |
| snake_case | 下划线分隔 | `user_name` | Python, 文件名 |
| SCREAMING_SNAKE | 大写下划线 | `MAX_COUNT` | 常量 |
| kebab-case | 连字符分隔 | `user-profile` | URL, CSS |

### 9.2 检查清单

创建新文件/代码时:
- [ ] 使用正确的命名风格
- [ ] 前缀/后缀符合约定
- [ ] 名称清晰表达用途
- [ ] 与现有命名保持一致
- [ ] 避免缩写歧义

---

## 相关文档

- [Git Commit 规范](./git-commit.md)
- [内容真实性规则](./content-integrity.md)
- [分支管理指南](../workflow/branch-management-guide.md)

---

**Version**: 1.0.0
**Created**: 2025-12-14
**Maintainer**: AI-DDD Development Team
