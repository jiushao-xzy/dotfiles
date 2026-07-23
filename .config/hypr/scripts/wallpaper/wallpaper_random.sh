#!/bin/bash
WALL_GROUPS_DIR=~/Wallpapers
WALL_DIR=$(find "$WALL_GROUPS_DIR" -type f | shuf -n 1)
wal -i "$WALL_DIR" > /dev/null 2>&1

echo "$WALL_DIR" 
