# 前端 CORS 问题修复状态报告

## 📋 问题总结

通过 Chrome DevTools 模拟前端操作，发现以下问题：

### ❌ 当前问题

1. **API 返回 404 错误**
   - `/rest/api/login/availableLanguages` → 404
   - `/rest/api/i18n/messages` → 404  
   - `/rest/api/login/isLoggedIn` → 404

2. **根本原因**
   - `docker-compose.dev.yml` 中的服务只是 **nginx 占位符**
   - 没有真正的 Spring Boot 应用（webapi, app）
   - 所有请求被当作静态文件处理，返回 404

3. **当前部署状态**
   ```yaml
   # docker-compose.dev.yml 中的 webapi 服务
   webapi:
     image: nginx:alpine  # ❌ 只是占位符，不是真正的 API 服务
     ports:
       - "${WEBAPI_PORT}:80"
   ```

---

## ✅ 已完成的修复

### 1. CORS 代理配置（已完成 ✅）

**文件：** `frontend/server.js`

```javascript
proxy: [
  {
    context: ['/rest'],
    target: 'http://localhost:8080',
    changeOrigin: true,
    secure: false,
    logLevel: 'debug',
  },
  {
    context: ['/stomp'],
    target: 'http://localhost:8080',
    changeOrigin: true,
    secure: false,
    ws: true,
    logLevel: 'debug',
  },
]
```

**状态：** ✅ 代理配置正确，可以正常转发请求到后端

### 2. API 配置相对路径（已完成 ✅）

**文件：** `frontend/config.js.dist`

```javascript
const config = {
  API_URL: '/rest/api',  // ✅ 相对路径
  WS_URL: '/stomp',      // ✅ 相对路径
  GOOGLE_API: '',
};
```

**状态：** ✅ 前端使用相对路径，可以通过代理访问

---

## 🚧 待解决问题

### 核心问题：后端服务缺失

当前的 `docker-compose.dev.yml` 只启动了：
- ✅ PostgreSQL（数据库）
- ✅ RabbitMQ（消息队列）
- ✅ Elasticsearch（搜索引擎）
- ❌ WebAPI（Spring Boot API 服务）- **只是 nginx 占位符**
- ❌ App（应用服务器）- **只是 nginx 占位符**

---

## 💡 解决方案选项

### 方案一：使用原始 compose.yml（推荐）

**优点：**
- ✅ 完整的 metasfresh 应用
- ✅ 真正的 Spring Boot API
- ✅ 所有功能可用

**操作步骤：**
```bash
# 1. 停止当前服务
cd docker-builds/compose
docker compose -f docker-compose.dev.yml down

# 2. 使用原始配置
docker compose -f compose.yml up -d

# 3. 等待服务启动（约 5-10 分钟）
docker compose -f compose.yml ps
```

**缺点：**
- ⚠️ 需要下载大量 Docker 镜像（约 3-5GB）
- ⚠️ 资源占用较大（6-8GB 内存）

### 方案二：使用 infra 环境 + 本地开发

**优点：**
- ✅ 只启动基础设施
- ✅ 本地运行前后端（便于调试）
- ✅ 资源占用小

**操作步骤：**
```bash
# 1. 启动基础设施
./scripts/deploy.sh start infra

# 2. 本地启动后端（需要构建）
cd backend/metasfresh-webui-api
mvn spring-boot:run

# 3. 本地启动前端
cd frontend
./start.sh
```

**缺点：**
- ⚠️ 需要本地 Java 17+ 环境
- ⚠️ 需要构建后端（首次较慢）

### 方案三：修复 deploy.sh 脚本（长期解决）

修改 `scripts/deploy.sh` 中的 `create_docker_compose()` 函数，使用真正的 metasfresh 镜像而不是 nginx 占位符。

---

## 🧪 测试验证

### Chrome DevTools 检测结果

**页面访问：** http://localhost:3000/login ✅

**控制台错误：**
```
[error] Request failed with status code 404
```

**网络请求：**
```
GET http://localhost:3000/rest/api/login/availableLanguages → 404
GET http://localhost:3000/rest/api/i18n/messages → 404
GET http://localhost:3000/rest/api/login/isLoggedIn → 404
```

**响应内容：**
```html
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.29.3</center>
</body>
</html>
```

**nginx 日志：**
```
[error] open() "/usr/share/nginx/html/rest/api/login/isLoggedIn" failed
(2: No such file or directory)
```

---

## 📊 问题根源

```
浏览器
  ↓ /rest/api/login/isLoggedIn
前端开发服务器 (localhost:3000)
  ↓ 代理转发 ✅
Docker WebAPI 容器 (localhost:8080)
  ↓ nginx 查找静态文件 ❌
/usr/share/nginx/html/rest/api/login/isLoggedIn
  ↓ 文件不存在
返回 404 ❌
```

**正确的应该是：**
```
浏览器
  ↓ /rest/api/login/isLoggedIn
前端开发服务器 (localhost:3000)
  ↓ 代理转发 ✅
Docker WebAPI 容器 (localhost:8080)
  ↓ Spring Boot 应用处理 ✅
返回 JSON 数据 ✅
```

---

## 🎯 建议的下一步

1. **立即可用：** 使用原始 `compose.yml` 启动完整应用
   ```bash
   cd docker-builds/compose
   docker compose up -d
   ```

2. **开发调试：** 使用 infra + 本地开发
   ```bash
   ./scripts/deploy.sh start infra
   # 本地启动后端和前端
   ```

3. **长期方案：** 修复 deploy.sh 脚本，生成正确的配置

---

## 📝 相关文件

- `frontend/config.js.dist` - API 配置（✅ 已修复）
- `frontend/server.js` - 代理配置（✅ 已修复）
- `docker-builds/compose/docker-compose.dev.yml` - ❌ 占位符服务
- `docker-builds/compose/compose.yml` - ✅ 完整应用配置
- `scripts/deploy.sh` - ⚠️ 需要修复

---

**结论：** CORS 代理已正确配置，但后端服务是占位符，需要使用真正的 metasfresh 应用。
