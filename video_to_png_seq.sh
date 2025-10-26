#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./pipeline.sh input_video.mp4
#
# Output frames end up in ./output

VIDEO_PATH="${1:?You must pass a video file path, e.g. ./pipeline.sh ./clip.mp4}"

# --- config ---
FPS=15                # captured animation framerate

# --- working dirs ---
ROOT_DIR="$(pwd)"
FRAMES_DIR="$ROOT_DIR/__frames_tmp"     # raw ffmpeg dump
CLEAN_DIR="$ROOT_DIR/__clean_tmp"       # bg-removed frames
FINAL_DIR="$ROOT_DIR/output"            # final cleaned frames

echo "▶ Starting pipeline for: $VIDEO_PATH"
echo "   FPS=$FPS"

# fresh temp dirs
rm -rf "$FRAMES_DIR" "$CLEAN_DIR"
mkdir -p "$FRAMES_DIR" "$CLEAN_DIR" "$FINAL_DIR"

########################################
# 1. video → frames
########################################
echo "▶ Step 1: Extracting frames with ffmpeg -> $FRAMES_DIR"
ffmpeg -i "$VIDEO_PATH" -vf "fps=${FPS}" "$FRAMES_DIR/frame_%04d.png"

########################################
# 2. cleanup backgrounds / watermark corner
########################################
echo "▶ Step 2: Cleaning bg -> $FINAL_DIR"

# Remove black background and wipe watermark/star in bottom right
shopt -s nullglob nocaseglob
for f in "$FRAMES_DIR"/*.png; do
  base="$(basename "${f%.*}")"

  magick "$f" \
    -colorspace sRGB -alpha on \
    -fill black \
    -draw "rectangle %[fx:int(w*0.9)],%[fx:int(h*0.9)] %[w],%[h]" \
    -fuzz 8% -transparent "#000000" \
    PNG32:"$FINAL_DIR/$base.png"
done

########################################
# 3. cleanup temps
########################################
echo "▶ Cleaning temp dirs"
rm -rf "$FRAMES_DIR" "$CLEAN_DIR"

echo "✅ Done!"
echo "Final cleaned frames are in: $FINAL_DIR"
