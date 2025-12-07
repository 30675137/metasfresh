# 一键启动 metasfresh

> 3 分钟快速启动 metasfresh ERP 系统，无需复杂配置！

---

## ⚡ 超快启动（推荐）

### 方式一：交互式启动（最简单）

```bash
# 直接运行，跟随提示操作
./deploy.sh
```

会出现友好的菜单，选择你需要的环境即可：
```
请选择部署环境:
  1) 开发环境 (Development)  - 适合本地开发
  2) 测试环境 (Testing)      - 适合测试验证
  3) 生产环境 (Production)   - 适合正式使用
  4) 仅基础设施 (Infra)      - 只启动数据库等

请输入选项 [1-4]: 1
```

### 方式二：命令行启动（最快速）

```bash
# 开发环境（推荐新手）
./deploy.sh start dev

# 等待 2-5 分钟，完成！
# 浏览器访问：http://localhost
```

---

## 🎯 一键操作命令

### 核心命令（只需记住这几个）

```bash
# 1️⃣ 启动
./deploy.sh start dev

# 2️⃣ 查看状态
./deploy.sh status dev

# 3️⃣ 停止
./deploy.sh stop dev
```

### 完整命令表

| 操作 | 命令 | 说明 |
|------|------|------|
| 🚀 启动 | `./deploy.sh start dev` | 一键启动所有服务 |
| ⏸️ 停止 | `./deploy.sh stop dev` | 停止但保留数据 |
| 🔄 重启 | `./deploy.sh restart dev` | 重启所有服务 |
| 📊 状态 | `./deploy.sh status dev` | 查看运行状态 |
| 📝 日志 | `./deploy.sh logs dev` | 实时查看日志 |
| 🗑️ 清理 | `./deploy.sh clean dev` | 删除所有数据重新开始 |

> 💡 **提示**：将上面的 `dev` 替换为 `test` 或 `prod` 即可操作不同环境

---

## 🌐 启动后访问这里

### 📱 用户界面

**开发环境启动后：**

```
🌐 Web 端：    http://localhost
📱 移动端：    http://localhost:8880
```

**测试环境启动后：**

```
🌐 Web 端：    http://localhost:8180
📱 移动端：    http://localhost:8881
```

### 🔧 管理界面（可选）

| 服务 | 开发环境 | 测试环境 |
|------|---------|--------|
| RabbitMQ | http://localhost:15672 | http://localhost:25672 |
| 数据库 | localhost:15432 | localhost:25432 |

---

## 🔑 默认登录信息

> ⚠️ 生产环境请务必修改密码！

**Web 管理端：**
```
用户名：metasfresh
密码：  metasfresh
```

**移动端：**
```
用户名：cynthia
密码：  metasfresh
```

---

## 💾 数据存储位置

所有数据自动保存在本地：
```
docker-builds/compose/data/
├── dev/          # 开发环境（约 2GB）
├── test/         # 测试环境
├── prod/         # 生产环境
└── infra/        # 仅基础设施
```

> 💡 不同环境数据完全隔离，互不影响

---

## 📖 典型使用场景

### 场景 1：第一次使用（开发学习）

```bash
# 1. 一键启动开发环境
./deploy.sh start dev

# 2. 等待 2-5 分钟（首次需下载镜像）
# 看到 "服务启动完成" 提示

# 3. 打开浏览器
open http://localhost

# 4. 使用完毕后停止
./deploy.sh stop dev
```

### 场景 2：日常开发（每天使用）

```bash
# 早上开始工作
./deploy.sh start dev

# 查看服务是否正常
./deploy.sh status dev

# 晚上下班停止
./deploy.sh stop dev
```

### 场景 3：同时运行多个环境

```bash
# 开发环境（端口 80）
./deploy.sh start dev

# 测试环境（端口 8180）
./deploy.sh start test

# 两个环境互不干扰！
```

### 场景 4：只需要数据库等基础服务

```bash
# 只启动 PostgreSQL + RabbitMQ + Elasticsearch
./deploy.sh start infra

# 适合本地开发后端时使用
```

### 场景 5：遇到问题，重新开始

```bash
# 清理环境（⚠️ 会删除所有数据）
./deploy.sh clean dev

# 重新启动
./deploy.sh start dev
```

---

## ⚙️ 环境说明

### 选择合适的环境

| 环境 | 适用场景 | 端口 | 配置 |
|------|---------|------|------|
| **dev** 🔧 | 日常开发学习 | 80 | 小内存，调试开启 |
| **test** 🧪 | 测试验证 | 8180 | 中等配置 |
| **prod** 🚀 | 生产使用 | 80 | 大内存，性能优化 |
| **infra** 🗄️ | 仅数据库等 | 原端口 | 最小化 |

### 详细对比

| 特性 | dev | test | prod |
|------|-----|------|------|
| 内存占用 | ~2GB | ~4GB | ~8GB |
| 启动时间 | 2-3分钟 | 3-4分钟 | 4-5分钟 |
| 远程调试 | ✅ | ✅ | ❌ |
| 日志详细度 | 最详细 | 中等 | 仅警告 |
| 推荐用途 | 学习开发 | 功能测试 | 正式环境 |

---

## ❓ 遇到问题？看这里！

### 问题 1：启动失败

**症状：** 执行命令后报错

```bash
# 检查 Docker 是否运行
docker info

# 如果报错，启动 Docker Desktop
# macOS: 打开 Docker Desktop 应用
# Linux: sudo systemctl start docker
```

### 问题 2：端口被占用

**症状：** 提示端口 80 或 8080 被占用

```bash
# 查找占用进程
lsof -i :80

# 方案1：关闭占用进程
kill -9 <PID>

# 方案2：使用测试环境（不同端口）
./deploy.sh start test
```

### 问题 3：服务状态异常

**症状：** status 显示服务 Unhealthy

```bash
# 查看详细日志
./deploy.sh logs dev

# 重启服务
./deploy.sh restart dev
```

### 问题 4：访问不了界面

**症状：** 浏览器无法打开 http://localhost

```bash
# 1. 检查服务状态
./deploy.sh status dev

# 2. 确认所有服务都是 "Up (healthy)"

# 3. 等待 1-2 分钟（首次启动需要时间）

# 4. 如果还是不行，查看日志
./deploy.sh logs dev
```

### 问题 5：想重新开始

```bash
# ⚠️ 注意：会删除所有数据！
./deploy.sh clean dev
./deploy.sh start dev
```

---

## ⏱️ 启动时间参考

| 场景 | 预计时间 | 说明 |
|------|---------|------|
| 首次启动 | 5-10 分钟 | 需要下载镜像（约 3GB） |
| 二次启动 | 2-3 分钟 | 镜像已缓存，直接启动 |
| 仅基础设施 | 1-2 分钟 | 服务少，启动快 |

---

## 💡 使用技巧

### 技巧 1：后台运行

```bash
# 启动后可以关闭终端
./deploy.sh start dev

# 需要时再查看日志
./deploy.sh logs dev
```

### 技巧 2：自动启动

```bash
# 编辑 ~/.zshrc 或 ~/.bashrc
echo 'alias mf-start="cd ~/metasfresh && ./deploy.sh start dev"' >> ~/.zshrc

# 以后只需输入
mf-start
```

### 技巧 3：资源监控

```bash
# 查看 Docker 资源使用
docker stats

# 查看具体服务资源
docker stats metasfresh-dev-webapi
```

---

## ⚠️ 重要提醒

- ✅ **首次启动**：需下载镜像，请耐心等待
- ✅ **多环境运行**：dev 和 test 可同时运行
- ⚠️ **清理操作**：会删除所有数据，谨慎使用
- ⚠️ **生产环境**：务必修改默认密码
- 💾 **数据备份**：重要数据请定期备份

---

## 🆘 需要帮助？

1. **查看帮助信息**
   ```bash
   ./deploy.sh
   ```

2. **查看完整文档**
   - [部署脚本详细说明](../../09-tools/01-deployment-scripts.md)
   - [Docker 部署指南](../../06-deployment/01-docker-deployment.md)

3. **遇到问题**
   - GitHub Issues: https://github.com/metasfresh/metasfresh/issues
   - 社区论坛: https://forum.metasfresh.org

---

**恭喜！你已掌握一键启动 metasfresh 🎉**

**下一步：** [环境搭建完整指南](./02-environment-setup.md)
