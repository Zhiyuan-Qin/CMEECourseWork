#!/bin/bash
for filename in *.tif
do
    echo "Converting $filename"
    magick "$filename" "$(basename "$filename" .tif).png"
done