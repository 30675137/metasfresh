---
trigger: manual
alwaysApply: false
---

# metasfresh ERP 项目开发规范

本规则适用于 metasfresh 开源 ERP 系统的所有开发任务。metasfresh 是一个采用 3 层架构的企业资源规划系统，基于 Java Spring Boot 后端、React 前端和 PostgreSQL 数据库。

## 项目技术栈约束

**后端技术栈**：
- Java 17+
- Spring Boot 3.x
- Maven 3.6+
- PostgreSQL 14+
- RabbitMQ 3.9+

**前端技术栈**：
- React 16.14+
- Redux
- Webpack 5+
- Jest + React Testing Library
- ESLint

**基础设施**：
- Docker Compose V2
- Docker Engine 24.0+
- Elasticsearch 7.x

## 代码编写规范

### Java 后端代码规范

**命名约定**：
- 类名使用大驼峰：`SalesOrderService`
- 方法名使用小驼峰：`createOrder()`
- 常量使用全大写下划线：`MAX_RETRY_COUNT`
- 包名使用全小写：`de.metas.order.service`

**Spring Boot 注解使用**：
- Service 层使用 `@Service`
- Repository 层使用 `@Repository`
- Controller 层使用 `@RestController`
- 优先使用构造器注入，避免字段注入

**示例（好的代码）**：
```java
@Service
@RequiredArgsConstructor
public class SalesOrderService {
    private final SalesOrderRepository repository;
    private final OrderValidator validator;
    
    public SalesOrder createOrder(CreateOrderRequest request) {
        validator.validate(request);
        SalesOrder order = SalesOrder.builder()
            .orderDate(LocalDate.now())
            .customerId(request.getCustomerId())
            .build();
        return repository.save(order);
    }
}
```

### React 前端代码规范

**组件规范**：
- 组件文件使用大驼峰：`SalesOrderList.js`
- 必须使用函数组件和 Hooks
- 必须定义 PropTypes

**示例（好的代码）**：
```javascript
import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';

const SalesOrderList = ({ customerId, onOrderSelect }) => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchOrders(customerId);
  }, [customerId]);

  const fetchOrders = async (id) => {
    setLoading(true);
    const data = await api.getOrders(id);
    setOrders(data);
    setLoading(false);
  };

  return (
    <div className="sales-order-list">
      {loading ? <Spinner /> : <OrderTable orders={orders} />}
    </div>
  );
};

SalesOrderList.propTypes = {
  customerId: PropTypes.string.isRequired,
  onOrderSelect: PropTypes.func.isRequired,
};

export default SalesOrderList;
```

## 项目结构约束

### 后端模块组织
- 每个业务功能必须是独立的 Maven 模块
- REST API 放在 `.rest-api` 模块
- Web UI 组件放在 `.webui` 模块
- 移动端组件放在 `.mobileui` 模块
- 公共工具放在 `de.metas.util`

### 前端目录结构
- 组件：`src/components/`
- 容器：`src/containers/`
- API 调用：`src/api/`
- Redux Actions：`src/actions/`
- Redux Reducers：`src/reducers/`

## REST API 设计规范

**路径规范**：
- 使用复数名词：`/api/orders`（不是 `/api/order`）
- 使用小写和连字符：`/api/sales-orders`
- 版本控制：`/api/v1/orders`

**HTTP 方法**：
- GET：查询，不修改数据
- POST：创建新资源
- PUT：完整更新
- PATCH：部分更新
- DELETE：删除资源

**响应状态码**：
- 200 OK：成功
- 201 Created：创建成功
- 204 No Content：删除成功
- 400 Bad Request：请求错误
- 404 Not Found：资源不存在
- 500 Internal Server Error：服务器错误

## 数据库规范

- 表名使用小写下划线：`sales_order`
- 字段名使用小写下划线：`order_date`
- SQL 脚本必须放在：`src/main/sql/postgresql/`
- 每个数据库变更必须有迁移脚本

## 测试要求

### 后端测试
- 使用 JUnit 5
- 测试类命名：`<ClassName>Test`
- 测试方法命名：`should<ExpectedBehavior>When<Condition>()`
- Service 层测试覆盖率至少 80%

**示例（好的测试）**：
```java
@SpringBootTest
class SalesOrderServiceTest {
    @Autowired
    private SalesOrderService service;
    
    @Test
    void shouldCreateOrderWhenValidRequest() {
        // Given
        CreateOrderRequest request = CreateOrderRequest.builder()
            .customerId("CUST-001")
            .build();
        
        // When
        SalesOrder order = service.createOrder(request);
        
        // Then
        assertThat(order).isNotNull();
        assertThat(order.getCustomerId()).isEqualTo("CUST-001");
    }
}
```

### 前端测试
- 使用 Jest + React Testing Library
- 测试文件：`src/__tests__/<ComponentName>.test.js`
- 组件测试覆盖率至少 70%

**示例（好的测试）**：
```javascript
import { render, screen, fireEvent } from '@testing-library/react';
import SalesOrderList from '../SalesOrderList';

test('should display orders when data is loaded', async () => {
  const orders = [{ id: '1', total: 100 }];
  render(<SalesOrderList orders={orders} />);
  
  expect(await screen.findByText('Order #1')).toBeInTheDocument();
});
```

## Docker 和部署

### 快速启动
```bash
# 推荐方式：启动基础设施服务
./start.sh
# 选择选项 3：仅启动 PostgreSQL, RabbitMQ, Elasticsearch
```

### 服务端口
- Web UI: http://localhost:8080
- PostgreSQL: localhost:5432
- RabbitMQ 管理: http://localhost:15672
- Elasticsearch: http://localhost:9200

## 性能优化要求

**后端**：
- 数据库查询必须使用分页
- 耗时操作使用异步处理（RabbitMQ）
- 使用缓存减少数据库查询
- JVM 参数：`-Xmx1024M -XX:+HeapDumpOnOutOfMemoryError`

**前端**：
- 使用 React.memo 避免不必要的重渲染
- 使用 useMemo 和 useCallback 优化
- 大列表使用虚拟滚动
- 图片懒加载

## 安全要求

**后端安全**：
- 验证所有输入参数
- 使用参数化查询防止 SQL 注入
- 敏感信息不得记录到日志
- API 必须有认证和授权

**前端安全**：
- 对用户输入进行 XSS 防护
- 敏感信息不存储在 localStorage
- API Token 安全存储

## Git 提交规范

**提交信息格式**：
```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型（type）**：
- `feat`: 新功能
- `fix`: bug 修复
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建工具

**示例**：
```
feat(order): 添加销售订单批量导入功能

- 支持 Excel 文件导入
- 添加数据验证
- 实现批量创建订单

Closes #123
```

## 开发工作流

### 后端开发
```bash
cd backend
mvn clean compile      # 编译
mvn clean test         # 测试
mvn clean package      # 打包
./mvnw spring-boot:run # 运行
```

### 前端开发
```bash
cd frontend
npm start              # 开发服务器
npm test               # 运行测试
npm run lint           # 代码检查
npm run lintfix        # 修复代码风格
npm run build-prod     # 生产构建
```

## 注意事项

1. **模块依赖**：所有后端模块必须继承 `de.metas.parent` 父 POM
2. **代码风格**：必须通过 ESLint/CheckStyle 检查，无错误和警告
3. **文档注释**：公共 API 必须有 Javadoc 或 JSDoc 注释
4. **异常处理**：不要捕获异常后静默吞掉，至少要记录日志
5. **配置管理**：敏感配置使用环境变量，不硬编码

## 常见问题解决

**端口冲突**：
```bash
lsof -i :8080
kill -9 <PID>
```

**Docker 镜像问题**：使用基础设施服务启动方式（选项 3）

**数据库连接失败**：
```bash
docker ps
docker logs <container-name>
```

---

**重要提示**：生成的所有代码必须遵循以上规范，包括命名约定、代码结构、测试要求和安全规范。
