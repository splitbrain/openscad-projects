# Customizable Camera Bed Mount

Currently for Prusa MK3 and the Raspberry Pi Camera only, but other printers could easily be added.

This was heavily inspired by [jgeyer's Prusa i3 MK2/MK3 Raspberry Camera Mount](https://www.thingiverse.com/thing:2736439) and it's remixes. However everything was redesigned in OpenSCAD to make it much easier to customize in the future.

## Parts

This thing contains multiple parts to print:

* the camera housing to fit the Raspberry Pi Camera v2 (should also work with v1)
* the lid to close the housing
* the post the camera is mounted on
* the arm where the post is attached to and which is mounted on the bed frame

Everything is assembled with M3 screws. The arm simply slides over the bed frame and can optionally be fixated with a zip tie. The fit should be good enough to not need the zip tie though.

## Customizing

The design can be customized. you can decide

* if the lid should be screwed on
* if the cable should come out at the top or bottom
* how long the arm should be
* at what angle the arm should be mounted (fits right and left side)
* how tall the post should be

## Printing

I recommend a brim for printing the post. The arm is printed with the opening towards the bed, the slight slack of the bridging helps with the tight fit. If your printer can't do these bridges, feel free to flip the part.

## Sources

The sources are available at [Github](https://github.com/splitbrain/openscad-projects/tree/master/bedcamera). If you want to extend or reuse parts of this, please use the sources (multiple .scad files) at Github instead of the single file version at Thingiverse.

Pull-Requests to add more printers, cameras or other attachments welcome!
