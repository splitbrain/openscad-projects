/* basic dimensions */
width  = 230;   // outer x dimension in mm
length = 160;   // outer y dimension in mm
height = 30;    // outer z dimension in mm
walls  = 0.8;   // wall thickness in mm, two perimeters
base   = true;  // is a bottom wanted?

/* defines - use to define the grid */
N  = 0; // no walls
R  = 1; // right wall
B  = 2; // bottom wall
RB = 3; // both walls
BR = 3; // both walls

/* grid config */
grid = [
    [ RB, RB, RB, B, RB, R ],
    [ RB, RB, RB, B, RB, RB ],
    [ RB, RB, RB, B, B, RB ],
    [ RB, RB, RB, B, B, RB ],
];

/* -------- */

// calculate base values
gridR = reverse(grid);
unitsX = len(grid[0]);  // units per width
unitsY = len(grid);     // units per length
unitX = (width - walls)/unitsX;   // unit width
unitY = (length - walls)/unitsY;  // unit length

echo(str("Each unit is ",unitX,"mm by ",unitY,"mm"));

/* build */
union() {
    // ground plate
    if(base) {
        cube([width, length, walls]);
    }

    // outer walls
    cube([walls, length, height]);
    translate([width-walls,0,0])
        cube([walls, length, height]);
    cube([width, walls, height]);
    translate([0, length-walls, 0])
        cube([width, walls, height]);

    // iterate over the grid definition
    for (r = [0:1:unitsY-1], c = [0:1:unitsX-1]) {
        unit = gridR[r][c];
        
        // vertical walls
        if (bitwise_and(unit, R)) {
            translate([(c+1)*unitX, r*unitY, 0])
                cube([walls, unitY + walls, height]);
        }
        
        // horizontal walls
        if (bitwise_and(unit, B)) {
            translate([c*unitX, r*unitY , 0])
                cube([unitX, walls, height]);
        }
    }
}

// https://github.com/openscad/scad-utils/blob/master/lists.scad
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]];

// https://github.com/royasutton/omdl/blob/master/math/math_bitwise.scad
function bitwise_and
(
  v1,
  v2,
  bv = 1
) = ((v1 + v2) == 0) ? 0
  : (((v1 % 2) > 0) && ((v2 % 2) > 0)) ?
    bitwise_and(floor(v1/2), floor(v2/2), bv*2) + bv
  : bitwise_and(floor(v1/2), floor(v2/2), bv*2);
