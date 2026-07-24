#!/bin/bash
# 把 dotfiles 仓库下指定的路径部署到 $HOME，采用白名单 + 策略区分：
#
#   LINK_PATHS  递归链接对象
#               - 若是目录：递归进入，对每个普通文件单独创建软链接
#               - 若是文件：直接创建软链接
#               - 目标已存在且不是软链接时跳过（保护用户数据）
#
#   COPY_PATHS  整体复制对象
#               - 目录用 cp -r 整体复制；文件直接复制
#               - 目标已存在则跳过（视为「初始化」语义）
#
# 未列入任一列表的路径一律不处理。
#
# 用法：
#   bash config_load.sh           # 部署整个白名单
#   bash config_load.sh .config   # 只处理位于 .config 下的白名单项

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SUBDIR="${1:-}"

# === 白名单（相对仓库根的路径）===
LINK_PATHS=(
    ".config"
    ".local"
    ".zsh"
    ".proxyrc"
    ".vimrc"
    ".zshrc"
    "razer-dpi.py"
)

COPY_PATHS=(
    "install_file"
    "xlogout"
)

# === 工具函数 ===

# 判断白名单项是否落在 SUBDIR 下（SUBDIR 为空时恒真）
should_process() {
    local p="$1"
    [ -z "$SUBDIR" ] && return 0
    [ "$p" = "$SUBDIR" ] || [[ "$p" = "$SUBDIR/"* ]]
}

# 单文件软链接：$1=源绝对路径 $2=相对仓库根的路径
link_one() {
    local src="$1" rel="$2"
    local target="$HOME/$rel"

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "跳过 $target（已存在且非软链接）"
        return
    fi

    ln -sfn "$src" "$target"
    echo "已链接 $target -> $src"
}

# 递归链接一个白名单项：目录则递归，文件则直接链接
link_path() {
    local rel="$1"
    local src="$ROOT/$rel"

    if [ ! -e "$src" ]; then
        echo "源不存在：$src" >&2
        return
    fi

    if [ -d "$src" ]; then
        find "$src" -type f -print0 | while IFS= read -r -d '' f; do
            link_one "$f" "${f#"$ROOT"/}"
        done
    elif [ -f "$src" ]; then
        link_one "$src" "$rel"
    fi
}

# 整体复制一个白名单项
copy_path() {
    local rel="$1"
    local src="$ROOT/$rel"
    local target="$HOME/$rel"

    if [ ! -e "$src" ]; then
        echo "源不存在：$src" >&2
        return
    fi

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ]; then
        echo "跳过 $target（已存在）"
        return
    fi

    cp -r "$src" "$target"
    echo "已复制 $target <- $src"
}

# === 主流程 ===
for p in "${LINK_PATHS[@]}"; do
    should_process "$p" && link_path "$p"
done

for p in "${COPY_PATHS[@]}"; do
    should_process "$p" && copy_path "$p"
done

echo "完成"
