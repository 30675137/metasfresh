# 快速开始指南

## 🚀 5分钟快速体验 metasfresh

本指南将带你在 5 分钟内快速体验 metasfresh ERP 系统的核心功能。

---

## 前置要求

- ✅ Docker Desktop 已安装并运行
- ✅ 至少 4GB 可用内存
- ✅ 10GB 可用磁盘空间

---

## 步骤 1: 克隆项目

```bash
git clone https://github.com/metasfresh/metasfresh.git
cd metasfresh
```

---

## 步骤 2: 启动基础设施

```bash
# 启动数据库、消息队列、搜索引擎
./deploy.sh start infra

# 等待服务启动（约 1-2 分钟）
```

---

## 步骤 3: 验证服务

```bash
# 查看服务状态
docker ps | grep metasfresh-infra

# 应该看到 3 个容器在运行：
# - metasfresh-infra-db (PostgreSQL)
# - metasfresh-infra-rabbitmq (RabbitMQ)
# - metasfresh-infra-es (Elasticsearch)
```

---

## 步骤 4: 访问服务

### PostgreSQL 数据库
```bash
docker exec -it metasfresh-infra-db psql -U metasfresh -d metasfresh
```

### RabbitMQ 管理界面
- URL: http://localhost:15672
- 用户名: `metasfresh`
- 密码: `metasfresh`

### Elasticsearch
```bash
curl http://localhost:9200
```

---

## 🎉 完成！

恭喜！你已经成功启动了 metasfresh 的基础设施服务。

### 下一步

- 📖 阅读 [环境搭建](./02-environment-setup.md) 了解完整环境配置
- 🛠️ 查看 [开发指南](../03-development/01-dev-environment.md) 开始开发
- 📚 浏览 [系统架构](../02-fundamentals/02-architecture.md) 了解技术架构

---

## 常见问题

### 服务无法启动？
```bash
# 检查 Docker 是否运行
docker info

# 检查端口是否被占用
lsof -i :5432
lsof -i :15672
lsof -i :9200
```

### 内存不足？
- 增加 Docker Desktop 内存限制到 6GB+
- 关闭其他占用内存的应用

---

**下一篇：** [环境搭建](./02-environment-setup.md)
