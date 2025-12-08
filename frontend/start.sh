#!/bin/bash
#
# metasfresh 前端启动脚本
# 自动设置必要的环境变量
#

echo "🚀 启动 metasfresh 前端开发服务器..."

# 设置 Node.js 兼容性选项
export NODE_OPTIONS=--openssl-legacy-provider

# 启动开发服务器
npm start
