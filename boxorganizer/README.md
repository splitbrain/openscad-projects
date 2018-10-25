# Customizable Organizer

This design is totally customizable, unfortunately it does not work in Thingiverse's customizer because you need to define a Matrix and you can't do that (yet).

The STL is the exact design as shown in the photos (two of it fit perfectly in a IKEA Moppe drawer I had). However you should ignore that and customize this to your own needs.

## Customizing

Download the .scad file and open it in OpenSCAD. At the top you'll find three sections (see screenshot).

The first section **"basic dimensions"** let's you configure the outside dimensions of the box, the wall thickness and if you want a bottom.

The second section **"defines"** creates some variables you can use to set up your box innards. Do *not* edit those.

The third section **"grid config"** finally configures the inner layout. The idea is that you divide the box into chambers (units) of the same size. Then you specify for each of those units if the unit should have a wall to the right, the bottom or both. For the most right and most bottom units it's okay to define walls that are actually the outside of the box -- they will be ignored.

For the configuration as shown in the STL, the grid is defined as follows:

    grid = [
        [ RB, RB, RB, B, RB,  R ],
        [ RB, RB, RB, B, RB, RB ],
        [ RB, RB, RB, B,  B, RB ],
        [ RB, RB, RB, B,  B, RB ],
    ];

Experiment with the definitions and OpenSCAD's preview and you'll figure it out. You can have as many rows and columns as you want. Just make sure that each row has the same number of columns in the definition!
