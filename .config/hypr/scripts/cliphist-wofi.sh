#!/bin/bash

# 调出 wofi 选择历史
selected=$(cliphist list |  wofi --dmenu --allow-images --normal-window --width 400 --prompt="Clipboard")
[ -z "$selected" ] && exit 0

# 提取条目 ID 和 MIME/预览信息
id=$(echo "$selected" | awk '{print $1}')
preview=$(echo "$selected" | cut -f2)

echo $id
echo $preview

# 根据类型决定如何复制
if [[ "$preview" == image/* ]]; then
    # 图片：需要指定 MIME 类型
    cliphist decode "$id" | wl-copy --type "$preview"
else
    # 文本：直接复制，wl-copy 会自动识别
    cliphist decode "$id" | wl-copy
fi

