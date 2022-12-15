GoPro Fusion to Geotagged Photos

A very work-in-progress script for generating geotagged images out of
GoPro Fusion (360) videos.

Implements the guide at https://www.trekview.org/blog/2021/turn-360-video-into-timelapse-images-part-1/

See also https://www.trekview.org/trail-maker/

Some notes:
- Generated H264 and ProRes from Fusion 1.2 (macOS M1) doesn't output GPS data. This
  script pulls that gps data from the front video feed

Doesn't yet support:
- Timezones properly (Sydney AEDT offset applied manually)
- Less than 1 second between frames (needs some work on subseconds, possible in theory)