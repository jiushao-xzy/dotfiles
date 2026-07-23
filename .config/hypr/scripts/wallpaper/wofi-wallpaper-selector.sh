#!/usr/bin/env bash
# Configuration
# WALLPAPER_DIR="$HOME/Pictures/wallpapers"  # Change this to your wallpaper directory
WALLPAPER_DIR="$HOME/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="250"  # Size of thumbnails in pixels (16:9)
THUMBNAIL_HEIGHT="141"
# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Function to generate thumbnail
generate_thumbnail() {
    local input="$1"
    local output="$2"
    #magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
    # 对 GIF，取第一帧做缩略图；其他格式直接处理
    if [[ "$input" =~ \.gif$ ]]; then
        magick "${input}[0]" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" \
            -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
    else
        magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" \
            -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
    fi
}

# Create shuffle icon thumbnail on the fly
SHUFFLE_ICON="$CACHE_DIR/shuffle_thumbnail.png"
# Create a properly sized shuffle icon thumbnail
# magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:#1e1e2e \
#     "$HOME/.config/hypr/scripts/wallpaper/assets/shuffle.png" -resize "120x120" -gravity center -composite \
#     "$SHUFFLE_ICON"
magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:#1e1e2e \
    \( "$HOME/.config/hypr/scripts/wallpaper/assets/shuffle.png" -resize "80x80" \) \
    -gravity center -composite "$SHUFFLE_ICON"

# Generate thumbnails and create menu items
generate_menu() {
    # Add random/shuffle option with a name that sorts first (using ! prefix)
    echo -en "img:$SHUFFLE_ICON\x00info:!Random Wallpaper\x1fRANDOM\n"
    
    # Then add all wallpapers
    for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif,webp}; do
        # Skip if no matches found
        [[ -f "$img" ]] || continue
        
        # Generate thumbnail filename
        thumbnail="$CACHE_DIR/$(basename "${img%.*}").png"
        
        # Generate thumbnail if it doesn't exist or is older than source
        if [[ ! -f "$thumbnail" ]] || [[ "$img" -nt "$thumbnail" ]]; then
            generate_thumbnail "$img" "$thumbnail"
        fi
        
        # Output menu item (filename and path)
        echo -en "img:$thumbnail\x00info:$(basename "$img")\x1f$img\n"
    done
}

# Use wofi to display grid of wallpapers - IMPORTANT: added --sort-order=default
selected=$(generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --define "image-size=${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
    --columns 3 \
    --allow-images \
    --normal-window \
    --insensitive \
    --sort-order=default \
    --prompt "Select Wallpaper" \
    --conf ~/.config/wofi/wallpaper.conf \
  )

# Set wallpaper if one was selected
if [ -n "$selected" ]; then
    # Remove the img: prefix to get the cached thumbnail path
    thumbnail_path="${selected#img:}"

    # Check if random wallpaper was selected
    if [[ "$thumbnail_path" == "$SHUFFLE_ICON" ]]; then
        # Select a random wallpaper from the directory
        #original_path=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
	original_path=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1)
    else
        # Get the original filename from the thumbnail path
        original_filename=$(basename "${thumbnail_path%.*}")

        # Find the corresponding original file in the wallpaper directory
        original_path=$(find "$WALLPAPER_DIR" -type f -name "${original_filename}.*" | head -n1)
    fi

    # Ensure a valid wallpaper was found before proceeding
    if [ -n "$original_path" ]; then
        # Set wallpaper using swww with the original file
        # /home/blackgaze/Scripts/hyprWallpaper.sh "$original_path"

        awww img "$original_path" --transition-type any

        wal -i "$original_path" > /dev/null 2>&1
        killall -SIGUSR2 waybar

        # Save the selection for persistence
        echo "$original_path" > "$HOME/.cache/current_wallpaper"

        # Optional: Notify user
        notify-send "Wallpaper" "Wallpaper has been updated" -i "$original_path"
    else
        notify-send "Wallpaper Error" "Could not find the original wallpaper file."
    fi
fi
