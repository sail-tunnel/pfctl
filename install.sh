#!/bin/bash
# ============================================
# pfctl 一键安装 / 卸载脚本
# https://github.com/sail-tunnel/pfctl
#
# 安装:
#   bash <(curl -fsSL https://raw.githubusercontent.com/sail-tunnel/pfctl/main/install.sh)
#
# 卸载:
#   bash <(curl -fsSL https://raw.githubusercontent.com/sail-tunnel/pfctl/main/install.sh) --uninstall
# ============================================

set -e

REPO="sail-tunnel/pfctl"
BRANCH="main"
INSTALL_DIR="/usr/local/bin"
BIN_NAME="pfctl"
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/${BIN_NAME}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

# ---- 环境检查 ----

check_root() {
    [[ $EUID -ne 0 ]] && error "请以 root 权限运行此脚本（sudo）"
}

check_os() {
    if [[ "$(uname)" != "Linux" ]]; then
        error "此工具仅支持 Linux 系统"
    fi
}

check_deps() {
    local missing=()
    for cmd in iptables curl; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        warn "缺少依赖: ${missing[*]}"
        if command -v apt &>/dev/null; then
            info "正在通过 apt 安装..."
            apt update -qq && apt install -y -qq "${missing[@]}"
        elif command -v yum &>/dev/null; then
            info "正在通过 yum 安装..."
            yum install -y "${missing[@]}"
        elif command -v dnf &>/dev/null; then
            info "正在通过 dnf 安装..."
            dnf install -y "${missing[@]}"
        else
            error "请手动安装: ${missing[*]}"
        fi
    fi
    return 0
}

# ---- 安装 ----

do_install() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     pfctl - iptables 端口转发工具    ║${NC}"
    echo -e "${CYAN}║     https://github.com/${REPO}  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
    echo ""

    check_root
    check_os
    check_deps

    info "正在下载 pfctl ..."
    if curl -fsSL "$RAW_URL" -o "${INSTALL_DIR}/${BIN_NAME}"; then
        chmod +x "${INSTALL_DIR}/${BIN_NAME}"
        info "安装成功！"
    else
        error "下载失败，请检查网络连接"
    fi

    echo ""
    echo -e "  安装路径:  ${GREEN}${INSTALL_DIR}/${BIN_NAME}${NC}"
    echo -e "  版本检查:  ${CYAN}pfctl --help${NC}"
    echo ""
    echo -e "  ${YELLOW}快速开始:${NC}"
    echo -e "    pfctl add  -p 8080 -d 1.2.3.4          # 添加转发"
    echo -e "    pfctl list                              # 查看规则"
    echo -e "    pfctl del  -p 8080 -d 1.2.3.4           # 删除规则"
    echo -e "    pfctl save                              # 持久化规则"
    echo -e "    pfctl update                            # 自更新"
    echo -e "    pfctl version                           # 查看版本"
    echo ""
}

# ---- 卸载 ----

do_uninstall() {
    check_root

    if [[ -f "${INSTALL_DIR}/${BIN_NAME}" ]]; then
        rm -f "${INSTALL_DIR}/${BIN_NAME}"
        info "已卸载 ${INSTALL_DIR}/${BIN_NAME}"
    else
        warn "pfctl 未安装 (${INSTALL_DIR}/${BIN_NAME} 不存在)"
    fi
}

# ---- 主逻辑 ----

case "${1:-}" in
    --uninstall|-u|uninstall)
        do_uninstall
        ;;
    *)
        do_install
        ;;
esac
