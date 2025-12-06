# 全渠道零售与餐饮中台 Constitution

<!--
Sync Impact Report:
- Version change: Initial creation 0.0.0 → 1.0.0
- Added sections: All sections are new additions
- Templates requiring updates: plan-template.md (✅ updated), spec-template.md (✅ no changes needed), tasks-template.md (✅ no changes needed)
- Follow-up TODOs: RATIFICATION_DATE to be set when officially ratified by team
-->

## Core Principles

### I. 架构隔离与扩展性 (ARCHITECTURE ISOLATION & EXTENSIBILITY)

所有二次开发与扩展逻辑必须完全隔离在自研中台与前端层，严禁修改 metasfresh 核心代码。中台作为唯一可信源（SSOT），前端不得直连 metasfresh。

中台通过 REST API 或异步消息与 metasfresh 交互，所有接口调用必须实现缓存与限流机制。中台需要对 metasfresh 数据进行模型映射，避免泄露其内部结构。

所有核心领域模型由中台统一定义与管理，确保业务语义的独立性与演进自由度。

**Rationale**: 确保 metasfresh 可以平滑升级，避免核心 ERP 系统的二开债务，实现架构层面的可持续演进。

### II. 幂等性与可重试性 (IDEMPOTENCY & RETRY SAFETY)

所有写操作必须天然幂等，必须可安全重试。系统设计需假设网络不可靠、服务会暂时失败，任何操作在失败场景下重试不应产生副作用。

所有涉及库存扣减、订单创建、支付处理等关键业务操作必须具备完善的失败补偿机制与事务一致性保障。

**Rationale**: 在微服务与分布式环境下，幂等性是保证数据一致性的基础要求，避免重试导致的数据错乱。

### III. 领域驱动设计与 Clean Architecture (DDD & CLEAN ARCHITECTURE)

严格遵循领域驱动设计（DDD）原则，业务逻辑必须沉淀在领域层，禁止将商业逻辑写死在 Controller 或基础设施层。

采用 Clean Architecture 分层模式，确保业务规则独立于框架、数据库和外部接口，保持核心领域模型的纯粹性。

所有领域事件必须可观测、可追踪、可回放，支持业务审计与故障排查。

**Rationale**: 保持业务逻辑与技术实现解耦，提升代码可维护性、可测试性与业务表达力。

### IV. API 契约与版本化管理 (API CONTRACTS & VERSIONING)

所有 API 必须具备自动生成的 OpenAPI Schema，实现接口契约的标准化管理。

API 必须版本化（v1/v2），采用语义化版本管理，确保兼容演进。任何破坏性变更必须走版本升级流程，禁止静默修改现有契约。

所有跨系统交互必须使用标准 REST API 或异步消息，严禁绕过中台直接同步数据。

**Rationale**: 明确的 API 契约是微服务协作的基石，版本化管理保障演进过程中的向后兼容性。

### V. 质量门禁与测试自动化 (QUALITY GATES & TEST AUTOMATION)

单测覆盖率 ≥ 80%，关键路径必须具备集成测试与端到端测试。所有代码必须通过 Code Review，至少 1 名 reviewer 批准。

遵循测试驱动开发（TDD）原则，所有 API 与领域逻辑必须先写测试，测试失败后再实现。未经测试的代码禁止进入主分支。

**Rationale**: 高质量测试是保障系统稳定性的关键防线，自动化测试体系支撑持续交付与重构自信。

### VI. 可观测性与可追踪性 (OBSERVABILITY & TRACEABILITY)

所有领域事件、跨系统调用、库存/订单/支付等关键操作必须记录审计日志，支持事后追溯与合规审计。

建立完善的日志、监控与链路追踪体系，确保系统运行状态可观测，故障可快速定位。

所有查询接口必须支持分页、过滤与排序，避免大数据量查询导致性能问题。

**Rationale**: 可观测性是保障 SLA 与快速故障恢复的基础，审计日志满足合规与安全要求。

### VII. 安全性与权限控制 (SECURITY & RBAC)

统一认证采用 JWT + Refresh Token 机制，RBAC 权限控制系统化管理用户访问权限。

所有跨接口调用必须带签名或 Auth Header，防止未授权访问。API 输入必须严格校验，避免恶意数据破坏 metasfresh 数据完整性。

**Rationale**: 全渠道系统涉及交易与敏感数据，安全防护是必须保障的非功能性需求。

### VIII. 配置集中化管理 (CENTRALIZED CONFIGURATION)

所有配置必须集中化管理，采用 Nacos/Consul 或 Spring Config 等配置中心方案。

配置与代码分离，支持环境隔离、动态刷新与版本管理，避免配置散落在代码或本地文件中。

**Rationale**: 集中配置管理提升运维效率，支持多环境部署与动态调参。

### IX. 持续交付与部署自动化 (CI/CD & AUTOMATION)

所有变更必须走 Git Flow 或 Trunk-based 工作流，PR 流程标准化。发布必须采用灰度发布（Canary / Blue-Green）策略。

建立完整的 Runbook 与故障应急流程，生产环境必须具备 SLA 监控与告警机制。每次交付必须包括代码、文档、API Schema、架构图、数据库 Schema 与测试报告。

**Rationale**: 自动化交付流程提升发布效率与质量，灰度发布降低生产风险。

### X. 高可用与性能设计 (HIGH AVAILABILITY & PERFORMANCE)

服务 P95 延迟 < 200ms，API 可承受至少 1000 RPS（通过水平扩展实现）。SLA ≥ 99.9%，关键服务可用性不低于 99.95%。

所有中台功能必须无状态（stateless），支持横向扩展。涉及库存/订单/支付的数据必须具备强一致性，采用幂等 + 去重 + 分布式锁等机制保障。

支持多组织、多门店、多仓库架构，满足零售与餐饮业务的复杂组织管理需求。

**Rationale**: 全渠道零售与餐饮系统面临高并发业务场景，性能与高可用是核心架构目标。

## 禁止事项 (NON-NEGOTIABLE DON'TS)

### D1. 禁止直连 metasfresh 数据库

不允许直接连接 metasfresh 数据库进行写操作，所有数据变更必须通过中台 API 或 metasfresh 官方接口。

**Exception**: 只读数据同步场景需经架构评审，并确保不破坏 metasfresh 数据一致性。

### D2. 禁止前端直连 metasfresh

不允许前端直接调用 metasfresh API，必须通过中台统一通道层进行协议转换、安全校验与流量控制。

**Rationale**: 中台是前端唯一可信源，保障安全策略统一与接口稳定性。

### D3. 禁止商业逻辑写在 Controller

不允许把商业逻辑写死在 Controller 层，必须下沉到领域服务或聚合根中。

**Rationale**: 保持表现层轻量化，提升业务逻辑的复用性与可测试性。

### D4. 禁止未测试代码进入主分支

不允许未测试的代码进入主分支，所有提交必须通过自动化测试与 Code Review。

**Rationale**: 测试是质量保障的基本要求，不可妥协。

### D5. 禁止绕过中台直接同步数据

不允许绕过中台直接进行系统间的数据同步，所有数据流转必须经过中台统一调度。

**Rationale**: 中台是数据一致性的保障，绕过中台会导致数据孤岛与一致性问题。

## 技术栈规范 (TECHNOLOGY STACK)

### 前端技术栈
- **框架**: React 18 / Next.js 13+
- **移动端**: 微信小程序原生开发 / Taro 跨端框架
- **终端**: Web POS（基于 React 的 Pad/收银终端）
- **状态管理**: Zustand / Redux Toolkit
- **UI 组件**: Ant Design / shadcn/ui

### 中台技术栈
- **开发语言**: Java 17
- **框架**: Spring Boot 3.x
- **API 规范**: RESTful API + OpenAPI 3.0
- **数据库**: MySQL 8.0 / PostgreSQL 15
- **缓存**: Redis 7.x
- **消息队列**: RabbitMQ / RocketMQ
- **配置中心**: Nacos / Consul
- **API 网关**: Spring Cloud Gateway / Kong

### ERP 集成
- **核心系统**: metasfresh (未修改原版)
- **集成方式**: REST API + 异步消息
- **数据映射**: 中台领域模型 → metasfresh 内部模型

### 基础设施
- **容器化**: Docker
- **编排**: Kubernetes
- **CI/CD**: Jenkins / GitLab CI
- **监控**: Prometheus + Grafana
- **日志**: ELK Stack / Loki + Tempo
- **链路追踪**: SkyWalking / Jaeger

## 交付节奏 (DELIVERY CADENCE)

### 迭代模式
- **需求阶段**: `/speckit.specify` → 输出 Feature Specification
- **设计阶段**: `/speckit.plan` → 输出 Implementation Plan
- **任务拆分**: `/speckit.tasks` → 输出可执行任务列表
- **实施阶段**: `/speckit.implement` → 闭环实现所有任务

### 周期要求
- 每周形成一个可演示的迭代结果（Working Increment）
- 每个批次（Batch）必须有明确的 DOR（已准备条件）和 DOD（完成定义）
- 所有阶段必须闭环，禁止跨迭代遗留未完成特性

## 治理与演进 (GOVERNANCE & EVOLUTION)

### 章程效力
本章程是最高技术决策文档，优先于所有其他开发规范与实践。任何技术决策与代码实现必须符合章程规定。

### 修订流程
1. **提案**: 任何章程修订需提交书面 ADR（Architecture Decision Record）
2. **评审**: 需经过架构委员会评审与技术可行性分析
3. **批准**: 重大修订需技术委员会投票通过（2/3 多数）
4. **迁移**: 若修订导致破坏性变更，必须提供存量代码迁移计划
5. **版本**: 章程版本号遵循语义化版本规范（MAJOR.MINOR.PATCH）

### 合规审查
- 所有 PR 必须通过章程合规性检查（Constitution Check）
- 新增复杂性与技术债务必须提供书面理由说明
- 每季度进行章程适用性回顾，确保其与技术演进保持一致

### 版本管理
本章程采用语义化版本管理：
- **MAJOR**: 架构原则或禁止事项的重大变更（不兼容修订）
- **MINOR**: 新增原则、章节或规范性内容的扩展
- **PATCH**: 澄清性修订、错别字修正、表述优化等非语义性调整

**Version**: 1.0.0 | **Ratified**: 2025-12-06 | **Last Amended**: 2025-12-06
