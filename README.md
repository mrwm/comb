# comb
Combine image tiles in a grid system with imagemagick


***

### What this script does:

 - Create a temporary folder to hold images
 - Create a placeholder image for missing images
 - Iterate through every image and verify all images are available
 - Link the image placeholder if there is a missing image
 - Combine all images horizontally in numbered order
 - Then combine the image strips vertically to a final image

### This script assumes that the images are in the same directory and is named as such:

    filename.x.y.ext
      |      | |  |
      |      | |  +-file extension. eg: png/jpg/etc
      |      | +-Y location of image tile
      |      +-X location of image tile
      +-Prefix of the image tiles

### This script also assumes that images are ordered as below:

       [*]   |
       -x,-y | +x,-y
             |
       -----0,0-----
             |
       -x,+y | +x,+y
             |

`[*]` - The script will always start from the uppermost left to right and then downwards in the direction from `-x,-y` to `+x,+y`.

***

# Usage:

Download this repo with git and enter the directory:

    git clone https://github.com/mrwm/comb.git & cd comb

Make the script executable:

    chmod +x comb.sh

Edit the cofiguration for the image tiles, then run the script with

    ./comb.sh

***

# Variables/Configuration:

## Tiles:
| Variable | Description |
| ----------- | ----------- |
| `xDim` | width in `px` of an individual image tile |
| `yDim` | height in `px` of an individual image tile |
- example: `xDim=100` and `yDim=100` will tell the script that each tile has a dimension size of 100px wide and 100px tall
  
## Image:
| Variable | Description |
| ----------- | ----------- |
| `width` | The last coordinate on the `X`-axis |
| `height` | The last coordinate on the `Y`-axis |
 - `width=2` and `height=5` will tell the image to stop at `2,5`.
   - With `width=2`, `height=5`, `xStart=-3`, and `yStart=-3`, the image will have a total size of 5 tiles wide and 8 tiles tall.

## File:
| Variable | Description |
| ----------- | ----------- |
| `filename` | Prefix of the image set |
| `ext` | The file extension of the image format |
| `ext` | Examples include `png`, `jpg`, `webp`, and so on... |
| `gapColor`| The color of what the placeholder will be |
| `gapColor`| This can be set to any image format imagemagick supports, such as `black`, `white`, `grey`, `#12d456`, and so on... |
| `tileLocation` | Location where the image set is located |
| `stitchLocation` | Location where the final image will be placed |
