# 字段命名规范

> **Version**: 1.0.0
> **Status**: Active
> **Purpose**: 定义数据库和API字段的命名标准，确保分层一致性

---

## 1. 核心原则

### 1.1 分层命名约定

```yaml
数据库层: snake_case
API层: camelCase
映射层: 自动转换工具
```

### 1.2 设计理念

| 原则 | 说明 |
|------|------|
| **分层清晰** | 每层有明确的命名风格 |
| **自动映射** | 通过工具自动完成层间转换 |
| **一致性** | 同层内严格保持风格一致 |
| **可预测** | 命名规则可推断，便于开发 |

---

## 2. 数据库字段命名

### 2.1 基本规则

```sql
-- ✅ 正确示例 (snake_case)
created_at INTEGER
updated_at INTEGER
completed_at INTEGER
user_id INTEGER
parent_id INTEGER

-- ❌ 错误示例 (camelCase)
createdAt INTEGER
completedAt INTEGER
userId INTEGER
```

### 2.2 时间戳字段

```sql
-- 标准时间戳命名
created_at INTEGER      -- 创建时间
updated_at INTEGER      -- 更新时间
deleted_at INTEGER      -- 软删除时间
completed_at INTEGER    -- 完成时间
started_at INTEGER      -- 开始时间
expired_at INTEGER      -- 过期时间
last_login_at INTEGER   -- 最后登录时间
```

### 2.3 外键字段

```sql
-- 格式: {referenced_table_singular}_id
user_id INTEGER         -- 用户ID
parent_id INTEGER       -- 父级ID
category_id INTEGER     -- 分类ID
creator_id INTEGER      -- 创建者ID
assignee_id INTEGER     -- 被分配者ID
```

### 2.4 布尔字段

```sql
-- 格式: is_{状态} 或 has_{属性} 或直接状态词
is_active BOOLEAN       -- 是否激活
is_deleted BOOLEAN      -- 是否删除
is_verified BOOLEAN     -- 是否验证
has_attachment BOOLEAN  -- 是否有附件
completed BOOLEAN       -- 是否完成
enabled BOOLEAN         -- 是否启用
```

### 2.5 复合字段

```sql
-- 多词组合使用下划线分隔
estimated_time_value INTEGER    -- 预计时间值
estimated_time_unit TEXT        -- 预计时间单位
password_hash TEXT              -- 密码哈希
email_address TEXT              -- 邮箱地址
phone_number TEXT               -- 电话号码
```

---

## 3. API字段命名

### 3.1 基本规则

```json
// ✅ 正确示例 (camelCase)
{
  "id": 1,
  "title": "任务标题",
  "completed": true,
  "createdAt": 1642780800000,
  "updatedAt": 1642780800000,
  "userId": 123,
  "parentId": null
}

// ❌ 错误示例 (snake_case)
{
  "created_at": 1642780800000,
  "user_id": 123
}
```

### 3.2 嵌套对象和数组

```json
{
  "userId": 123,
  "userName": "john",
  "userProfile": {
    "firstName": "John",
    "lastName": "Doe",
    "emailAddress": "john@example.com"
  },
  "todoItems": [
    { "itemId": 1, "itemTitle": "Task 1" }
  ],
  "tagList": ["work", "urgent"]
}
```

### 3.3 时间字段

```json
{
  "createdAt": "2025-12-14T10:00:00Z",
  "updatedAt": "2025-12-14T12:30:00Z",
  "completedAt": null,
  "dueDate": "2025-12-20",
  "startTime": "09:00:00"
}
```

---

## 4. 字段映射策略

### 4.1 映射规则

```yaml
数据库 → API 映射:
  created_at → createdAt
  updated_at → updatedAt
  user_id → userId
  parent_id → parentId
  is_active → isActive
  email_address → emailAddress

API → 数据库 映射:
  createdAt → created_at
  updatedAt → updated_at
  userId → user_id
  parentId → parent_id
  isActive → is_active
  emailAddress → email_address
```

### 4.2 映射工具实现示例

```javascript
// 通用 FieldMapper 工具
const FieldMapper = {
  // snake_case → camelCase
  toCamelCase(str) {
    return str.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase());
  },

  // camelCase → snake_case
  toSnakeCase(str) {
    return str.replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`);
  },

  // 对象映射: DB → API
  mapToApi(dbRecord) {
    const result = {};
    for (const [key, value] of Object.entries(dbRecord)) {
      result[this.toCamelCase(key)] = value;
    }
    return result;
  },

  // 对象映射: API → DB
  mapToDb(apiRecord) {
    const result = {};
    for (const [key, value] of Object.entries(apiRecord)) {
      result[this.toSnakeCase(key)] = value;
    }
    return result;
  }
};
```

```python
# Python 实现
import re

def to_camel_case(snake_str: str) -> str:
    components = snake_str.split('_')
    return components[0] + ''.join(x.title() for x in components[1:])

def to_snake_case(camel_str: str) -> str:
    return re.sub(r'(?<!^)(?=[A-Z])', '_', camel_str).lower()

def map_to_api(db_record: dict) -> dict:
    return {to_camel_case(k): v for k, v in db_record.items()}

def map_to_db(api_record: dict) -> dict:
    return {to_snake_case(k): v for k, v in api_record.items()}
```

---

## 5. 表结构命名

### 5.1 表命名规则

```sql
-- 格式: snake_case, 复数形式
CREATE TABLE users (...);
CREATE TABLE todos (...);
CREATE TABLE categories (...);
CREATE TABLE user_sessions (...);
CREATE TABLE order_items (...);

-- 关联表: {table1}_{table2} (按字母顺序)
CREATE TABLE roles_users (...);
CREATE TABLE tags_todos (...);
```

### 5.2 索引命名规则

```sql
-- 普通索引: idx_{table}_{columns}
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_todos_user_created ON todos(user_id, created_at);

-- 唯一索引: uq_{table}_{columns}
CREATE UNIQUE INDEX uq_users_email ON users(email);

-- 外键约束: fk_{table}_{referenced_table}
ALTER TABLE todos ADD CONSTRAINT fk_todos_users
  FOREIGN KEY (user_id) REFERENCES users(id);
```

### 5.3 表结构示例

```sql
-- 标准表结构模板
CREATE TABLE {table_name} (
    -- 主键
    id SERIAL PRIMARY KEY,

    -- 业务字段 (snake_case)
    field_name TEXT NOT NULL,
    another_field INTEGER,

    -- 外键字段
    user_id INTEGER REFERENCES users(id),
    parent_id INTEGER REFERENCES {table_name}(id),

    -- 布尔字段
    is_active BOOLEAN DEFAULT true,

    -- 时间戳字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

-- 创建索引
CREATE INDEX idx_{table_name}_user ON {table_name}(user_id);
CREATE INDEX idx_{table_name}_created ON {table_name}(created_at);
```

---

## 6. 迁移与变更管理

### 6.1 字段添加流程

```yaml
Step 1 - 数据库设计:
  - 使用 snake_case 命名新字段
  - 创建迁移脚本

Step 2 - 映射配置:
  - 在 FieldMapper 中添加映射规则
  - 或确认自动转换正确

Step 3 - API更新:
  - API文档更新为 camelCase
  - 更新类型定义

Step 4 - 验证:
  - 测试 DB → API 映射
  - 测试 API → DB 映射
```

### 6.2 字段重命名流程

```yaml
Step 1 - 影响分析:
  - 识别所有使用该字段的代码
  - 评估API兼容性影响

Step 2 - 数据库迁移:
  - 创建迁移脚本
  - 备份数据

Step 3 - 代码更新:
  - 更新映射配置
  - 更新相关代码

Step 4 - 验证:
  - 运行完整测试
  - 验证数据一致性
```

---

## 7. 最佳实践

### 7.1 设计阶段

- [ ] 新表和字段严格遵循 snake_case
- [ ] 考虑未来扩展性
- [ ] 避免使用SQL保留字
- [ ] 字段名具有自描述性

### 7.2 开发阶段

- [ ] 使用统一的 FieldMapper 工具
- [ ] 避免硬编码字段名
- [ ] API响应使用 camelCase
- [ ] 请求体接受 camelCase

### 7.3 维护阶段

- [ ] 定期检查命名一致性
- [ ] 保持映射配置更新
- [ ] 文档与实现同步

---

## 8. 常见问题

### Q: 为什么不直接在数据库使用 camelCase？

**A:**
- 数据库标准和惯例推荐使用 snake_case
- 大多数数据库对大小写不敏感，snake_case 更可靠
- 便于与其他系统和工具集成
- SQL查询更易读

### Q: 为什么API使用 camelCase？

**A:**
- JavaScript/TypeScript 的标准命名风格
- JSON 的惯例
- 前端框架的默认期望
- 减少前端代码的转换工作

### Q: 如何处理遗留字段不一致的情况？

**A:**
1. 在映射层处理特殊情况
2. 制定迁移计划逐步统一
3. 保持向后兼容性
4. 文档记录例外情况

---

## 9. 快速参考

### 9.1 命名风格对照

| 层级 | 风格 | 示例 |
|------|------|------|
| 数据库表 | snake_case (复数) | `user_sessions` |
| 数据库字段 | snake_case | `created_at` |
| 数据库索引 | idx_{table}_{cols} | `idx_users_email` |
| API字段 | camelCase | `createdAt` |
| API响应 | camelCase | `{ "userId": 1 }` |

### 9.2 常用字段对照

| 数据库 | API |
|--------|-----|
| `created_at` | `createdAt` |
| `updated_at` | `updatedAt` |
| `user_id` | `userId` |
| `is_active` | `isActive` |
| `email_address` | `emailAddress` |

---

## 相关文档

- [命名规范](./naming-conventions.md)
- [API设计规范](../methodology/contract-driven-development.md)

---

**Version**: 1.0.0
**Created**: 2025-12-14
**Maintainer**: AI-DDD Development Team
