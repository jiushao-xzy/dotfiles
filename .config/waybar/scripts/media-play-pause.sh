#!/usr/bin/env bash

# 获取播放状态
status=$(playerctl status 2>/dev/null)
if [[ "$status" != "Playing" && "$status" != "Paused" ]]; then
  echo "{\"text\":\"▶\"}"
  exit
fi

# 动态生成控制按钮
case $status in
  "Playing")
    play_icon="⏸"
    tooltip="Paused"
    ;;
  "Paused")
    play_icon="▶"
    tooltip="Playing"
    ;;
esac


# 生成JSON输出
echo "{\"text\":\" <span>$play_icon</span> \",\"tooltip\":\"$tooltip\"}"