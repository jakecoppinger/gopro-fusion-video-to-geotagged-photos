#!/usr/bin/env bash
set +x
set -e

if [[ $# -eq 0 ]] ; then
    echo 'Add filename as first arg'
    exit 0
fi

echo "Making frames"
rm -rf frames/
mkdir frames/

rate=1

echo "Generating frames..."
ffmpeg -i "$1"  -r $rate -q:v 2  frames/img%d.jpg


echo "Extracting GPS..."
# Deffs works with OG front image
exiftool -ee -p gpx.fmt "$1" > gps.gpx

echo "Extracting metadata..."
exiftool -G -a "$1" > metadata.txt

echo "Add timestamps to frames..."


# MANUAL: Grab value of Track Create Date  in metadata
echo "Setting original date time..."
exiftool -datetimeoriginal="2022:12:15 18:29:38" frames/
echo "Setting offsetted date time..."

exiftool -fileorder FileName -ext jpg '-datetimeoriginal+<0:0:${filesequence;$_*=1}' frames/

