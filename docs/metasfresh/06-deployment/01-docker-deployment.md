# Docker 部署完整指南

本指南详细介绍如何使用 Docker 和 Docker Compose 部署 metasfresh ERP 系统。

---

## 📋 前置要求

### 硬件要求
- **CPU：** 4 核心或以上
- **内存：** 8GB+ (推荐 16GB)
- **磁盘：** 50GB+ 可用空间

### 软件要求
- Docker Engine 24.0+
- Docker Compose V2+
- Git 2.30+

---

## 🚀 快速部署

### 方案一：使用部署脚本（推荐）

```bash
# 1. 克隆项目
git clone https://github.com/metasfresh/metasfresh.git
cd metasfresh

# 2. 启动基础设施（数据库、消息队列、搜索引擎）
./scripts/deploy.sh start infra

# 3. 验证服务
./scripts/deploy.sh status infra

# 4. 查看日志
./scripts/deploy.sh logs infra
```

### 方案二：手动部署

```bash
# 进入 compose 目录
cd docker-builds/compose

# 启动服务
docker compose up -d

# 查看状态
docker compose ps

# 查看日志
docker compose logs -f
```

---

## 🎯 多环境部署

### 开发环境

```bash
# 启动开发环境
./scripts/deploy.sh start dev

# 特点：
# - 开启调试端口 (8789, 8788)
# - 日志级别: DEBUG
# - 较小的 JVM 内存配置
# - 端口: 8080
```

**环境变量：**
```bash
# docker-builds/compose/.env.dev
COMPOSE_PROJECT_NAME=metasfresh-dev
DB_PORT=15432
WEBAPI_PORT=8080
WEBAPI_DEBUG_PORT=8789
LOG_LEVEL=DEBUG
```

### 测试环境

```bash
# 启动测试环境
./scripts/deploy.sh start test

# 特点：
# - 独立端口映射 (8081)
# - 日志级别: INFO
# - 中等 JVM 内存配置
# - 隔离的数据目录
```

**环境变量：**
```bash
# docker-builds/compose/.env.test
COMPOSE_PROJECT_NAME=metasfresh-test
DB_PORT=25432
WEBAPI_PORT=8081
LOG_LEVEL=INFO
```

### 生产环境

```bash
# 启动生产环境
./scripts/deploy.sh start prod

# 特点：
# - 最大 JVM 内存配置
# - 日志级别: WARN
# - 严格的健康检查
# - 完整的监控配置
```

**环境变量：**
```bash
# docker-builds/compose/.env.prod
COMPOSE_PROJECT_NAME=metasfresh-prod
WEBAPI_JAVA_OPTS=-Xmx2G
APP_JAVA_OPTS=-Xmx4G
LOG_LEVEL=WARN
```

---

## 📦 服务组件说明

### 基础设施层

#### PostgreSQL 数据库
```yaml
db:
  image: metasfresh/metas-db:preloaded
  ports:
    - "5432:5432"
  volumes:
    - ./data/postgres:/var/lib/postgresql/data
  environment:
    POSTGRES_USER: metasfresh
    POSTGRES_PASSWORD: metasfresh
```

#### RabbitMQ 消息队列
```yaml
rabbitmq:
  image: rabbitmq:3.9.13-management
  ports:
    - "5672:5672"      # AMQP
    - "15672:15672"    # 管理界面
  environment:
    RABBITMQ_DEFAULT_USER: metasfresh
    RABBITMQ_DEFAULT_PASS: metasfresh
```

#### Elasticsearch 搜索引擎
```yaml
search:
  image: elasticsearch:7.17.8
  ports:
    - "9200:9200"
    - "9300:9300"
  environment:
    - discovery.type=single-node
    - "ES_JAVA_OPTS=-Xms128M -Xmx256m"
```

### 应用层

#### WebUI API
```yaml
webapi:
  image: metasfresh/metas-api:latest
  ports:
    - "8080:8080"
    - "8789:8789"  # 调试端口
  environment:
    JAVA_TOOL_OPTIONS: "-Xmx512M -agentlib:jdwp=..."
    SPRING_RABBITMQ_HOST: rabbitmq
    SPRING_DATA_ELASTICSEARCH_CLIENT_REACTIVE_ENDPOINTS: search:9200
  depends_on:
    - db
    - rabbitmq
    - search
```

#### App Server
```yaml
app:
  image: metasfresh/metas-app:latest
  ports:
    - "8282:8282"
    - "8788:8788"  # 调试端口
  environment:
    JAVA_TOOL_OPTIONS: "-Xmx1024M -agentlib:jdwp=..."
  depends_on:
    - db
```

### 前端层

#### Web UI
```yaml
webui:
  image: metasfresh/metas-frontend:latest
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./web-config.js:/usr/share/nginx/html/config.js:ro
  depends_on:
    - webapi
    - app
```

#### Mobile UI
```yaml
mobile:
  image: metasfresh/metas-mobile:latest
  ports:
    - "8880:80"
  volumes:
    - ./mobile-config.js:/usr/share/nginx/html/config.js:ro
```

---

## 🔧 配置管理

### 环境变量配置

创建 `.env` 文件：

```bash
# 镜像仓库和版本
mfregistry=metasfresh
mfversion=latest

# 数据库配置
dbqualifier=preloaded
DB_HOST=db
DB_PORT=5432
DB_NAME=metasfresh
DB_USER=metasfresh
DB_PASSWORD=metasfresh

# RabbitMQ 配置
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=metasfresh
RABBITMQ_PASSWORD=metasfresh

# Elasticsearch 配置
ES_HOST=search
ES_PORT=9200

# JVM 配置
WEBAPI_JAVA_OPTS=-Xmx512M -XX:+HeapDumpOnOutOfMemoryError
APP_JAVA_OPTS=-Xmx1024M -XX:+HeapDumpOnOutOfMemoryError

# 日志级别
LOG_LEVEL=INFO
```

### 应用配置文件

#### metasfresh.properties
```properties
# 数据库连接
db.host=${DB_HOST}
db.port=${DB_PORT}
db.name=${DB_NAME}
db.user=${DB_USER}
db.password=${DB_PASSWORD}

# RabbitMQ
spring.rabbitmq.host=${RABBITMQ_HOST}
spring.rabbitmq.port=${RABBITMQ_PORT}

# Elasticsearch
spring.data.elasticsearch.client.reactive.endpoints=${ES_HOST}:${ES_PORT}

# 日志
logging.level.de.metas=${LOG_LEVEL}
```

---

## 💾 数据持久化

### 数据目录结构

```
docker-builds/compose/data/
├── dev/                    # 开发环境数据
│   ├── postgres/
│   ├── rabbitmq/
│   ├── elasticsearch/
│   └── logs/
│       ├── webapi/
│       └── app/
├── test/                   # 测试环境数据
│   └── ...
└── prod/                   # 生产环境数据
    └── ...
```

### 配置卷挂载

```yaml
volumes:
  # PostgreSQL 数据
  postgres_data:
    driver: local
    driver_opts:
      type: none
      device: ${PWD}/data/${ENV}/postgres
      o: bind

  # RabbitMQ 数据
  rabbitmq_data:
    driver: local
    driver_opts:
      type: none
      device: ${PWD}/data/${ENV}/rabbitmq
      o: bind

  # Elasticsearch 数据
  es_data:
    driver: local
    driver_opts:
      type: none
      device: ${PWD}/data/${ENV}/elasticsearch
      o: bind
```

### 备份策略

```bash
# 备份 PostgreSQL
docker exec metasfresh-prod-db pg_dump -U metasfresh metasfresh > backup_$(date +%Y%m%d).sql

# 备份数据目录
tar -czf data_backup_$(date +%Y%m%d).tar.gz docker-builds/compose/data/prod/

# 恢复数据库
docker exec -i metasfresh-prod-db psql -U metasfresh metasfresh < backup_20241207.sql
```

---

## 🔍 监控和日志

### 查看日志

```bash
# 所有服务日志
docker compose logs -f

# 特定服务日志
docker compose logs -f webapi
docker compose logs -f db

# 最近 100 行
docker compose logs --tail=100 webapi

# 实时跟踪
docker compose logs -f --tail=0 webapi
```

### 健康检查

```bash
# 检查所有容器健康状态
docker ps --format "table {{.Names}}\t{{.Status}}"

# 检查特定服务健康
docker inspect --format='{{.State.Health.Status}}' metasfresh-prod-webapi

# 查看健康检查日志
docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' metasfresh-prod-webapi
```

### 资源监控

```bash
# 查看资源使用
docker stats

# 只看 metasfresh 相关容器
docker stats $(docker ps --filter "name=metasfresh" --format "{{.Names}}")

# 导出统计信息
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" > stats.txt
```

---

## 🛠️ 常用操作

### 启动和停止

```bash
# 启动所有服务
./scripts/deploy.sh start <env>

# 停止所有服务
./scripts/deploy.sh stop <env>

# 重启服务
./scripts/deploy.sh restart <env>

# 停止并删除容器
docker compose down

# 停止并删除容器、卷、网络
docker compose down -v
```

### 更新镜像

```bash
# 拉取最新镜像
docker compose pull

# 重新创建容器
docker compose up -d --force-recreate

# 使用新镜像重启
docker compose up -d --pull always
```

### 扩容服务

```bash
# 扩展 webapi 到 3 个实例
docker compose up -d --scale webapi=3

# 查看扩展后的服务
docker compose ps webapi
```

---

## 🔐 安全配置

### 修改默认密码

```bash
# 修改 .env 文件
DB_PASSWORD=<strong_password>
RABBITMQ_PASSWORD=<strong_password>

# 重新创建服务
docker compose up -d --force-recreate
```

### 配置 HTTPS

#### 1. 准备 SSL 证书

```bash
# 使用 Let's Encrypt
certbot certonly --standalone -d yourdomain.com

# 或使用自签名证书（仅测试）
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ./certs/server.key \
  -out ./certs/server.crt
```

#### 2. 配置 Nginx

```nginx
server {
    listen 443 ssl;
    server_name yourdomain.com;

    ssl_certificate /etc/nginx/certs/server.crt;
    ssl_certificate_key /etc/nginx/certs/server.key;

    location / {
        proxy_pass http://webui:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 网络隔离

```yaml
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true  # 内部网络，不可访问外网

services:
  webui:
    networks:
      - frontend
  
  webapi:
    networks:
      - frontend
      - backend
  
  db:
    networks:
      - backend  # 数据库只在内部网络
```

---

## 🐛 故障排除

### 问题 1: 容器启动失败

```bash
# 查看错误日志
docker compose logs <service_name>

# 检查配置文件
docker compose config

# 验证镜像
docker images | grep metasfresh
```

### 问题 2: 端口冲突

```bash
# 查找占用端口的进程
lsof -i :8080
netstat -tulpn | grep :8080

# 修改端口映射
# 编辑 docker-compose.yml
ports:
  - "18080:8080"  # 使用其他端口
```

### 问题 3: 数据库连接失败

```bash
# 检查数据库容器
docker exec -it metasfresh-prod-db psql -U metasfresh -d metasfresh

# 检查网络连接
docker exec metasfresh-prod-webapi ping db

# 查看数据库日志
docker logs metasfresh-prod-db
```

### 问题 4: 内存不足

```bash
# 增加容器内存限制
docker-compose.yml:
  webapi:
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 512M
```

---

## 📚 相关文档

- [环境配置](./03-environment-config.md)
- [Kubernetes 部署](./02-kubernetes.md)
- [监控告警](./04-monitoring.md)
- [备份恢复](./05-backup-restore.md)

---

**更新时间：** 2024-12-07  
**维护者：** metasfresh DevOps Team
