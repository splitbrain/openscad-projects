

$fn = 250;

// outer width of the pipe in mm default: DN110 plus a mm play
diameter = 111; 
// height of the whole cap
height = 20;
// width of the walls in mm
wall = 2;
// size of the grid holes in mm
grid = 8;
// fit space space for the ring
tolerance = 0.15;

// print based on external parameter
print_part(cnf_part);


use <../_lib/honeycomb.scad>;

module lid() {
    union() {

        intersection() {
            size = diameter+wall;
            cylinder(h=wall, d=size);

            translate([-0.5*size,-0.5*size,0.5*wall]) {
                honeycomb(size, size, wall*2, grid, wall);
            }
        }

        difference() {
            cylinder(h=wall, d=diameter+wall);
            cylinder(h=wall, d=diameter-diameter/10);
        }


        difference() {
            cylinder(h=height, d=diameter+wall);
            cylinder(h=height, d=diameter);
        }
    }
}

module ring() {
    difference() {
        cylinder(h=wall, d=diameter-tolerance);
        cylinder(h=wall, d=diameter-diameter/10);
    }
}


/**
 * Decide which part to print based on the given parameter
 */
module print_part(part="all") {
    if (part == "lid" ) {
        lid();
    } else if (part == "ring") {
        ring();
    } else {
        lid();
        translate([diameter*1.1,0,0]) ring();
    }
}
