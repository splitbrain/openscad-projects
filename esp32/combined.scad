/* START main.scad*/
/**
 * Simple case for a ESP32-Wroom-32D DevKitc V4
 */

/* START primitives.scad*/
/**
 * A centered cube, but flat on the Z-Surface
 *
 * Negative z will create a cube flat under the surface
 */
module ccube(v) {
    trans = v.z/2;
    translate([0, 0, trans]) cube([v.x, v.y, abs(v.z)], true);
}

/**
 * An upright standing centered cylinder, flat on the Z-Surface
 */
module ccylinder_y(h, d) {
    translate([h/-2, 0, d/2])
        rotate([0, 90, 0])
            cylinder(h=h, d=d);
}

/**
 * Creates a rounded cube
 *
 * @param {vector} v The size of the cube
 * @param {number} r The radius of the rounding
 * @param {bool} flatcenter centered but flat on Z
 */
module roundedCube(v, r=1, flatcenter=true) {
    mv = flatcenter ? [0,0,0] : [v.x/2, v.y/2 ,0];

    translate(mv) hull() {
        // right back bottom
        translate([v.x/2 - r, v.y/2 - r, r])
            sphere(r=r);

        // right front bottom
        translate([v.x/2 - r, v.y/-2 + r, r])
            sphere(r=r);

        // left back bottom
        translate([v.x/-2 + r, v.y/2 - r, r])
            sphere(r=r);

        // left front bottom
        translate([v.x/-2 + r, v.y/-2 + r, r])
            sphere(r=r);


        // right back top
        translate([v.x/2 - r, v.y/2 - r, v.z - r])
            sphere(r=r);

        // right front top
        translate([v.x/2 - r, v.y/-2 + r, v.z - r])
            sphere(r=r);

        // left back top
        translate([v.x/-2 + r, v.y/2 - r, v.z - r])
            sphere(r=r);

        // left front top
        translate([v.x/-2 + r, v.y/-2 + r, v.z - r])
            sphere(r=r);
    }
}

/**
 * Similar to the rounded cube, but the top and bottom are flat
 * @param {vector} v The size of the cube
 * @param {number} r The radius of the rounding
 * @param {bool} flatcenter centered but flat on Z
 */
module curvedCube(v, r=1, flatcenter=true) {
    mv = flatcenter ? [v.x/-2, v.y/-2 ,0] : [0,0,0];

    translate(mv) hull() {
        // right back
        translate([v.x - r, v.y - r, 0])
            cylinder(h=v.z, r=r);
        
        // right front
        translate([v.x - r, r, 0])
            cylinder(h=v.z, r=r);

        // left back
        translate([r, v.y - r, 0])
            cylinder(h=v.z, r=r);

        // left front
        translate([r, r, 0])
            cylinder(h=v.z, r=r);
    }
}
/* END primitives.scad*/
/* START honeycomb.scad*/
/**
 * @link http://forum.openscad.org/Beginner-Honeycomb-advice-needed-td4556.html
 * @author Przemo Firszt
 */

module honeycomb_column(length, cell_size, wall_thickness)
{
    no_of_cells = floor(length / (cell_size + wall_thickness));

    for (i = [0:no_of_cells]) {
        translate([ 0, (i * (cell_size + wall_thickness)), 0 ])
            circle($fn = 6, r = cell_size * (sqrt(3) / 3));
    }
}

module honeycomb(length, width, height, cell_size, wall_thickness)
{
    no_of_rows = floor(1.2 * length / (cell_size + wall_thickness));

    tr_mod = cell_size + wall_thickness;
    tr_x = sqrt(3) / 2 * tr_mod;
    tr_y = tr_mod / 2;
    off_x = -1 * wall_thickness / 2;
    off_y = wall_thickness / 2;
    linear_extrude(
        height = height, center = true, convexity = 10, twist = 0, slices = 1)
        difference()
    {
        square([ length, width ]);
        for (i = [0:no_of_rows]) {
            translate([ i * tr_x + off_x, (i % 2) * tr_y + off_y, 0 ])
                honeycomb_column(width, cell_size, wall_thickness);
        }
    }
}

module choneycomb(v, size, walls) {
    translate([v.x/-2, v.y/-2, v.z/2]) {
        honeycomb(v.x, v.y, v.z, size, walls);
    }
}
/* END honeycomb.scad*/

pcb = [48.5, 28.5, 2]; // size of the PCB
walls = 1; // wallthickness
pinrow = [48.5, 3, 10]; // size of the pin rows
antenna = 18.5; // width of the antenna
usb = 10; // width of the usb (a little wider to accomodate fat plugs)
tolerance = 0.23; // tolerance for the snap fit


print_part(cnf_part);

/**
 * Prints the selected part
 *
 * @param {string} The part to print
 */
module print_part(part="all") {
    if (part == "bottom_exposed_pins") {
        body(false);
    } else if (part == "bottom_covered_pins") {
        body(true);
    } else if (part == "lid_honeycomb") {
        lid();
    } else {
        translate ([0, 0, 0]) body(false);
        translate ([0, 60, 0]) body(true);
        translate ([0, 120, 0]) lid();
    }
}

/**
 * Part of the body, the rim around the PCB with cutouts for the
 * Antenna and USB Port
 *
 * @todo make antenna optional
 */
module rimWithAntenna() {
    height = 3.2 + pcb.z;
    
    difference() {
        ccube([pcb.x + walls*2, pcb.y + walls*2, height]);
        ccube([pcb.x, pcb.y, height]); // space
        translate([pcb.x/-2,0,pcb.z]) ccube([walls*2, antenna, height]);
        translate([pcb.x/2,0,pcb.z]) ccube([walls*2, usb, height]);
    }
}

/**
 * Part of the body, the base under the PCB with cutouts for the pins
 *
 * @todo make pins optional
 * @param {bool} should the pins be completely covered?
 */
module baseWithPins(cover) {
    height = cover ? (pinrow.z + walls) : walls;
    pinmv = cover ? walls : pinrow.z/-2;
    
    translate([0,0,-1 * height]) {
        difference() {
            ccube([pcb.x + walls*2, pcb.y + walls*2, height]);
            translate([0,0,pinrow.z + walls]) ccube(pcb); // pcb tray
            translate([0,pcb.y/2 - pinrow.y/2, pinmv])
                ccube([pinrow.x, pinrow.y, pinrow.z]);
            translate([0,(pcb.y/2 - pinrow.y/2)*-1, pinmv])
                ccube([pinrow.x, pinrow.y, pinrow.z]);
        }
    }
}

/**
 * Part of the lid, the main cover
 *
 * This uses a honeycomb for air flow
 *
 * @todo make buttons usable
 */
module cover() {
    xoffset = 3;
    yoffset = 3;
    xspace = 0; // we could use this to make space for buttons and dedicated LED holes
    
    
    difference(){
        ccube([pcb.x + walls*2, pcb.y + walls*2, walls]);
        // cutout to be filled with honey comb
        translate([xspace,0,0]) {
            ccube([pcb.x - xoffset*2 - xspace*2, pcb.y  - yoffset*2, walls]);
        }
    }
    choneycomb([pcb.x, pcb.y, walls], walls*4, walls);
}

/**
 * Part of the lid, the lip that makes the snapfit
 */
module lip() {
    liph = 2.3;
    lipw = 1;
    
    translate([0,0,-1*liph]) {
        difference(){
            ccube([pcb.x-tolerance, pcb.y-tolerance, liph]);
            ccube([pcb.x-tolerance-lipw, pcb.y-tolerance-lipw, liph]);
            translate([pcb.x/-2,0,0]) ccube([walls*2, antenna, liph]);
            translate([pcb.x/2,0,0]) ccube([walls*2, usb, liph]);
        }
    }
}

/**
 * Assembles the lid
 */
module lid(){
    rotate([180,0,0]) {
        cover();
        lip();
    }
}

/**
 * Assembles the body
 * @param {bool} should the pins be completely covered?
 */
module body(cover){
    baseWithPins(cover);
    rimWithAntenna();
}
/* END main.scad*/

