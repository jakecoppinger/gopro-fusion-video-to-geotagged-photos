GoPro Fusion to Geotagged Photos
================================

A very work-in-progress script for generating geotagged images out of
GoPro Fusion (360) videos.

It uses the front and rear images separately, and is not designed to be used on equirectangular images
(such as the output from Fusion Studio).

Implements the guide at https://www.trekview.org/blog/2021/turn-360-video-into-timelapse-images-part-1/

See also https://www.trekview.org/trail-maker/ (though the download link seems to be missing)

Supports:
- up to 30 frames per second
	- this needs to be manually set in the second script
	- May have time drift issues with non-perfect fractions of a second
	- Works great generating an image every 1/5th (0.2) or 1/10th (0.1) second
- Sets sub-second timestamp on each image
- Sets GPS data on each image (though doesn't seem to interpolate between aquired GPS points)

Doesn't yet support:
- Timezones properly (Sydney AEDT offset applied manually)

# Usage

```
./1-generate-gpx.sh raw_front_video.MP4

# Then; see instructions in output to copy timestamp from gps.gpx into 2-generate-frames.sh

./2-generate-frames.sh raw_front_video.MP4 raw_back_video.MP4
```

