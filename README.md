# Advertising Reel

A browsable web archive of a late-1980s / 1990s Argentine TV advertising reel, restored from a single tape capture.

**Live site:** https://nahuelseoane.github.io/stocker-portfolio/

## What this is

The source was one 21-minute MPEG-2 file captured from tape (PAL, 720×576, interlaced). Its 22 commercials ran back to back along with agency slates, color bars, countdowns, duplicates and stretches of damaged tape. The project:

1. **Mapped the reel.** Black-frame and scene-change detection with ffmpeg, plus timestamped contact sheets reviewed frame by frame, to find where each spot starts and ends. Slates such as "Agencia: J. W. Thompson · Cliente: Autolatina" provided the credits.
2. **Removed what isn't an ad.** Slates, color bars, countdowns and unrecoverable tape noise were dropped. Duplicate spots were detected by frame comparison (PSNR) and kept once.
3. **Converted to a modern format.** Each spot was deinterlaced (bwdif), converted from PAL's non-square pixels to square 768×576, given short fades at the cut points, and encoded to H.264/AAC MP4 with `faststart` for streaming.
4. **Built a menu.** A single dependency-free HTML page with a thumbnail grid, an inline player, previous/next buttons, a play-all mode and deep links (`#7` opens spot 7).

## Spots

Ford Pick-up “Orca” · Exquisita Gelatina (two edits) · Derby Suaves · Bioden (fragment) · Cisko · 7Up · Dufour Survival (three spots) · Adam's · Ford · VISA · Alfalfa DeKalb 192 · Nestlé Mash · Jockey · Shell Helix · Brahma (three spots) · Esso · Quilmes

## Layout

```
docs/            Website served by GitHub Pages (web-quality videos)
scripts/cuts.tsv Start and end time of each spot in the source file
scripts/build.sh Rebuilds every video and thumbnail from the source
```

The original capture and the high-quality masters are kept out of the repo.

## Rebuild

Requires ffmpeg and bc.

```sh
scripts/build.sh "Video 1.mpg"
```

---

All commercials are the property of their respective brands and agencies. Shared as a personal archive, not for commercial use.
