# comb
Combine image tiles in a grid system

***

What this script does:

 - Create a temporary folder to hold images
 - Create a placeholder image for missing images
 - Iterate through every image and verify all images are available
 - Link the image placeholder if there is a missing image
 - Combine all images horizontally in numbered order
 - Then combine the image strips vertically to a final image

##Note: This script assumes that the images are in the same directory and is named as such:

    filename.x.y.ext
      |      | |  |
      |      | |  +-file extension. eg: png/jpg/etc
      |      | +-Y location of image tile
      |      +-X location of image tile
      +-Prefix of the image tiles

##This script also assumes that images are ordered as below:

       [*]   |
       -x,-y | +x,-y
             |
       -----0,0-----
             |
       -x,+y | +x,+y
             |

[*] - The script will always start from the uppermost left to right and then downwards.


#Variables/Configuration:

##Final Image size:

- `width` - The last coordinate on the `X`-axis
- `height` - The last coordinate on the `Y`-axis

##Tiles:

- `xDim` - width in px of an individual image tile
- `yDim` - height in px of an individual image tile
  - example: `xDim=100` and `yDim=100` will tell the script that each tile has a dimension size of 100px wide and 100px tall

- `xStart` - Starting coordinate of where the script will start on the `X`-axis
- `yStart` - Starting coordinate of where the script will start on the `Y`-axis
  - example: `xStart=-3` and `yStart=-3` will tell the script to start stitching at the -3,-3 on the grid coordinate


##File:

- `filename` - the set prefix that the image set has
- `ext` - the file extension of the image format.
  - examples include `png`, `jpg`, `webp`, and so on...
- `gapColor`- the color of what the placeholder will be
  - This can be set to any image format imagemagick supports, such as `black`, `white`, `grey`, `#12d456`, and so on...
- `tileLocation` - Location where the image set is located
- `stitchLocation` - Location where the final image will be placed
