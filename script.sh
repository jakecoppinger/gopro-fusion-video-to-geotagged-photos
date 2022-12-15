#!/usr/bin/env bash
set +x
set -e

if [[ $# -ne 2 ]] ; then
    echo 'Pass front filename then equirectangular filename'
    exit 0
fi

echo "Making folders"
rm -rf frames/
mkdir frames/

rate=1

echo "Generating frames..."
ffmpeg -i "$2"  -r $rate -q:v 2  frames/img%d.jpg

echo "Extracting GPS..."
# Deffs works with OG front image
exiftool -ee -p gpx.fmt "$1" > gps.gpx

echo "Extracting metadata..."
exiftool -G -a "$1" > metadata.txt

echo "Add timestamps to frames..."

# CURRENTLY MANUAL: Grab value of first GPS coord in gps.gpx
echo "Setting original date time..."
exiftool -datetimeoriginal="2022-12-15T08:23:08.654Z" frames/
echo "Setting offsetted date time..."

exiftool -fileorder FileName -ext jpg '-datetimeoriginal+<0:0:${filesequence;$_*=1}' frames/

echo 'Geotag photos (adjusting +11 for Sydney time right now)'
exiftool -ext jpg -geosync=+11:0:0 -geotag gps.gpx frames/

echo "Setting extra metadata..."
exiftool -make="GoPro" -model=Fusion -ProjectionType=equirectangular -UsePanoramaViewer=True -CroppedAreaImageWidthPixels=3840 -CroppedAreaImageHeightPixels=1920 -FullPanoWidthPixels=3840 -FullPanoHeightPixels=1920 -CroppedAreaLeftPixels=0 -CroppedAreaTopPixels=0 


echo "Removing .jpg_original..."
rm -r frames/*.jpg_original

