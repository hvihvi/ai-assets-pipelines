
# AI Assets pipelines

## Slice mp4 into frames

Ex: image input > midjourney "animate image" > mp4 > slice into frames
```bash
ffmpeg -i ./input/video.mp4 -vf "fps=4" input/video_%04d.png
```

## Convert jpeg to png

```bash
magick img.jpeg img.png
```

```bash
## Remove background from images

```bash
node remove-bg-batch.mjs . output
```
This will remove all backgrounds for images in `.` and save them in `output` folder.

or
```bash
./rm_bg_magick.sh
```
