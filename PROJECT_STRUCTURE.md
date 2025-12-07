# 项目组织结构说明

本文档说明 metasfresh 项目的目录组织结构和文件管理规范。

## 📁 核心目录结构

```
metasfresh/
├── scripts/              # 📜 脚本文件目录
│   ├── deploy.sh        # 多环境部署脚本
│   └── README.md        # 脚本说明文档
│
├── docs/                # 📚 文档文件目录
│   ├── DEPLOYMENT.md    # 部署文档
│   └── README.md        # 文档索引
│
├── backend/             # ☕ Java 后端代码
├── frontend/            # ⚛️ React 前端代码
├── docker-builds/       # 🐳 Docker 构建配置
├── e2e/                 # 🧪 端到端测试
├── distribution/        # 📦 发布和部署配置
├── misc/                # 🔧 工具和支持文件
├── .qoder/              # 🤖 Qoder IDE 配置
│   └── rules/           # AI 辅助编码规则
│
├── README.md            # 项目主文档
├── CONTRIBUTING.md      # 贡献指南
├── CODE_OF_CONDUCT.md   # 行为准则
├── ReleaseNotes.md      # 发布说明
│
├── build.cmd            # Windows 构建脚本
├── run.cmd              # Windows 运行脚本
└── deploy.sh            # 部署脚本快捷方式 -> scripts/deploy.sh
```

## 📂 目录说明

### 1. scripts/ - 脚本文件目录

**用途：** 存放所有项目脚本文件

**包含内容：**
- 部署脚本
- 自动化脚本
- 工具脚本
- 辅助脚本

**访问方式：**
```bash
# 直接使用根目录软链接
./deploy.sh start dev

# 或使用完整路径
./scripts/deploy.sh start dev
```

### 2. docs/ - 文档文件目录

**用途：** 存放所有项目文档文件

**包含内容：**
- 部署文档
- 使用手册
- 设计文档
- API 文档
- 开发指南

**文档索引：** 查看 [docs/README.md](docs/README.md)

### 3. backend/ - 后端代码

**技术栈：** Java 17+, Spring Boot 3.x, Maven

**包含模块：**
- 业务逻辑模块
- REST API 模块
- 数据访问层
- 公共工具库

### 4. frontend/ - 前端代码

**技术栈：** React 16.14+, Redux, Webpack

**包含内容：**
- React 组件
- Redux 状态管理
- API 调用层
- 样式文件

### 5. docker-builds/ - Docker 构建

**用途：** Docker 镜像构建和容器编排

**包含内容：**
- Dockerfile 文件
- docker-compose 配置
- 构建脚本
- 环境配置

### 6. .qoder/ - Qoder IDE 配置

**用途：** Qoder IDE 和 AI 辅助编码配置

**包含内容：**
- 开发规范规则
- 代码风格定义
- AI 辅助配置

## 📋 文件管理规范

### 脚本文件规范

1. **存放位置：** 所有脚本统一放在 `scripts/` 目录
2. **命名规范：** 使用小写字母和连字符，如 `deploy-prod.sh`
3. **权限设置：** Shell 脚本需添加执行权限 `chmod +x`
4. **文档说明：** 每个脚本需在 `scripts/README.md` 中添加说明

### 文档文件规范

1. **存放位置：** 
   - 核心文档（README, CONTRIBUTING）保留在根目录
   - 详细文档放在 `docs/` 目录
2. **格式规范：** 使用 Markdown 格式
3. **命名规范：** 使用大写字母和下划线，如 `DEPLOYMENT.md`
4. **索引维护：** 更新 `docs/README.md` 文档索引

### 代码文件规范

1. **Java 代码：** 放在 `backend/` 对应模块
2. **React 代码：** 放在 `frontend/src/`
3. **测试代码：** 与源码同级的 `test/` 目录
4. **配置文件：** 放在对应模块的 `resources/` 目录

## 🚀 快速开始

### 新开发者

1. 克隆项目
   ```bash
   git clone <repository-url>
   cd metasfresh
   ```

2. 阅读文档
   ```bash
   # 查看项目概述
   cat README.md
   
   # 查看部署文档
   cat docs/DEPLOYMENT.md
   ```

3. 部署环境
   ```bash
   # 启动开发环境
   ./deploy.sh start dev
   ```

### 贡献者

1. 查看贡献指南
   ```bash
   cat CONTRIBUTING.md
   ```

2. 遵循代码规范
   ```bash
   cat .qoder/rules/metasfresh-dev-standards.md
   ```

3. 提交代码
   ```bash
   git checkout -b feature/your-feature
   # ... 开发和测试
   git commit -m "feat: your feature description"
   git push origin feature/your-feature
   ```

## 📚 相关文档

- [脚本说明](scripts/README.md) - 所有脚本的使用说明
- [文档索引](docs/README.md) - 所有文档的索引
- [部署文档](docs/DEPLOYMENT.md) - 详细的部署指南
- [贡献指南](CONTRIBUTING.md) - 如何贡献代码

## 🔄 版本历史

- **v1.0.0** - 2024-12-07
  - 创建 `scripts/` 和 `docs/` 目录
  - 添加多环境部署脚本
  - 完善项目文档结构

## 💡 改进建议

如果你有改进项目组织结构的建议，欢迎：

1. 提交 Issue 讨论
2. 提交 Pull Request
3. 在团队会议中提出

---

**维护者：** metasfresh DevOps Team  
**最后更新：** 2024-12-07
