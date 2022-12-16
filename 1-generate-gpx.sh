
#!/usr/bin/env bash
set +x
set -e

if [[ $# -ne 1 ]] ; then
    echo 'Pass front filename '
    exit 0
fi

echo "Extracting GPS..."
# Deffs works with OG front image
exiftool -ee -p gpx.fmt "$1" > gps.gpx

echo "Extracting metadata..."
exiftool -G -a "$1" > metadata.txt

echo "Done. Now get the first timestamp in the GPS log to manually 
insert into the second script."