#!/bin/bash

# Claude Code Router 配置部署脚本
# 功能：将配置文件拷贝到 Router 目录，并备份原有文件

set -e  # 遇到错误立即退出

# 配置路径
SOURCE_CONFIG="config.json"
TARGET_DIR="$HOME/.claude-code-router"
TARGET_CONFIG="$TARGET_DIR/config.json"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo "════════════════════════════════════════"
echo "  Claude Code Router 配置部署工具"
echo "════════════════════════════════════════"
echo ""

# 检查源文件是否存在
if [ ! -f "$SOURCE_CONFIG" ]; then
    echo -e "${RED}✗ 源配置文件不存在: $SOURCE_CONFIG${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 找到源配置文件${NC}"
echo "  路径: $SOURCE_CONFIG"
echo ""

# 检查并创建目标目录
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}⚠ 目标目录不存在，正在创建...${NC}"
    mkdir -p "$TARGET_DIR"
    echo -e "${GREEN}✓ 已创建目录: $TARGET_DIR${NC}"
    echo ""
fi

# 生成时间戳
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 备份原有配置文件（如果存在）
if [ -f "$TARGET_CONFIG" ]; then
    BACKUP_FILE="${TARGET_CONFIG}.${TIMESTAMP}.bak"
    echo -e "${YELLOW}⚠ 检测到现有配置文件，正在备份...${NC}"
    mv "$TARGET_CONFIG" "$BACKUP_FILE"
    echo -e "${GREEN}✓ 已备份原配置文件${NC}"
    echo "  备份位置: $BACKUP_FILE"
    echo ""
fi

# 备份目标目录中的其他文件
echo "正在备份目标目录中的其他文件..."
BACKUP_COUNT=0

# 备份所有 .json 文件（除了刚才备份的）
for file in "$TARGET_DIR"/*.json; do
    # 检查文件是否存在（避免通配符没有匹配时出错）
    [ -e "$file" ] || continue
    
    # 跳过已经是备份文件的
    if [[ "$file" == *.bak ]]; then
        continue
    fi
    
    # 跳过刚才备份的config.json
    if [ "$file" == "$TARGET_CONFIG" ]; then
        continue
    fi
    
    # 备份文件
    BASENAME=$(basename "$file")
    BACKUP_FILE="${file}.${TIMESTAMP}.bak"
    mv "$file" "$BACKUP_FILE"
    echo -e "${GREEN}  ✓ 已备份: $BASENAME${NC}"
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
done

if [ $BACKUP_COUNT -eq 0 ]; then
    echo "  ℹ 没有需要备份的其他文件"
fi
echo ""

# 拷贝新配置文件
echo "正在部署新配置..."
cp "$SOURCE_CONFIG" "$TARGET_CONFIG"
chmod 600 "$TARGET_CONFIG"
echo -e "${GREEN}✓ 配置文件已部署${NC}"
echo "  目标位置: $TARGET_CONFIG"
echo ""

# 验证配置文件格式
echo "正在验证配置文件格式..."
if command -v python3 &> /dev/null; then
    if python3 -m json.tool "$TARGET_CONFIG" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 配置文件格式正确${NC}"
    else
        echo -e "${RED}✗ 配置文件格式有误，请检查 JSON 格式${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠ 未找到 python3，跳过格式验证${NC}"
fi
echo ""

# 显示配置摘要
echo "配置摘要:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v python3 &> /dev/null; then
    # 提取 Providers 信息
    python3 << 'EOF'
import json
import os
config_path = os.path.expanduser("~/.claude-code-router/config.json")
with open(config_path, "r") as f:
    config = json.load(f)

providers = config.get("Providers", [])
router = config.get("Router", {})

print(f"  Providers: {len(providers)} 个")
for p in providers:
    name = p.get("name", "unknown")
    models = p.get("models", [])
    print(f"    - {name}: {len(models)} 个模型")
    for model in models:
        print(f"        • {model}")

print("")
print("  路由策略:")
for key, value in router.items():
    if key != "longContextThreshold":
        print(f"    - {key}: {value}")
EOF
else
    cat "$TARGET_CONFIG"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 提示重启
echo -e "${YELLOW}⚠ 提示：配置已更新，需要重启 Claude Code Router 以应用更改${NC}"
echo ""
echo "重启命令:"
echo "  ccr restart"
echo ""
echo -e "${GREEN}✅ 部署完成！${NC}"
echo ""
