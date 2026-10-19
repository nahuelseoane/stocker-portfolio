#!/usr/bin/env bash
# Splits the original tape capture into individual spots.
# Usage: scripts/build.sh "Video 1.mpg"
#   portfolio/ -> high-quality masters (CRF 20, kept off GitHub)
#   docs/      -> lighter web copies served by GitHub Pages (CRF 24)
set -euo pipefail
SRC=${1:?usage: build.sh <source.mpg>}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$ROOT/portfolio/videos" "$ROOT/docs/videos" "$ROOT/docs/thumbs"

while IFS=$'\t' read -r n slug start end; do
  name="$n-$slug"
  dur=$(echo "$end - $start" | bc)
  fade=$(echo "$dur - 0.3" | bc)

  # Master: deinterlace, convert PAL 16:15 pixels to square 768x576, short fades.
  ffmpeg -nostdin -loglevel error -y -ss "$start" -i "$SRC" -t "$dur" \
    -vf "bwdif,scale=768:576,setsar=1,fade=in:st=0:d=0.2,fade=out:st=$fade:d=0.3" \
    -af "afade=in:st=0:d=0.15,afade=out:st=$fade:d=0.3" \
    -c:v libx264 -preset slow -crf 20 -pix_fmt yuv420p -c:a aac -b:a 192k \
    -movflags +faststart "$ROOT/portfolio/videos/$name.mp4"

  # Web copy, made from the master.
  ffmpeg -nostdin -loglevel error -y -i "$ROOT/portfolio/videos/$name.mp4" \
    -c:v libx264 -preset slow -crf 24 -pix_fmt yuv420p -c:a aac -b:a 128k \
    -movflags +faststart "$ROOT/docs/videos/$name.mp4"

  # Thumbnail from 40% into the spot.
  ffmpeg -nostdin -loglevel error -y -ss "$(echo "$dur * 0.4" | bc)" \
    -i "$ROOT/portfolio/videos/$name.mp4" -frames:v 1 -vf scale=384:288 -q:v 4 \
    "$ROOT/docs/thumbs/$name.jpg"

  echo "done $name"
done < "$ROOT/scripts/cuts.tsv"
