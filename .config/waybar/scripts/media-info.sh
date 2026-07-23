#!/usr/bin/env bash


# 获取播放状态
status=$(playerctl status 2>/dev/null)
if [[ "$status" != "Playing" && "$status" != "Paused" ]]; then
  echo "{\"text\":\"启动音乐播放器\"}"
  exit
fi

# 获取歌曲信息
metadata=$(playerctl -p $(playerctl -l) metadata --format '{{artist}} - {{title}}')
if [ -z "$metadata" ]; then
  metadata=$(playerctl -p $(playerctl -l) metadata --format '{{title}}')
fi

# 处理长文本
max_len=35
if [ ${#metadata} -gt $max_len ]; then
  metadata="${metadata:0:$max_len}…"
  exit
fi

# 生成JSON输出
echo "{\"text\":\"$metadata\"}"