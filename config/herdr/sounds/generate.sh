#!/usr/bin/env bash
#
# Regenerates request.mp3 and done.mp3 — short tones synthesized with
# ffmpeg's sine source, not derived from any OS or third-party sound asset.
# Re-run after editing the frequencies/durations below, then check by ear:
#   afplay request.mp3 && afplay done.mp3

set -eou pipefail

cd "$(dirname "$0")"

# request.mp3 — "needs attention": quick rising two-note blip
ffmpeg -y \
  -f lavfi -i "sine=frequency=880:duration=0.08" \
  -f lavfi -i "sine=frequency=1318:duration=0.10" \
  -filter_complex "[0:a]afade=t=in:d=0.005:curve=tri,afade=t=out:st=0.06:d=0.02:curve=tri[a0];[1:a]afade=t=in:d=0.005:curve=tri,afade=t=out:st=0.07:d=0.03:curve=tri[a1];[a0][a1]concat=n=2:v=0:a=1,volume=0.35[out]" \
  -map "[out]" -ar 44100 -q:a 4 request.mp3

# done.mp3 — "finished": descending three-note chime with a softer tail
ffmpeg -y \
  -f lavfi -i "sine=frequency=1318:duration=0.12" \
  -f lavfi -i "sine=frequency=1046:duration=0.12" \
  -f lavfi -i "sine=frequency=880:duration=0.28" \
  -filter_complex "[0:a]afade=t=in:d=0.005:curve=tri,afade=t=out:st=0.09:d=0.03:curve=tri[a0];[1:a]afade=t=in:d=0.005:curve=tri,afade=t=out:st=0.09:d=0.03:curve=tri[a1];[2:a]afade=t=in:d=0.005:curve=tri,afade=t=out:st=0.15:d=0.13:curve=tri[a2];[a0][a1][a2]concat=n=3:v=0:a=1,volume=0.3[out]" \
  -map "[out]" -ar 44100 -q:a 4 done.mp3
