// remove-bg-batch.mjs
import { readdir, mkdir, readFile, writeFile } from "node:fs/promises";
import { join, extname } from "node:path";
import sharp from "sharp";
import { removeBackground } from "@imgly/background-removal-node";

const inputDir = process.argv[2] ?? "input";
const outputDir = process.argv[3] ?? "output";

await mkdir(outputDir, { recursive: true });

// only process visible PNG/JPG files (skip .DS_Store, AppleDouble "._*" etc.)
const exts = new Set([".png", ".jpg", ".jpeg", ".webp"]);
const files = (await readdir(inputDir)).filter(
  (f) =>
    !f.startsWith(".") &&
    !f.startsWith("._") &&
    exts.has(extname(f).toLowerCase()),
);

for (const name of files) {
  try {
    const inPath = join(inputDir, name);
    const outPath = join(outputDir, name.replace(/\.(jpe?g|webp)$/i, ".png"));

    // 1) Normalize → plain PNG RGBA, sRGB
    const normalized = await sharp(await readFile(inPath))
      .ensureAlpha()
      .toColorspace("srgb")
      .png({ force: true })
      .toBuffer();

    // 2) Remove background (explicit MIME)
    const blob = new Blob([normalized], { type: "image/png" });
    const result = await removeBackground(blob);

    // 3) Save result
    const outBuf = Buffer.from(await result.arrayBuffer());
    await writeFile(outPath, outBuf);
    console.log("Processed", name);
  } catch (e) {
    console.error("Failed", name, "-", e?.message ?? e);
  }
}
