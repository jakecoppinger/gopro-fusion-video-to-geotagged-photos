#!/usr/bin/env bash
set +x
set -e

if [[ $# -ne 2 ]] ; then
    echo 'Pass front filename then back'
    exit 0
fi

echo "Making folders"
rm -rf front-frames/
rm -rf back-frames/

mkdir front-frames/
mkdir back-frames/

rate=1

echo "Generating frames..."
ffmpeg -i "$1"  -r $rate -q:v 2  front-frames/img%d.jpg
ffmpeg -i "$2"  -r $rate -q:v 2  back-frames/img%d.jpg

# CURRENTLY MANUAL: Grab value of first GPS coord in gps.gpx
echo "Setting original date time..."
# Replace T with space, and remove Z
exiftool -SubSecDateTimeOriginal="2022-12-16 08:44:40.160" front-frames/ back-frames/

exiftool "-XMP:DateTimeOriginal<SubSecDateTimeOriginal" front-frames/ back-frames/

echo "Setting offsetted date time..."
# See https://exiftool.org/forum/index.php?PHPSESSID=59155a9d644e45884ed5b79ceef28d52&msg=35460
# for the method of incrementing subseconds.
exiftool -fileorder FileName -ext jpg '-xmp:DateTimeOriginal+<0:0:${filesequence;$_*=1}' front-frames/
exiftool -fileorder FileName -ext jpg '-xmp:DateTimeOriginal+<0:0:${filesequence;$_*=1}' back-frames/

echo "Copying subsecond times across..."
exiftool "-SubSecTimeOriginal<XMP:DateTimeOriginal" "-SubSecTime<XMP:DateTimeOriginal" "-SubSecTimeDigitized<XMP:DateTimeOriginal" "-datetimeoriginal<XMP:DateTimeOriginal" front-frames/
exiftool "-SubSecTimeOriginal<XMP:DateTimeOriginal" "-SubSecTime<XMP:DateTimeOriginal" "-SubSecTimeDigitized<XMP:DateTimeOriginal" "-datetimeoriginal<XMP:DateTimeOriginal" back-frames/

echo 'Geotag photos (adjusting +11 for Sydney time right now)'
exiftool -ext jpg -geosync=+11:0:0 -geotag gps.gpx front-frames/ back-frames/

echo "Removing .jpg_original..."
rm -r front-frames/*.jpg_original back-frames/*.jpg_original

echo 'Done without errors!'