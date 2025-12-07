# 开发环境搭建完整指南

本指南将详细介绍如何搭建 metasfresh 完整的开发环境。

---

## 📋 环境要求

### 硬件要求
- **CPU：** 4 核心或以上（推荐 8 核心）
- **内存：** 16GB 或以上（最低 8GB）
- **磁盘：** 50GB 可用空间（SSD 推荐）

### 软件要求

#### 必需软件
- **操作系统：** Ubuntu 20.04+, macOS 12+, Windows 10+ (WSL2)
- **Docker Desktop：** 24.0+
- **Java JDK：** 17+
- **Maven：** 3.6+
- **Node.js：** 16.14+
- **Git：** 2.30+

#### 推荐软件
- **IDE：** IntelliJ IDEA Ultimate 2023+
- **数据库工具：** DBeaver, pgAdmin
- **API 工具：** Postman, Insomnia
- **文档工具：** Obsidian

---

## 🔧 基础软件安装

### 1. 安装 Java 17

#### macOS
```bash
# 使用 Homebrew
brew install openjdk@17

# 配置环境变量
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 验证
java -version
```

#### Ubuntu
```bash
sudo apt update
sudo apt install openjdk-17-jdk

# 验证
java -version
```

#### Windows (WSL2)
```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

### 2. 安装 Maven

#### macOS
```bash
brew install maven

# 验证
mvn -version
```

#### Ubuntu/WSL2
```bash
sudo apt install maven

# 验证
mvn -version
```

### 3. 安装 Node.js

#### macOS
```bash
# 使用 nvm (推荐)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.zshrc

nvm install 16.14
nvm use 16.14

# 验证
node -v
npm -v
```

#### Ubuntu/WSL2
```bash
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# 验证
node -v
npm -v
```

### 4. 安装 Docker Desktop

#### macOS
1. 下载：https://www.docker.com/products/docker-desktop
2. 安装 DMG 包
3. 启动 Docker Desktop
4. 配置资源：
   - Memory: 8GB+
   - CPUs: 4+
   - Disk: 50GB+

#### Ubuntu
```bash
# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 添加用户到 docker 组
sudo usermod -aG docker $USER

# 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证
docker --version
docker compose version
```

#### Windows
1. 启用 WSL2
2. 下载并安装 Docker Desktop for Windows
3. 在设置中启用 WSL2 集成

---

## 📦 克隆项目

### 完整克隆（推荐新手）

```bash
# 克隆完整仓库
git clone https://github.com/metasfresh/metasfresh.git
cd metasfresh

# 查看项目结构
ls -la
```

### 稀疏检出（推荐熟练开发者）

如果只需要特定模块：

```bash
# 初始化仓库
git clone --filter=blob:none --sparse https://github.com/metasfresh/metasfresh.git
cd metasfresh

# 配置稀疏检出
git sparse-checkout init --cone
git sparse-checkout set backend/de.metas.business frontend scripts docs

# 拉取代码
git pull origin master
```

---

## 🏗️ 后端环境搭建

### 1. 配置 Maven 镜像（可选，加速下载）

编辑 `~/.m2/settings.xml`：

```xml
<settings>
  <mirrors>
    <mirror>
      <id>aliyun-maven</id>
      <mirrorOf>central</mirrorOf>
      <name>Aliyun Maven</name>
      <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
  </mirrors>
</settings>
```

### 2. 构建后端项目

```bash
cd backend

# 清理并编译（跳过测试）
mvn clean install -DskipTests

# 首次构建时间：约 10-20 分钟
```

### 3. 导入到 IntelliJ IDEA

1. **打开 IntelliJ IDEA**
2. **File → Open** → 选择 `backend` 目录
3. **等待 Maven 索引完成**
4. **配置 JDK：**
   - File → Project Structure → Project
   - SDK: 选择 Java 17
   - Language Level: 17

### 4. 配置运行配置

创建 Spring Boot 运行配置：

1. **Run → Edit Configurations**
2. **添加 Application**
3. **配置：**
   - Main class: `de.metas.WebRestApiApplication`
   - VM options: `-Xmx2G -Xms512M`
   - Working directory: `$MODULE_WORKING_DIR$`
   - Environment variables:
     ```
     SPRING_PROFILES_ACTIVE=dev
     DB_HOST=localhost
     DB_PORT=5432
     ```

---

## ⚛️ 前端环境搭建

### 1. 安装依赖

```bash
cd frontend

# 安装 yarn (推荐)
npm install -g yarn

# 安装项目依赖
yarn install

# 或使用 npm
npm install
```

### 2. 配置前端环境变量

创建 `.env.local` 文件：

```bash
# API 地址
REACT_APP_API_URL=http://localhost:8080
REACT_APP_WS_URL=ws://localhost:8080

# 调试模式
REACT_APP_DEBUG=true
```

### 3. 启动开发服务器

```bash
# 使用开发脚本
./start_dev.sh

# 或手动启动
yarn start

# 服务会在 http://localhost:3000 启动
```

### 4. 在 VSCode 中开发（可选）

推荐插件：
- ESLint
- Prettier
- React Developer Tools
- GitLens

---

## 🐳 启动基础设施服务

### 1. 启动数据库、消息队列、搜索引擎

```bash
# 回到项目根目录
cd /path/to/metasfresh

# 启动基础设施
./scripts/deploy.sh start infra

# 等待服务健康（约 2 分钟）
docker ps | grep metasfresh-infra
```

### 2. 验证服务

```bash
# PostgreSQL
docker exec -it metasfresh-infra-db psql -U metasfresh -d metasfresh -c "SELECT version();"

# RabbitMQ
curl -u metasfresh:metasfresh http://localhost:15672/api/overview

# Elasticsearch
curl http://localhost:9200
```

---

## 🚀 启动应用

### 方案一：Docker Compose 启动（推荐）

```bash
# 启动所有服务
./scripts/deploy.sh start dev

# 查看日志
./scripts/deploy.sh logs dev
```

### 方案二：本地启动（开发调试）

#### 1. 启动后端

```bash
# 终端 1: 启动 WebUI API
cd backend/metasfresh-webui-api
mvn spring-boot:run

# 终端 2: 启动 App Server
cd backend/metasfresh-dist/dist
./start_server.sh
```

#### 2. 启动前端

```bash
# 终端 3: 启动前端
cd frontend
yarn start
```

---

## ✅ 验证安装

### 1. 检查所有服务

```bash
# 基础设施
curl http://localhost:9200          # Elasticsearch
curl http://localhost:15672         # RabbitMQ

# 后端服务
curl http://localhost:8080/health   # WebUI API
curl http://localhost:8282/health   # App Server

# 前端
curl http://localhost:3000          # React Dev Server
```

### 2. 访问应用

打开浏览器访问：
- **Web UI：** http://localhost:3000
- **API 文档：** http://localhost:8080/swagger-ui.html

登录信息：
- 用户名：`metasfresh`
- 密码：`metasfresh`

---

## 🔧 IDE 配置

### IntelliJ IDEA 配置

#### 1. 代码格式化

1. **下载代码风格配置**
   ```bash
   # 项目中通常有配置文件
   ls misc/dev-support/ide-settings/
   ```

2. **导入到 IDEA**
   - File → Settings → Editor → Code Style
   - Import Scheme → IntelliJ IDEA code style XML

#### 2. 配置远程调试

```
Run → Edit Configurations → Remote JVM Debug
- Host: localhost
- Port: 8789 (WebUI API) 或 8788 (App Server)
- 启动后端时添加调试参数（已在 deploy.sh 中配置）
```

#### 3. 配置数据库连接

1. **打开 Database 工具**
2. **添加 PostgreSQL 连接**
   - Host: localhost
   - Port: 5432
   - Database: metasfresh
   - User: metasfresh
   - Password: metasfresh

### VSCode 配置（前端）

创建 `.vscode/settings.json`：

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "eslint.validate": [
    "javascript",
    "javascriptreact"
  ],
  "javascript.preferences.importModuleSpecifier": "relative"
}
```

---

## 🐛 常见问题

### 问题 1: Maven 构建失败

```bash
# 清理 Maven 缓存
rm -rf ~/.m2/repository

# 重新构建
mvn clean install -DskipTests -U
```

### 问题 2: 端口被占用

```bash
# 查找占用进程
lsof -i :8080
lsof -i :5432

# 杀掉进程
kill -9 <PID>
```

### 问题 3: Docker 内存不足

```bash
# 增加 Docker 内存限制
# Docker Desktop → Settings → Resources → Memory → 8GB+
```

### 问题 4: 前端依赖安装失败

```bash
# 清理缓存
rm -rf node_modules package-lock.json yarn.lock

# 重新安装
yarn install --force
```

### 问题 5: 数据库连接失败

```bash
# 检查数据库容器
docker logs metasfresh-infra-db

# 重启数据库
docker restart metasfresh-infra-db

# 等待 30 秒后重试
```

---

## 📚 下一步

环境搭建完成后，你可以：

1. **阅读代码规范**
   - [代码规范](../03-development/02-coding-standards.md)
   - [Git 工作流](../03-development/03-git-workflow.md)

2. **了解架构**
   - [系统架构](../02-fundamentals/02-architecture.md)
   - [后端架构](../04-backend/01-backend-architecture.md)

3. **开始开发**
   - [API 开发](../04-backend/04-api-development.md)
   - [组件开发](../05-frontend/02-component-development.md)

4. **运行测试**
   - [测试指南](../03-development/05-testing.md)

---

## 🆘 获取帮助

遇到问题？

- 📖 查看 [常见问题](./03-faq.md)
- 💬 访问 [论坛](https://forum.metasfresh.org)
- 🐛 提交 [Issue](https://github.com/metasfresh/metasfresh/issues)

---

**更新时间：** 2024-12-07  
**维护者：** metasfresh DevOps Team
