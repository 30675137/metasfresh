# metasfresh 项目概述

## 🌟 什么是 metasfresh？

metasfresh 是一个**开源的企业资源规划（ERP）系统**，专为中小企业设计，提供全面的业务管理解决方案。

### 核心特点

- ✅ **完全开源** - 基于 GPL-2.0 许可证
- 🌐 **Web 原生** - 基于现代 Web 技术构建
- 📱 **移动友好** - 支持移动端操作
- 🔧 **高度可定制** - 灵活的配置和扩展能力
- 🚀 **活跃开发** - 持续更新和改进
- 🌍 **多语言支持** - 支持多种语言界面

---

## 🎯 主要功能

### 1. 销售管理 (Sales)
- 📋 销售订单管理
- 💰 报价单生成
- 📊 销售分析和报表
- 👥 客户关系管理 (CRM)
- 🎯 销售目标跟踪

### 2. 采购管理 (Purchasing)
- 🛒 采购订单处理
- 📦 供应商管理
- 💵 采购价格管理
- 📈 采购分析

### 3. 库存管理 (Inventory)
- 📦 库存跟踪
- 🏭 仓库管理
- 📊 库存盘点
- 🔄 库存转移
- 📱 移动端收货和拣货

### 4. 生产制造 (Manufacturing)
- 🏭 生产计划
- 📋 工单管理
- 🔧 物料清单 (BOM)
- 📊 生产进度跟踪

### 5. 财务会计 (Finance)
- 💰 应收应付管理
- 📊 总账管理
- 🧾 发票处理
- 💳 银行对账
- 📈 财务报表

### 6. 物流管理 (Logistics)
- 🚚 发货管理
- 📦 收货处理
- 🔄 物流跟踪
- 🏭 仓储优化

---

## 🏗️ 技术架构

### 前端技术
```
React 16.14+
├── Redux (状态管理)
├── Webpack 5+ (构建工具)
├── Jest (测试框架)
└── ESLint (代码检查)
```

### 后端技术
```
Java 17+ / Spring Boot 3.x
├── Maven (构建工具)
├── Hibernate (ORM)
├── PostgreSQL 14+ (数据库)
├── RabbitMQ 3.9+ (消息队列)
└── Elasticsearch 7.17.8 (搜索引擎)
```

### 基础设施
```
Docker / Kubernetes
├── Docker Compose V2
├── Nginx (反向代理)
├── Redis (缓存)
└── Prometheus + Grafana (监控)
```

---

## 📊 项目模块结构

metasfresh 采用**模块化架构**，主要模块包括：

### 核心模块
```
backend/
├── de.metas.business/              # 核心业务逻辑
├── de.metas.ui.web.base/           # Web UI 基础
├── de.metas.async/                 # 异步任务处理
├── de.metas.elasticsearch/         # 搜索功能
└── de.metas.migration/             # 数据库迁移
```

### 业务模块
```
backend/
├── de.metas.salescandidate.base/   # 销售候选
├── de.metas.purchasecandidate.base/ # 采购候选
├── de.metas.contracts/             # 合同管理
├── de.metas.handlingunits.base/    # 物流单元
├── de.metas.manufacturing/         # 生产制造
└── de.metas.fresh/                 # 生鲜行业扩展
```

### 集成模块
```
backend/
├── de.metas.externalsystem/        # 外部系统集成
├── de.metas.edi/                   # EDI 集成
├── de.metas.payment.*/             # 支付集成
└── de.metas.shipper.gateway.*/     # 物流集成
```

---

## 🎭 适用场景

### 适合的企业类型
- 📦 **批发和分销企业**
- 🏭 **制造企业**
- 🍎 **生鲜食品行业**
- 🏪 **零售连锁企业**
- 🚚 **物流和供应链企业**

### 典型应用场景
1. **订单到发货流程** - 从接单到发货的完整流程管理
2. **库存优化** - 实时库存跟踪和智能补货
3. **生产计划** - MRP 物料需求计划
4. **财务管理** - 完整的财务会计功能
5. **多仓库管理** - 支持多仓库、多组织

---

## 🌍 社区和生态

### 官方资源
- 🌐 **官网：** https://metasfresh.com
- 📦 **GitHub：** https://github.com/metasfresh/metasfresh
- 💬 **论坛：** https://forum.metasfresh.org
- 📺 **YouTube：** https://www.youtube.com/c/metasfresh
- 📖 **文档：** https://docs.metasfresh.org

### 社区支持
- 💬 活跃的社区论坛
- 🐛 GitHub Issues 跟踪
- 📚 详细的文档和教程
- 🎓 定期的网络研讨会
- 🤝 贡献者指南

---

## 📈 发展历程

### 项目起源
- **创立时间：** 2015年
- **前身：** ADempiere ERP 的分支
- **创始团队：** metas GmbH (德国)
- **开源许可：** GPL-2.0

### 重要里程碑
- **2015** - 项目启动，从 ADempiere 分支
- **2016** - 发布第一个稳定版本
- **2017** - 引入 React 前端
- **2018** - 移动端应用发布
- **2019** - Kubernetes 支持
- **2020** - Spring Boot 升级
- **2021** - 微服务架构改造
- **2022** - Java 17 升级
- **2023** - Spring Boot 3.x 迁移
- **2024** - 持续优化和功能增强

---

## 🔑 核心优势

### 对比传统 ERP

| 特性 | metasfresh | 传统 ERP |
|------|-----------|----------|
| **成本** | 开源免费 | 高额授权费 |
| **部署** | Docker/K8s | 复杂安装 |
| **定制** | 源码可修改 | 受限定制 |
| **更新** | 持续更新 | 周期性升级 |
| **社区** | 活跃开源社区 | 厂商支持 |
| **移动端** | 原生支持 | 有限支持 |

### 技术优势
1. **现代化架构** - 基于 Spring Boot 和 React
2. **容器化部署** - 支持 Docker 和 Kubernetes
3. **高性能** - Elasticsearch 全文搜索
4. **可扩展** - 微服务架构，易于扩展
5. **API 友好** - RESTful API 和 WebSocket

---

## 🚀 快速开始

### 5分钟体验

```bash
# 1. 克隆项目
git clone https://github.com/metasfresh/metasfresh.git
cd metasfresh

# 2. 启动基础设施
./scripts/deploy.sh start infra

# 3. 访问服务
# RabbitMQ: http://localhost:15672 (metasfresh/metasfresh)
# PostgreSQL: localhost:5432 (metasfresh/metasfresh)
```

详细步骤请参考 [快速开始指南](../01-getting-started/01-quickstart.md)

---

## 🎓 学习路径

### 新手路径
1. 📖 阅读 [项目概述](./01-project-overview.md) ← 当前
2. 🚀 完成 [快速开始](../01-getting-started/01-quickstart.md)
3. 🏗️ 了解 [系统架构](./02-architecture.md)
4. 🛠️ 搭建 [开发环境](../01-getting-started/02-environment-setup.md)

### 开发者路径
1. 📚 学习 [核心概念](./04-core-concepts.md)
2. 🔧 熟悉 [开发指南](../03-development/01-dev-environment.md)
3. 💻 实践 [后端开发](../04-backend/01-backend-architecture.md)
4. ⚛️ 学习 [前端开发](../05-frontend/01-frontend-architecture.md)

### 运维路径
1. 🐳 掌握 [Docker 部署](../06-deployment/01-docker-deployment.md)
2. ☸️ 了解 [Kubernetes 部署](../06-deployment/02-kubernetes.md)
3. 📊 配置 [监控告警](../06-deployment/04-monitoring.md)
4. 💾 学习 [备份恢复](../06-deployment/05-backup-restore.md)

---

## 🤝 如何参与

### 贡献方式
- 🐛 **报告 Bug** - 提交 GitHub Issue
- 💡 **提出建议** - 在论坛讨论
- 📝 **完善文档** - 提交文档 PR
- 💻 **贡献代码** - 提交功能 PR
- 🌍 **翻译** - 帮助多语言支持
- 📢 **推广** - 分享使用经验

### 开始贡献
1. Fork 项目
2. 创建功能分支
3. 提交代码
4. 发起 Pull Request

详见 [贡献指南](../10-contributing/01-how-to-contribute.md)

---

## 📄 许可证

metasfresh 使用 **GPL-2.0 许可证**

- ✅ 自由使用
- ✅ 自由修改
- ✅ 自由分发
- ⚠️ 修改后的代码必须开源
- ⚠️ 商业使用需遵守 GPL 协议

详见：[LICENSE](https://github.com/metasfresh/metasfresh/blob/master/LICENSE.md)

---

## 📞 联系方式

- **Email：** info@metasfresh.com
- **论坛：** https://forum.metasfresh.org
- **Twitter：** @metasfresh
- **LinkedIn：** metasfresh

---

**下一篇：** [系统架构](./02-architecture.md)
