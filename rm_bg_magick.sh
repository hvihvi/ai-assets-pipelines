in="${1:-input}"
out="${2:-output}"
mkdir -p "$out"

shopt -s nullglob nocaseglob
for f in "$in"/*.{png,jpg,jpeg,webp}; do
  base="$(basename "${f%.*}")"
  magick "$f" \
    -colorspace sRGB -alpha on \
    -fuzz 8% -transparent "#000000" \
    PNG32:"$out/$base.png"
done

