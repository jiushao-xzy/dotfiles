#!/bin/bash
# 把 dotfiles 仓库下的所有文件，按相对路径软链接到 $HOME
# - 只链接文件本身，永不链接目录（避免应用运行时数据污染仓库）
# - 目标父目录不存在时自动创建
# - 目标已存在且不是软链接时跳过（保护用户数据）
#
# 用法：
#   bash config_load.sh           # 部署整个 dotfiles
#   bash config_load.sh .config   # 只处理 .config 子目录

set -euo pipefail

# 脚本所在目录（仓库根）的绝对路径
ROOT="$(cd "$(dirname "$0")" && pwd)"

# 根据可选参数确定源 / 目标根目录
SUBDIR="${1:-}"
if [ -n "$SUBDIR" ]; then
    SRC="$ROOT/$SUBDIR"
    DST="$HOME/$SUBDIR"
else
    SRC="$ROOT"
    DST="$HOME"
fi

# 不应被链接的路径（相对 SRC；路径等于某项、或位于某项目录下都排除）
EXCLUDE=(".git" ".gitignore" "config_load.sh" "pkglist.txt" "foreignpkglist.txt" "install_file" "xlogout")

is_excluded() {
    local rel="$1" pat
    for pat in "${EXCLUDE[@]}"; do
        if [ "$rel" = "$pat" ] || [[ "$rel" = "$pat/"* ]]; then
            return 0
        fi
    done
    return 1
}

# 遍历 SRC 下所有普通文件
# -type f：自动跳过目录和软链接本身，只处理真实文件
# -print0：用 NUL 分隔，配合 read -d '' 正确处理含空格/特殊字符的文件名
find "$SRC" -type f -print0 | while IFS= read -r -d '' src; do
    # 相对 SRC 的路径
    rel="${src#"$SRC"/}"

    # 排除项跳过
    if is_excluded "$rel"; then
        continue
    fi

    target="$DST/$rel"

    # 创建目标父目录（-p：已存在不报错）
    mkdir -p "$(dirname "$target")"

    # 目标已存在且不是软链接：跳过保护
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "跳过 $target（已存在且非软链接）"
        continue
    fi

    # 创建/覆盖软链接
    # -s：软链接  -f：强制覆盖已有 target  -n：target 是目录型软链接时替换而非递归进入
    ln -sfn "$src" "$target"
    echo "已链接 $target -> $src"
done

echo "完成"
