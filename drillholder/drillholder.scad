// this defines the set of bit holders, 3 parameters per bit
//   - tool shaft width in mm
//   - tool head width in mm (0 or unset for same as shaft)
//   - depth for the shaft (default: 30mm)
//
// This is an example for my wood drill bits
set = SET ? SET : [
    [2.5, 0, 20],
    [3, 0, 20],
    [4],
    [5],
    [6],
    [7],
    [8],
    [10],
    [10,12,32]
];


// you probably don't need to adjust these, but can:

$fn=80; // circle precision
walls = 1; // normal wall thickness
tolerance = 0.8; // tolerance for the holes for easy insertion
default_space = 8; // space around the bit, half of it on each side
tilt = 10; // angle for the holder tilt

label = 12; // depth in front of the hole
depth = 25; // depth for the hole and behind
mount = 20; // height of the mounting plate


// end of parameters

/**
 * A cylinder flat against the x axis
 */
module cyl(h, d) {
    translate([0, d/2, 0])
        cylinder(h=h, d=d);
}

/**
 * The triangle part at the wall
 */
module holdertri(space) {
    translate([space/-2, -1*(mount * sin(tilt) + 0.5) , 0.5]) 
        rotate([90, 0, 90]) {
            hull() {
                translate([-1 * mount * sin(tilt), 0 , 0]) cylinder(h=space, d=1);
                translate([mount * sin(tilt), 0 , 0]) cylinder(h=space, d=1);
                translate([0, mount * cos(tilt) , 0]) cylinder(h=space, d=1);
            }
        }
}

/**
 * Creates the body for a 3.5mm screw hole
 */
module screwhole() {
    height = 2*mount*sin(tilt);
    translate([0,depth+walls,mount/2+walls*3]) {
        rotate([90+tilt,0,0]) {
            cylinder(h=height, d=3.5);
            translate([0,0,height-2]) cylinder(h=2, d1=3.5, d2=6);
            translate([0,0,height]) cylinder(h=walls, d1=6, d2=6);
        }
    }
}

/**
 * Calculates the width one holder needs
 */
function calcSpace(diameter, space) = (space ? space : diameter) + default_space;

/**
 * A hold for a single tool
 *
 * Created in print orientation upside down
 */
module hold(diameter, space=0, height=30) {
    width = calcSpace(diameter, space);
    height = height ? height : 30;

    translate([width/-2,0,0])
        difference() {
            union() {
                // the top part
                translate([width/-2, -label , 0]){
                    cube([width, label + depth, walls * 3]);
                }
                
                translate([0, depth + walls , 0]){
                    holdertri(width);
                }
                
                // the holder tube
                cyl(h=height+walls*2, d=diameter+tolerance+walls);
            }
            // the holder hole
            translate([0,walls/2,-5]) cyl(h=height+5, d=diameter+tolerance);
        }
}

/**
 * Recursive function to create the whole set of holders
 */
module holdbuilder(holds, idx=0) {
    if(idx < len(holds)) {
        space = calcSpace(holds[idx][0], holds[idx][1]);
        
        hold(holds[idx][0], holds[idx][1], holds[idx][2]);
        
        // call next one recursive
        translate([space*-1,0,0]) {
            holdbuilder(holds, idx + 1);
        }
    }
}

/**
 * Recursive function to create the screw holes
 *
 * Holes are added after the first and before the last item
 */
module screwholebuilder(holds, idx=0) {
    if(idx < len(holds)) {
        space = calcSpace(holds[idx][0], holds[idx][1]);
        
        if(idx == 1 || idx == len(holds)-1) {
            screwhole();
        }
        
        // call next one recursive
        translate([space*-1,0,0]) {
            screwholebuilder(holds, idx + 1);
        }
    }
}

/**
 * MAIN
 */
difference() {
    holdbuilder(set);
    screwholebuilder(set);
}
