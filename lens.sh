#!/bin/bash


# Activities to perform
# * Do lens disortion - DONE
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



# Function to return correct abc for each lens types

lensParam=()

function lensParam1855 () {
    lensParam=()
    lensParam["18"]="0.02504 -0.06883 0.01502"
    lensParam["24"]="0.0203 -0.06514 0.04768"
    lensParam["29"]="0.00854 -0.01505 -0.00639"
    lensParam["35"]="-0.01582 0.04918 -0.05313"
    lensParam["41"]="-0.00694 0.02694 -0.03595"
    lensParam["46"]="-0.01908 0.07131 -0.08927"
    lensParam["55"]="-0.00098 0.01803 -0.04704"
}


function lensParam55250 () {
    lensParam=()
    lensParam["55"]="-0.000303056 -0.00581537 -0.00237143"
    lensParam["70"]="-0.000520255 0.0000286405 0.00286934"
    lensParam["100"]="0.00268582 -0.00578304 0.00718748"
    lensParam["135"]="0.00120309 0.00979416 -0.00868762"
    lensParam["250"]="-0.00226069 0.0111545 -0.00536676"
}


function lensParam50 () {
    lensParam=()
    lensParam["50"]="0.0061844 -0.0313122 0.0314815"
}

# model=$lens50
# flength="50.0 mm"



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



intFocal=`echo "$flength" | cut -d "." -f1`
isValidLens=0

if [ "$model" == "$lens1855" ]
then
    isValidLens=1
    echo "It is a 18-55mm lens @ $flength"
    lensParam1855
fi

if [ "$model" == "$lens50" ]
then
    isValidLens=1
    echo "It is a 50mm lens @ $flength"
    lensParam50
fi

if [ "$model" == "$lens55250" ]
then
    isValidLens=1
    echo "It is a 55-250mm lens @ $flength"
    lensParam55250
fi

if [ "$isValidLens" -eq "0" ]
then
    echo "model($model) is not configured in script"
    exit 0
fi

pFocal=0
valABC="0,0,0"

for K in "${!lensParam[@]}";do 
    if [ "$K" -le "$intFocal"  ]; then
        # saving previous focal value
        pFocal=$K
        
    else 
        # focal value greater than $K; use previous
        break
    fi
done

valABC=`echo "${lensParam[$pFocal]}"`
echo "Param for ptLens=$pFocal to be used ... ($valABC)"

# fetch just the params from a,b,c
# a=` echo "$valABC" | awk -F, '{ print $1 }' `
# b=` echo "$valABC" | awk -F, '{ print $2 }' `
# c=` echo "$valABC" | awk -F, '{ print $3 }' `
# echo "a=$a, b=$b, c=$c"
echo -n "Processing with imagemagick ..."
convert $1 -distort barrel "$valABC" "corrected-$1"
echo " [ DONE ]"
echo "Output file: corrected-$1"
exit 0