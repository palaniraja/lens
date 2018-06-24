#!/bin/bash


# Activities to perform
# * Do lens disortion
# * Do Lens Color Aberration (LCA) - if applicable
# * Do Vignetting - if applicable


# * REFERENCES
# https://stackoverflow.com/questions/34454653/how-do-i-use-imagemagick-to-emulate-lens-color-aberration
# http://www.imagemagick.org/discourse-server/viewtopic.php?t=12180


# convert vegas_orig.jpg ( vegas_nikon18-70dx_18mm_f3.5.jpg -colorspace gray -negate ) -compose color-dodge -composite vegas_dodge.jpg

if [ $# -eq 0 ]
  then
    echo "Eg. $0 filename.jpg"
    exit 0
  else
    echo "Analysing file ... $1"
fi


# List of my lenses & corresponding A, B, C values

lens1855="Canon EF-S 18-55mm f/3.5-5.6 IS II"
lens55250="Canon EF-S 55-250mm f/4-5.6 IS II"
lens50="Canon EF 50mm f/1.8 STM"


# === Fetching Lens Model to search for lensfun ===
# exiftool forig.jpg | grep "Lens ID" | awk -F': ' '{ print $2 }'

# "Lens ID" because Exif at times does not have req.string
# pipe to cut (below) should also work, wondering if exiftool find the no. based on max exif name
# cut -c 35-
# 35 is padding char by exiftool
# -s2 remove the space padding



# === Fetching Focal Length to for appr. A, B, C values ===
# exiftool -FocalLength forig3.jpg |  awk -F': ' '{ print $2 }'

# to get focal length, -FocalLength because too many "Focal Length"



echo "-------"

model=`exiftool -s2  -LensID "$1" | awk -F': ' '{ print $2 }'`
echo "Model: $model"

flength=`exiftool -s2  -FocalLength "$1" | awk -F': ' '{ print $2 }'`
echo "Focal Length: $flength"

echo "-------"

if [ "$model" == "$lens1855" ]
then
    echo "It is a 18-55mm lens @ $flength"
fi

if [ "$model" == "$lens50" ]
then
    echo "It is a 50mm lens @ $flength"
fi

if [ "$model" == "$lens55250" ]
then
    echo "It is a 55-250mm lens @ $flength"
fi