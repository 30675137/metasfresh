# metasfresh 多环境部署脚本使用指南

## 🚀 快速开始

### 第一次使用

```bash
# 1. 给脚本添加执行权限（已完成）
chmod +x deploy.sh

# 2. 运行脚本（交互模式）
./deploy.sh
```

## 💡 常用命令

### 启动服务
```bash
./deploy.sh start dev      # 启动开发环境
./deploy.sh start test     # 启动测试环境
./deploy.sh start prod     # 启动生产环境
./deploy.sh start infra    # 只启动基础设施
```

### 停止服务
```bash
./deploy.sh stop dev       # 停止开发环境
./deploy.sh stop test      # 停止测试环境
```

### 其他操作
```bash
./deploy.sh restart dev    # 重启开发环境
./deploy.sh status dev     # 查看服务状态
./deploy.sh logs dev       # 查看实时日志（Ctrl+C 退出）
./deploy.sh clean dev      # 清理环境（删除所有数据）
```

## 🌐 访问地址

### 开发环境 (dev)
- Web界面: http://localhost:80
- Mobile界面: http://localhost:8880
- 数据库: localhost:15432
- RabbitMQ: http://localhost:15672

### 测试环境 (test)
- Web界面: http://localhost:8180
- Mobile界面: http://localhost:8881
- 数据库: localhost:25432
- RabbitMQ: http://localhost:25672

### 生产环境 (prod)
- Web界面: http://localhost:80
- Mobile界面: http://localhost:8880
- 数据库: localhost:5432
- RabbitMQ: http://localhost:15672

## 🔑 登录信息

### Web 界面
- 用户名: `metasfresh`
- 密码: `metasfresh`

### Mobile 界面
- 用户名: `cynthia`
- 密码: `metasfresh`

### RabbitMQ 管理界面
- 用户名: `metasfresh`
- 密码: `metasfresh`

## 📁 数据存储

所有数据保存在：
```
docker-builds/compose/data/
├── dev/          # 开发环境数据
├── test/         # 测试环境数据
├── prod/         # 生产环境数据
└── infra/        # 基础设施数据
```

## 🎯 快速示例

### 场景1：开发
```bash
./deploy.sh start dev      # 启动
# 访问 http://localhost:80
./deploy.sh stop dev       # 停止
```

### 场景2：测试
```bash
./deploy.sh start test     # 启动
# 访问 http://localhost:8180
./deploy.sh logs test      # 查看日志
./deploy.sh stop test      # 停止
```

### 场景3：只需要数据库
```bash
./deploy.sh start infra    # 只启动基础设施
```

### 场景4：重新开始
```bash
./deploy.sh clean dev      # 清理环境
./deploy.sh start dev      # 重新启动
```

## 🔧 环境隔离说明

| 特性 | 开发(dev) | 测试(test) | 生产(prod) |
|------|----------|-----------|-----------|
| Web端口 | 80 | 8180 | 80 |
| 数据库端口 | 15432 | 25432 | 5432 |
| 调试端口 | ✅ 开启 | ✅ 开启 | ❌ 关闭 |
| JVM内存 | 小(512M/1G) | 中(768M/1.5G) | 大(2G/4G) |
| 日志级别 | DEBUG | INFO | WARN |
| 数据目录 | data/dev | data/test | data/prod |

## ❓ 常见问题

### 端口被占用
```bash
# 查看端口占用
lsof -i :8080

# 停止占用进程
kill -9 <PID>
```

### 服务无法启动
```bash
# 查看日志
./deploy.sh logs dev

# 检查 Docker 是否运行
docker info
```

### 重置环境
```bash
# 清理并重新启动
./deploy.sh clean dev
./deploy.sh start dev
```

## 📝 注意事项

1. 首次启动需要下载 Docker 镜像，可能需要几分钟
2. 清理环境会删除所有数据，请谨慎操作
3. 不同环境使用不同端口，可以同时运行
4. 生产环境建议使用更强的密码

## 🆘 获取帮助

```bash
# 查看帮助信息
./deploy.sh
```
