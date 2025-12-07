# Scripts 目录

本目录包含 metasfresh 项目的所有脚本文件。

## 📁 目录结构

```
scripts/
├── deploy.sh           # 多环境一键部署脚本（推荐使用）
└── README.md           # 本文件
```

## 🚀 主要脚本

### deploy.sh - 多环境部署脚本

支持开发、测试、生产环境的一键部署和管理。

**快速使用：**
```bash
# 交互式部署
./scripts/deploy.sh

# 命令行模式
./scripts/deploy.sh start dev      # 启动开发环境
./scripts/deploy.sh stop dev       # 停止开发环境
./scripts/deploy.sh logs dev       # 查看日志
```

**详细文档：** 请查看 [部署文档](../docs/DEPLOYMENT.md)

## 📝 原有脚本

项目根目录下的原有脚本文件：
- `build.cmd` - Windows 构建脚本（保留在根目录）
- `run.cmd` - Windows 运行脚本（保留在根目录）

这些文件保留在根目录以保持向后兼容性。

## 🔗 使用建议

1. **新项目** - 使用 `scripts/deploy.sh` 进行部署
2. **Windows 用户** - 继续使用根目录的 `.cmd` 文件
3. **Linux/Mac 用户** - 推荐使用 `scripts/deploy.sh`

## 📚 相关文档

- [部署文档](../docs/DEPLOYMENT.md) - 详细的部署说明
- [项目 README](../README.md) - 项目主文档
