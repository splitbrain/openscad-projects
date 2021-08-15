/**
 * Simple case for a ESP32-Wroom-32D DevKitc V4
 */

use <../_lib/primitives.scad>;
use <../_lib/honeycomb.scad>;

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
