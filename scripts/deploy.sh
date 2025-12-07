#!/bin/bash

################################################################################
# metasfresh 一键部署脚本
# 支持开发(dev)、测试(test)、生产(prod)环境隔离
# 作者: metasfresh DevOps Team
# 版本: 1.0.0
################################################################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录（脚本在 scripts/ 目录下，所以需要上一级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE_DIR="${PROJECT_ROOT}/docker-builds/compose"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示 banner
show_banner() {
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║        metasfresh ERP 一键部署脚本                        ║
║        Multi-Environment Deployment Tool                  ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
}

# 检查依赖
check_dependencies() {
    log_info "检查系统依赖..."
    
    local missing_deps=()
    
    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
    fi
    
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        missing_deps+=("docker-compose")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "缺少依赖: ${missing_deps[*]}"
        log_error "请先安装 Docker 和 Docker Compose"
        exit 1
    fi
    
    # 检查 Docker 是否运行
    if ! docker info &> /dev/null; then
        log_error "Docker 服务未运行，请先启动 Docker"
        exit 1
    fi
    
    log_success "依赖检查通过"
}

# 环境选择
select_environment() {
    echo ""
    echo "请选择部署环境:"
    echo "  1) 开发环境 (Development)  - 端口 8080"
    echo "  2) 测试环境 (Testing)      - 端口 8081"
    echo "  3) 生产环境 (Production)   - 端口 8080"
    echo "  4) 仅基础设施 (Infra Only) - 只启动数据库等"
    echo ""
    
    read -p "请输入选项 [1-4]: " env_choice
    
    case $env_choice in
        1)
            ENV="dev"
            ENV_NAME="开发环境"
            ;;
        2)
            ENV="test"
            ENV_NAME="测试环境"
            ;;
        3)
            ENV="prod"
            ENV_NAME="生产环境"
            ;;
        4)
            ENV="infra"
            ENV_NAME="仅基础设施"
            ;;
        *)
            log_error "无效的选项"
            exit 1
            ;;
    esac
    
    log_info "已选择: ${ENV_NAME}"
}

# 创建环境配置
create_env_config() {
    local env=$1
    local env_file="${COMPOSE_DIR}/.env.${env}"
    
    log_info "创建 ${env} 环境配置文件..."
    
    case $env in
        dev)
            cat > "${env_file}" << 'EOF'
# 开发环境配置
COMPOSE_PROJECT_NAME=metasfresh-dev
mfregistry=metasfresh
mfversion=local

# 数据库类型
dbqualifier=preloaded

# 端口映射（开发环境）
DB_PORT=15432
RABBITMQ_PORT=5672
RABBITMQ_MGMT_PORT=15672
ES_PORT=9200
ES_TRANSPORT_PORT=9300
WEBAPI_PORT=8080
WEBAPI_DEBUG_PORT=8789
APP_PORT=8282
APP_DEBUG_PORT=8788
WEBUI_PORT=80
WEBUI_HTTPS_PORT=443
MOBILE_PORT=8880

# JVM 配置（开发环境 - 较小内存）
WEBAPI_JAVA_OPTS=-Xmx512M -XX:+HeapDumpOnOutOfMemoryError -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8789
APP_JAVA_OPTS=-Xmx1024M -XX:+HeapDumpOnOutOfMemoryError -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8788
ES_JAVA_OPTS=-Xms128M -Xmx256m

# 日志级别
LOG_LEVEL=DEBUG

# 数据持久化目录
DATA_DIR=./data/dev
EOF
            ;;
        test)
            cat > "${env_file}" << 'EOF'
# 测试环境配置
COMPOSE_PROJECT_NAME=metasfresh-test
mfregistry=metasfresh
mfversion=local

# 数据库类型
dbqualifier=preloaded

# 端口映射（测试环境）
DB_PORT=25432
RABBITMQ_PORT=5673
RABBITMQ_MGMT_PORT=25672
ES_PORT=9201
ES_TRANSPORT_PORT=9301
WEBAPI_PORT=8081
WEBAPI_DEBUG_PORT=8790
APP_PORT=8283
APP_DEBUG_PORT=8789
WEBUI_PORT=8180
WEBUI_HTTPS_PORT=8443
MOBILE_PORT=8881

# JVM 配置（测试环境）
WEBAPI_JAVA_OPTS=-Xmx768M -XX:+HeapDumpOnOutOfMemoryError -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8790
APP_JAVA_OPTS=-Xmx1536M -XX:+HeapDumpOnOutOfMemoryError -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8789
ES_JAVA_OPTS=-Xms256M -Xmx512m

# 日志级别
LOG_LEVEL=INFO

# 数据持久化目录
DATA_DIR=./data/test
EOF
            ;;
        prod)
            cat > "${env_file}" << 'EOF'
# 生产环境配置
COMPOSE_PROJECT_NAME=metasfresh-prod
mfregistry=metasfresh
mfversion=5.174

# 数据库类型
dbqualifier=preloaded

# 端口映射（生产环境）
DB_PORT=5432
RABBITMQ_PORT=5672
RABBITMQ_MGMT_PORT=15672
ES_PORT=9200
ES_TRANSPORT_PORT=9300
WEBAPI_PORT=8080
APP_PORT=8282
WEBUI_PORT=80
WEBUI_HTTPS_PORT=443
MOBILE_PORT=8880

# JVM 配置（生产环境 - 更大内存，禁用调试）
WEBAPI_JAVA_OPTS=-Xmx2048M -XX:+HeapDumpOnOutOfMemoryError -XX:+UseG1GC
APP_JAVA_OPTS=-Xmx4096M -XX:+HeapDumpOnOutOfMemoryError -XX:+UseG1GC
ES_JAVA_OPTS=-Xms1G -Xmx2G

# 日志级别
LOG_LEVEL=WARN

# 数据持久化目录
DATA_DIR=./data/prod
EOF
            ;;
        infra)
            cat > "${env_file}" << 'EOF'
# 仅基础设施配置
COMPOSE_PROJECT_NAME=metasfresh-infra
mfregistry=metasfresh
mfversion=local

# 数据库类型
dbqualifier=preloaded

# 端口映射（基础设施）
DB_PORT=5432
RABBITMQ_PORT=5672
RABBITMQ_MGMT_PORT=15672
ES_PORT=9200
ES_TRANSPORT_PORT=9300

# ES JVM 配置
ES_JAVA_OPTS=-Xms256M -Xmx512m

# 数据持久化目录
DATA_DIR=./data/infra
EOF
            ;;
    esac
    
    log_success "环境配置文件已创建: ${env_file}"
}

# 创建环境特定的 docker-compose 文件
create_docker_compose() {
    local env=$1
    local compose_file="${COMPOSE_DIR}/docker-compose.${env}.yml"
    
    log_info "创建 ${env} 环境 Docker Compose 文件..."
    
    if [ "$env" = "infra" ]; then
        # 仅基础设施服务
        cat > "${compose_file}" << 'EOF'
version: '3.8'

services:
  db:
    image: postgres:14
    container_name: ${COMPOSE_PROJECT_NAME}-db
    ports:
      - "${DB_PORT}:5432"
    environment:
      POSTGRES_DB: metasfresh
      POSTGRES_USER: metasfresh
      POSTGRES_PASSWORD: metasfresh
      PGDATA: /var/lib/postgresql/data
    volumes:
      - ${DATA_DIR}/postgres:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U metasfresh"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  rabbitmq:
    image: rabbitmq:3.9.13-management
    container_name: ${COMPOSE_PROJECT_NAME}-rabbitmq
    ports:
      - "${RABBITMQ_PORT}:5672"
      - "${RABBITMQ_MGMT_PORT}:15672"
    environment:
      RABBITMQ_DEFAULT_USER: metasfresh
      RABBITMQ_DEFAULT_PASS: metasfresh
      RABBITMQ_DEFAULT_VHOST: /
    volumes:
      - ${DATA_DIR}/rabbitmq:/var/lib/rabbitmq
    healthcheck:
      test: rabbitmq-diagnostics -q status
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  elasticsearch:
    image: elasticsearch:7.17.8
    container_name: ${COMPOSE_PROJECT_NAME}-es
    ports:
      - "${ES_PORT}:9200"
      - "${ES_TRANSPORT_PORT}:9300"
    environment:
      - discovery.type=single-node
      - LOG4J_FORMAT_MSG_NO_LOOKUPS=true
      - "ES_JAVA_OPTS=${ES_JAVA_OPTS}"
    volumes:
      - ${DATA_DIR}/elasticsearch:/usr/share/elasticsearch/data
    healthcheck:
      test: ["CMD-SHELL", "curl --fail --silent http://localhost:9200/_cluster/health | grep -q '\"status\":\"green\"\\|\"status\":\"yellow\"'"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

volumes:
  postgres:
  rabbitmq:
  elasticsearch:
EOF
    else
        # 完整服务
        cp "${COMPOSE_DIR}/compose.yml" "${compose_file}"
        
        # 修改为使用环境变量的端口
        sed -i.bak 's/"15432:5432"/"${DB_PORT}:5432"/g' "${compose_file}"
        sed -i.bak 's/"5672:5672"/"${RABBITMQ_PORT}:5672"/g' "${compose_file}"
        sed -i.bak 's/"15672:15672"/"${RABBITMQ_MGMT_PORT}:15672"/g' "${compose_file}"
        sed -i.bak 's/"9200:9200"/"${ES_PORT}:9200"/g' "${compose_file}"
        sed -i.bak 's/"9300:9300"/"${ES_TRANSPORT_PORT}:9300"/g' "${compose_file}"
        sed -i.bak 's/"8080:8080"/"${WEBAPI_PORT}:8080"/g' "${compose_file}"
        sed -i.bak 's/"8282:8282"/"${APP_PORT}:8282"/g' "${compose_file}"
        sed -i.bak 's/"80:80"/"${WEBUI_PORT}:80"/g' "${compose_file}"
        sed -i.bak 's/"443:443"/"${WEBUI_HTTPS_PORT}:443"/g' "${compose_file}"
        sed -i.bak 's/"8880:80"/"${MOBILE_PORT}:80"/g' "${compose_file}"
        
        # 添加容器名和重启策略
        sed -i.bak '/^services:/a\
\
  db:\
    container_name: ${COMPOSE_PROJECT_NAME}-db\
    restart: unless-stopped' "${compose_file}"
        
        rm -f "${compose_file}.bak"
    fi
    
    log_success "Docker Compose 文件已创建: ${compose_file}"
}

# 创建数据目录
create_data_directories() {
    local env=$1
    source "${COMPOSE_DIR}/.env.${env}"
    
    log_info "创建数据持久化目录..."
    
    mkdir -p "${COMPOSE_DIR}/${DATA_DIR}"/{postgres,rabbitmq,elasticsearch,logs/{webapi,app}}
    
    log_success "数据目录已创建: ${COMPOSE_DIR}/${DATA_DIR}"
}

# 启动服务
start_services() {
    local env=$1
    local compose_file="${COMPOSE_DIR}/docker-compose.${env}.yml"
    local env_file="${COMPOSE_DIR}/.env.${env}"
    
    log_info "启动 ${ENV_NAME} 服务..."
    
    cd "${COMPOSE_DIR}"
    
    docker compose -f "${compose_file}" --env-file "${env_file}" up -d
    
    log_success "服务启动完成"
}

# 显示服务状态
show_service_status() {
    local env=$1
    local compose_file="${COMPOSE_DIR}/docker-compose.${env}.yml"
    local env_file="${COMPOSE_DIR}/.env.${env}"
    
    echo ""
    log_info "服务状态:"
    docker compose -f "${compose_file}" --env-file "${env_file}" ps
}

# 显示访问信息
show_access_info() {
    local env=$1
    source "${COMPOSE_DIR}/.env.${env}"
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                   服务访问地址                             ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    
    if [ "$env" = "infra" ]; then
        echo "  🗄️  PostgreSQL:        localhost:${DB_PORT}"
        echo "  📡 RabbitMQ 管理界面:  http://localhost:${RABBITMQ_MGMT_PORT}"
        echo "      用户名: metasfresh"
        echo "      密码:   metasfresh"
        echo "  🔍 Elasticsearch:      http://localhost:${ES_PORT}"
    else
        echo "  🌐 Web 界面:          http://localhost:${WEBUI_PORT}"
        echo "      用户名: metasfresh"
        echo "      密码:   metasfresh"
        echo ""
        echo "  📱 Mobile 界面:       http://localhost:${MOBILE_PORT}"
        echo "      用户名: cynthia"
        echo "      密码:   metasfresh"
        echo ""
        echo "  🗄️  PostgreSQL:        localhost:${DB_PORT}"
        echo "  📡 RabbitMQ 管理:     http://localhost:${RABBITMQ_MGMT_PORT}"
        echo "  🔍 Elasticsearch:      http://localhost:${ES_PORT}"
        echo "  📚 API WebUI:         http://localhost:${WEBAPI_PORT}"
        echo "  📚 API App:           http://localhost:${APP_PORT}"
        
        if [ "$env" = "dev" ] || [ "$env" = "test" ]; then
            echo ""
            echo "  🐛 调试端口:"
            echo "      WebAPI: ${WEBAPI_DEBUG_PORT}"
            echo "      App:    ${APP_DEBUG_PORT}"
        fi
    fi
    
    echo ""
    echo "  📁 数据目录:          ${COMPOSE_DIR}/${DATA_DIR}"
    echo "  📋 日志目录:          ${COMPOSE_DIR}/${DATA_DIR}/logs"
    echo ""
}

# 显示管理命令
show_management_commands() {
    local env=$1
    
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                   常用管理命令                             ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "  查看日志:    ./deploy.sh logs ${env}"
    echo "  停止服务:    ./deploy.sh stop ${env}"
    echo "  重启服务:    ./deploy.sh restart ${env}"
    echo "  查看状态:    ./deploy.sh status ${env}"
    echo "  清理环境:    ./deploy.sh clean ${env}"
    echo ""
}

# 查看日志
view_logs() {
    local env=$1
    local compose_file="${COMPOSE_DIR}/docker-compose.${env}.yml"
    local env_file="${COMPOSE_DIR}/.env.${env}"
    
    cd "${COMPOSE_DIR}"
    docker compose -f "${compose_file}" --env-file "${env_file}" logs -f
}

# 停止服务
stop_services() {
    local env=$1
    local compose_file="${COMPOSE_DIR}/docker-compose.${env}.yml"
    local env_file="${COMPOSE_DIR}/.env.${env}"
    
    log_info "停止 ${env} 环境服务..."
    
    cd "${COMPOSE_DIR}"
    docker compose -f "${compose_file}" --env-file "${env_file}" down
    
    log_success "服务已停止"
}

# 重启服务
restart_services() {
    local env=$1
    local compose_file="${COMPOSE_DIR}/docker-compose.${env}.yml"
    local env_file="${COMPOSE_DIR}/.env.${env}"
    
    log_info "重启 ${env} 环境服务..."
    
    cd "${COMPOSE_DIR}"
    docker compose -f "${compose_file}" --env-file "${env_file}" restart
    
    log_success "服务已重启"
}

# 清理环境
clean_environment() {
    local env=$1
    local compose_file="${COMPOSE_DIR}/docker-compose.${env}.yml"
    local env_file="${COMPOSE_DIR}/.env.${env}"
    
    source "${env_file}"
    
    log_warning "此操作将删除所有容器和数据卷！"
    read -p "确定要清理 ${env} 环境吗? (yes/no): " confirm
    
    if [ "$confirm" = "yes" ]; then
        log_info "清理 ${env} 环境..."
        
        cd "${COMPOSE_DIR}"
        docker compose -f "${compose_file}" --env-file "${env_file}" down -v
        
        # 删除数据目录
        if [ -d "${COMPOSE_DIR}/${DATA_DIR}" ]; then
            rm -rf "${COMPOSE_DIR}/${DATA_DIR}"
            log_success "数据目录已删除"
        fi
        
        log_success "环境清理完成"
    else
        log_info "取消清理操作"
    fi
}

# 主函数
main() {
    show_banner
    
    # 检查依赖
    check_dependencies
    
    # 处理命令
    if [ $# -eq 0 ]; then
        # 交互式部署
        select_environment
        create_env_config "$ENV"
        create_docker_compose "$ENV"
        create_data_directories "$ENV"
        start_services "$ENV"
        show_service_status "$ENV"
        show_access_info "$ENV"
        show_management_commands "$ENV"
    else
        # 命令行模式
        case "$1" in
            start)
                if [ -z "$2" ]; then
                    log_error "请指定环境: dev, test, prod, infra"
                    exit 1
                fi
                ENV=$2
                create_env_config "$ENV"
                create_docker_compose "$ENV"
                create_data_directories "$ENV"
                start_services "$ENV"
                show_service_status "$ENV"
                show_access_info "$ENV"
                ;;
            stop)
                if [ -z "$2" ]; then
                    log_error "请指定环境: dev, test, prod, infra"
                    exit 1
                fi
                stop_services "$2"
                ;;
            restart)
                if [ -z "$2" ]; then
                    log_error "请指定环境: dev, test, prod, infra"
                    exit 1
                fi
                restart_services "$2"
                ;;
            status)
                if [ -z "$2" ]; then
                    log_error "请指定环境: dev, test, prod, infra"
                    exit 1
                fi
                show_service_status "$2"
                ;;
            logs)
                if [ -z "$2" ]; then
                    log_error "请指定环境: dev, test, prod, infra"
                    exit 1
                fi
                view_logs "$2"
                ;;
            clean)
                if [ -z "$2" ]; then
                    log_error "请指定环境: dev, test, prod, infra"
                    exit 1
                fi
                clean_environment "$2"
                ;;
            *)
                echo "使用方法:"
                echo "  交互模式:     ./deploy.sh"
                echo "  启动服务:     ./deploy.sh start <env>"
                echo "  停止服务:     ./deploy.sh stop <env>"
                echo "  重启服务:     ./deploy.sh restart <env>"
                echo "  查看状态:     ./deploy.sh status <env>"
                echo "  查看日志:     ./deploy.sh logs <env>"
                echo "  清理环境:     ./deploy.sh clean <env>"
                echo ""
                echo "环境选项: dev, test, prod, infra"
                exit 1
                ;;
        esac
    fi
}

# 执行主函数
main "$@"
