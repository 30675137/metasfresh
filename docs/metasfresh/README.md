# metasfresh 项目文档中心

欢迎来到 metasfresh 开源 ERP 系统的完整文档库！

## 📚 文档导航

### 🚀 快速开始
- [欢迎指南](./Welcome.md) - 开始使用 metasfresh
- [快速上手](./01-getting-started/01-quickstart.md) - 5分钟快速体验
- [环境搭建](./01-getting-started/02-environment-setup.md) - 开发环境配置
- [常见问题](./01-getting-started/03-faq.md) - 新手常见问题

### 📖 基础知识
- [项目概述](./02-fundamentals/01-project-overview.md) - metasfresh 是什么
- [系统架构](./02-fundamentals/02-architecture.md) - 技术架构说明
- [技术栈](./02-fundamentals/03-tech-stack.md) - 使用的技术
- [核心概念](./02-fundamentals/04-core-concepts.md) - 重要概念解释

### 🛠️ 开发指南
- [开发环境](./03-development/01-dev-environment.md) - 配置开发环境
- [代码规范](./03-development/02-coding-standards.md) - 编码规范
- [Git 工作流](./03-development/03-git-workflow.md) - 分支和提交规范
- [调试技巧](./03-development/04-debugging.md) - 调试方法
- [测试指南](./03-development/05-testing.md) - 单元测试和集成测试

### 🏗️ 后端开发
- [后端架构](./04-backend/01-backend-architecture.md) - Java 后端架构
- [模块说明](./04-backend/02-modules.md) - 各模块功能介绍
- [数据库设计](./04-backend/03-database.md) - 数据库表结构
- [API 开发](./04-backend/04-api-development.md) - REST API 开发
- [业务逻辑](./04-backend/05-business-logic.md) - 核心业务逻辑

### ⚛️ 前端开发
- [前端架构](./05-frontend/01-frontend-architecture.md) - React 前端架构
- [组件开发](./05-frontend/02-component-development.md) - 组件开发指南
- [状态管理](./05-frontend/03-state-management.md) - Redux 状态管理
- [UI 规范](./05-frontend/04-ui-guidelines.md) - UI/UX 设计规范
- [前端测试](./05-frontend/05-frontend-testing.md) - 前端测试方法

### 🐳 部署运维
- [Docker 部署](./06-deployment/01-docker-deployment.md) - Docker 部署指南
- [Kubernetes 部署](./06-deployment/02-kubernetes.md) - K8s 部署
- [环境配置](./06-deployment/03-environment-config.md) - 多环境配置
- [监控告警](./06-deployment/04-monitoring.md) - 监控和日志
- [备份恢复](./06-deployment/05-backup-restore.md) - 数据备份策略

### 🔌 API 文档
- [REST API](./07-api/01-rest-api.md) - REST API 参考
- [WebSocket API](./07-api/02-websocket-api.md) - 实时通信 API
- [认证授权](./07-api/03-authentication.md) - 认证和授权机制
- [API 示例](./07-api/04-api-examples.md) - 常用 API 示例

### 💼 业务功能
- [销售管理](./08-features/01-sales.md) - 销售订单功能
- [采购管理](./08-features/02-purchasing.md) - 采购流程
- [库存管理](./08-features/03-inventory.md) - 库存和仓储
- [财务管理](./08-features/04-finance.md) - 财务会计功能
- [生产制造](./08-features/05-manufacturing.md) - 生产制造流程

### 🔧 工具和脚本
- [部署脚本](./09-tools/01-deployment-scripts.md) - 一键部署脚本
- [数据迁移](./09-tools/02-data-migration.md) - 数据迁移工具
- [开发工具](./09-tools/03-dev-tools.md) - 开发辅助工具
- [命令速查](./09-tools/04-command-reference.md) - 常用命令

### 🤝 贡献指南
- [如何贡献](./10-contributing/01-how-to-contribute.md) - 参与贡献
- [代码审查](./10-contributing/02-code-review.md) - Code Review 流程
- [问题报告](./10-contributing/03-issue-reporting.md) - 提交 Bug
- [社区规范](./10-contributing/04-community.md) - 社区行为准则

### 📋 附录
- [术语表](./11-appendix/01-glossary.md) - 专业术语解释
- [资源链接](./11-appendix/02-resources.md) - 相关资源
- [版本历史](./11-appendix/03-changelog.md) - 版本更新记录
- [参考文献](./11-appendix/04-references.md) - 参考文档

---

## 🗂️ 目录结构

```
docs/metasfresh/
├── README.md                          # 本文件 - 文档导航
├── Welcome.md                         # 欢迎页面
│
├── 01-getting-started/                # 快速开始
│   ├── 01-quickstart.md
│   ├── 02-environment-setup.md
│   └── 03-faq.md
│
├── 02-fundamentals/                   # 基础知识
│   ├── 01-project-overview.md
│   ├── 02-architecture.md
│   ├── 03-tech-stack.md
│   └── 04-core-concepts.md
│
├── 03-development/                    # 开发指南
│   ├── 01-dev-environment.md
│   ├── 02-coding-standards.md
│   ├── 03-git-workflow.md
│   ├── 04-debugging.md
│   └── 05-testing.md
│
├── 04-backend/                        # 后端开发
│   ├── 01-backend-architecture.md
│   ├── 02-modules.md
│   ├── 03-database.md
│   ├── 04-api-development.md
│   └── 05-business-logic.md
│
├── 05-frontend/                       # 前端开发
│   ├── 01-frontend-architecture.md
│   ├── 02-component-development.md
│   ├── 03-state-management.md
│   ├── 04-ui-guidelines.md
│   └── 05-frontend-testing.md
│
├── 06-deployment/                     # 部署运维
│   ├── 01-docker-deployment.md
│   ├── 02-kubernetes.md
│   ├── 03-environment-config.md
│   ├── 04-monitoring.md
│   └── 05-backup-restore.md
│
├── 07-api/                           # API 文档
│   ├── 01-rest-api.md
│   ├── 02-websocket-api.md
│   ├── 03-authentication.md
│   └── 04-api-examples.md
│
├── 08-features/                      # 业务功能
│   ├── 01-sales.md
│   ├── 02-purchasing.md
│   ├── 03-inventory.md
│   ├── 04-finance.md
│   └── 05-manufacturing.md
│
├── 09-tools/                         # 工具和脚本
│   ├── 01-deployment-scripts.md
│   ├── 02-data-migration.md
│   ├── 03-dev-tools.md
│   └── 04-command-reference.md
│
├── 10-contributing/                  # 贡献指南
│   ├── 01-how-to-contribute.md
│   ├── 02-code-review.md
│   ├── 03-issue-reporting.md
│   └── 04-community.md
│
└── 11-appendix/                      # 附录
    ├── 01-glossary.md
    ├── 02-resources.md
    ├── 03-changelog.md
    └── 04-references.md
```

---

## 📖 使用说明

### 查看文档

1. **在线浏览**
   - 使用 GitHub 在线查看
   - 使用 Obsidian 本地查看（推荐）

2. **本地查看**
   ```bash
   # 使用 Obsidian 打开
   open docs/metasfresh
   ```

3. **生成网站**
   ```bash
   # 使用 MkDocs 生成文档网站
   mkdocs serve
   ```

### 编辑文档

1. **Markdown 格式**
   - 所有文档使用 Markdown 格式
   - 支持 GitHub Flavored Markdown

2. **图片资源**
   ```
   docs/metasfresh/assets/
   ├── images/          # 图片文件
   ├── diagrams/        # 架构图
   └── screenshots/     # 截图
   ```

3. **文档模板**
   - 使用统一的文档模板
   - 包含标题、目录、内容、相关链接

### 搜索文档

1. **全文搜索**
   - 使用 Obsidian 的搜索功能
   - 使用 `grep` 命令行搜索

2. **标签系统**
   - 使用 `#标签` 标记文档主题
   - 便于分类和检索

---

## 🎯 文档编写原则

### 1. 清晰性
- 使用简洁明了的语言
- 避免复杂的技术术语
- 提供代码示例

### 2. 完整性
- 覆盖所有重要功能
- 提供完整的操作步骤
- 包含错误处理说明

### 3. 实用性
- 提供可运行的示例
- 包含常见问题解决方案
- 快速索引和导航

### 4. 一致性
- 使用统一的格式
- 遵循命名规范
- 保持风格一致

---

## 🔄 文档更新

### 版本管理
- 每次重大更新记录版本号
- 在 `11-appendix/03-changelog.md` 记录变更

### 审核流程
1. 编写或修改文档
2. 提交 Pull Request
3. 团队审核
4. 合并到主分支

### 反馈机制
- 通过 GitHub Issues 提交文档问题
- 在社区论坛讨论文档改进
- 定期收集用户反馈

---

## 📬 联系方式

- **官方网站：** https://metasfresh.com
- **GitHub：** https://github.com/metasfresh/metasfresh
- **论坛：** https://forum.metasfresh.org
- **文档问题：** 提交 GitHub Issue

---

## 📄 许可证

本文档采用 [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) 许可证。

---

**最后更新：** 2024-12-07  
**文档版本：** 1.0.0  
**维护者：** metasfresh Documentation Team
