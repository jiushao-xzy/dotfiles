#!/bin/bash
WALL_GROUP_DIR=~/Wallpapers

WALL_DIR=$(yad --file --add-preview --large-preview \
    --filename="$WALL_GROUP_DIR" \
    --width=800 --height=600 \
    --title="Select Wallpaper"
    --text="Please select a wallpaper"
    --file-filter="img | *.jpg *.jpeg *.png *.webp"\
    --file-filter="All | *.*")

awww img "$WALL_DIR" \
    --transition-type any
