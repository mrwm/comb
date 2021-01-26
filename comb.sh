#!/bin/bash
#

#
# What this script does:
#
# - Creates a temporary folder to hold images
# - Creates a placeholder image for missing images
# - Verifies all images are available
# - Links the image placeholder if there is a missing image
# - Combines all images horizontally in numbered order
# - Then combines the image strips in a final image
#
# Note: This script assumes that the images are in the same directory
#       and is named as filename.x.y.ext
#                         |      | |  |
#                         |      | |  +-file extension. eg: png/jpg/etc
#                         |      | +-Y location of image tile
#                         |      +-X location of image tile
#                         +-Prefix of the image tiles
#
#       This script also assumes that images are ordered as below:
#             |
#       -x,-y | +x,-y
#             |
#       -----0,0-----
#             |
#       -x,+y | +x,+y
#             |
#

########################################################################
#                           START CONFIG                               #
########################################################################

# TILES
#-----------------------------------------------------------------------

# Change to the dimensions of the single tile
xDim=100  #100 for 100px wide
yDim=100  #100 for 100px tall

# Change to where you want to start the stitching
# This will start at -3,-3
xStart=-3
yStart=-3

# IMAGE
#-----------------------------------------------------------------------

# Change to the last positive coordinate of the tile
width=2    # last tile is x=2
height=5   # last tile is y=5
           # Add an additional 1 to the last Y coord if
           # it happens to be missing

# FILE
#-----------------------------------------------------------------------

# Change accordingly to the file prefix
filename="test"

# Change accordingly to the file extension
ext=png

# Change this to whatever color you want the gaps to be in
gapColor="#ffa348"

# Change this to where the set of tiles are located
tileLocation="./sample_tiles"

# Change this to where you want to save the final stitched image
stitchLocation="./final location"
########################################################################
#                           END CONFIG                                 #
########################################################################

# Go into the working directory
cd $tileLocation || exit

# Create temporary folder to hold partially stitched images
tmp=$(mktemp -d)

# Do not touch.
# This variable is for holding the increment
# value when going through the images
xVal=$xStart
yVal=$yStart

# Create a placeholder image to be linked later
convert -size $xDim\x$yDim xc:$gapColor "$tmp"/$filename.temp.$ext


########################################################################
#                           Placeholding                               #
########################################################################
# Verify that all images exist. Create a placeholder if it doesn't
while [ $yVal -le $height ]; do
  while [ $xVal -le $width ]; do
    if [ -f $filename.$xVal.$yVal.$ext ]; then
      : # do nothing since the file exists
    else
      # link the placeholder
      ln -s "$tmp"/$filename.temp.$ext $filename.$xVal.$yVal.$ext
    fi
    xVal=$((xVal + 1))
  done
  yVal=$((yVal + 1))
  xVal=$xStart
done
xVal=$xStart
yVal=$yStart
# reset the values after verification


########################################################################
#                           Stitching                                  #
########################################################################
# Make a positive number for ordering everything
xPairs=0
yStrips=0

while [ $yVal -le $height ]; do
  while [ $xVal -le $width ]; do
    # Check if the image can be paired horizontally
    if [ -f $filename.$(($xVal + 1)).$yVal.$ext ]; then
      # Go through all the images and pair them up horizontally
      convert $filename.$xVal.$yVal.$ext $filename.$(($xVal + 1)).$yVal.$ext +append "$tmp"/$filename.P$xPairs.$yStrips.$ext
    else
      # this image has no pairs, so
      # copy the image to temp for stitching
      cp $filename.$xVal.$yVal.$ext "$tmp"/$filename.P$xPairs.$yStrips.$ext
    fi

    xVal=$((xVal + 2))
    xPairs=$((xPairs + 1))
  done

  # Combine all the horizontal pairs into horizontal strips
  convert "$tmp"/$filename.P*.$yStrips.$ext +append "$tmp"/$filename.$yStrips\_H.$ext

  yVal=$((yVal + 1))
  yStrips=$((yStrips + 1))
  xVal=$xStart
  xPairs=0
done
xVal=$xStart
yVal=$yStart
# reset the values after pairing

# Finally combine all horizontal image strips to form the final image
convert "$tmp"/$filename.*_H.$ext -append $filename\_stitched.$ext

########################################################################
#                           Cleanup                                    #
########################################################################

# Look through every image file
while [ $yVal -le $height ]; do
  while [ $xVal -le $width ]; do
    if [ -L $filename.$xVal.$yVal.$ext ]; then
      # Delete the file if it is a symlink
      rm $filename.$xVal.$yVal.$ext
    fi
    xVal=$((xVal + 1))
  done
  yVal=$((yVal + 1))
  xVal=$xStart
done

# Remove the tmp folder
rm -rf "$tmp"

# Head back to initial location and
# move the stitched image to the location in the config section
cd "$OLDPWD" && mv "$OLDPWD"/$filename\_stitched.$ext "$stitchLocation"

########################################################################
#                           END                                        #
########################################################################

echo "Your file is now at" "$stitchLocation/$filename\_stitched.$ext"

# Exit cleanly
exit 0
