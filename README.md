
# AI Assets pipelines

## Slice mp4 into frames

Ex: image input > midjourney "animate image" > mp4 > slice into frames
```bash
ffmpeg -i ../bg_0_test.mp4 -vf "fps=4" bg_0_%04d.png
```

## Remove background from images

```bash
node remove-bg-batch.mjs . output
```
This will remove all backgrounds for images in `.` and save them in `output` folder.
