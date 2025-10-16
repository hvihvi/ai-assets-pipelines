#!/usr/bin/env bash
in="${1:-input}"
out="${2:-output}"
mkdir -p "$out"

shopt -s nullglob nocaseglob
for f in "$in"/*.{png,jpg,jpeg,webp}; do
  base="$(basename "${f%.*}")"

  magick "$f" \
    -colorspace sRGB -alpha on \
    -fill black \
    -draw "rectangle %[fx:int(w*0.9)],%[fx:int(h*0.9)] %[w],%[h]" \
    -fuzz 8% -transparent "#000000" \
    PNG32:"$out/$base.png"
done
