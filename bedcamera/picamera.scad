use <../_lib/primitives.scad>;
$fn=90;

walls = 2;
pcb = [26, 25, 1];
pcb_part = [17, pcb.y, 1.5];
pcb_clear = 4;

body_z   = walls+pcb.z+pcb_part.z+pcb_clear;
holder_z = walls+pcb_part.z+pcb_clear/2;
tab = 14;
screw = 4;
screwhead = 6;


//camera(false);
lid();

/**
 * The lid
 */
module lid() {
    ridge=1; // thickness of the inner ridge
    
    // the lid itself
    linear_extrude(height=walls) {
        offset(r=walls) {
            square([pcb.x, pcb.y],true);
        }
    }
    
    translate([0,0,walls]) {
        // the inner ridge
        difference() {
            linear_extrude(height=ridge) {
                square([pcb.x, pcb.y],true);
            }
            
            linear_extrude(height=ridge) {
                offset(r=walls*-1) {
                    square([pcb.x, pcb.y],true);
                }
            }
        }
        // the pins holding the pcb down
        pins(4, pcb_clear);
        
        // closes the cable outlet (half a ridge smaller than the outlet)
        translate([0, (pcb.y+walls) /2,0]) {
            ccube([pcb_part.x-ridge/2, walls, ridge]);
        }
    }
    
    // the tab for screwing down the lid
    translate([0, -1*pcb.y/2, 0]) {
        tab();
    }
}

/**
 * Create the camera case
 *
 * @param bool flip set to true to have the cable at the bottom
 */
module camera(flip=false) {
    holder_space = 10;
    mod = flip ? 1 : -1;

    body();
    
    // add two arms
    translate([0, mod*pcb.y/2, 0]) {
        translate([(holder_space+walls)/-2, 0 , 0]) {
            holderarm(flip);
        }
        translate([(holder_space+walls)/2, 0 , 0]) {
            holderarm(flip);
        }
    }
    
    // mechanism to screw the lid on
    translate([0, pcb.y/-2, 0]) {
        closer();
    }
}

/**
 * Screw mechanism for the lid
 *
 * Basically the same as the closer() but we don't need to cut
 * the cylinder and we have no sink hole for the screw head
 */
module tab() {
    translate([0,-1*walls,0]) {
        difference() {
            cylinder(h=walls, d=tab);
            translate([0, screwhead/-2, walls/-2]) {
                cylinder(h=walls*2, d=screw);
            }
        }
    }
}

/**
 * Screw mechanism for the case
 *
 * Basically the same as the tab() but with a sunken hole for the
 * screw head.
 */
module closer() {
    translate([0,-1*walls,0]) {
        difference() {
            cylinder(h=body_z, d=tab);
            
            // drill holes for head and screw
            translate([0, screwhead/-2, 0]) {
                cylinder(h=body_z/2, d=screwhead);
                cylinder(h=body_z*2, d=screw);
            }
            
            // cut off a little less than half
            translate([0, tab/2 + walls, body_z/-2]) {
                ccube([tab, tab, body_z*2]);
            };
        }
    }
}

/**
 * Creates a single holder arm
 *
 * @param bool flip when true the arm is rotated to be added at the top
 */
module holderarm(flip=false) {
    length = 10;
    
    rot = flip ? 180 : 0;
    
    rotate([0,0,rot]) {
        translate([0,length/-2,0]) {
            difference() {
                // tapered shape for when the cable is at the same end
                hull() {
                    ccube([walls, length, holder_z]);
                    translate([0, -1*length, 0]) {
                        ccylinder_y(walls, body_z);
                    }
                }
                
                // the screw hole
                translate([0, -1*length, body_z/2-screw/2]) {
                    ccylinder_y(walls*2, screw);
                }
            }
        }
    }
}

/**
 * Creates the camera body
 */
module body() {
    difference() {
        linear_extrude(height=body_z) {
            offset(r=walls) {
                square([pcb.x, pcb.y],true);
            }
        }
        pcb_cutout();
    }
}

/**
 * the 4 pins to hold the pcb
 */
module pins(d, h) {
    pin_off_w = 2.5; // center from walls
    pin_off_y = 13; // distance upper from lower pin center

    // lower right
    translate([(pcb.x/-2)+pin_off_w, (pcb.y/-2)+pin_off_w, 0]) {
        cylinder(h=h, d=d);
    }

    // lower left
    translate([(pcb.x/2)-pin_off_w, (pcb.y/-2)+pin_off_w, 0]) {
        cylinder(h=h, d=d);
    }

    // upper right
    translate([(pcb.x/-2)+pin_off_w, (pcb.y/-2)+pin_off_w+pin_off_y, 0]) {
        cylinder(h=h, d=d);
    }

    // upper left
    translate([(pcb.x/2)-pin_off_w, (pcb.y/-2)+pin_off_w+pin_off_y, 0]) {
        cylinder(h=h, d=d);
    }
}

/**
 * Carves the space for the PCB
 */
module pcb_cutout() {
    lens = [9, 9, walls];
    lens_yoffset = 2.5; // from center
    pin_d = 1.5;
    cut = lens.z + pcb_part.z + pcb.z; // cut through all

    difference() {
        union() {
            translate([0, lens_yoffset, -1]) {
                ccube([lens.x, lens.y, lens.z+1], true); // lens
            }
            translate([0,0,lens.z]) {
                ccube([pcb_part.x, pcb_part.y, pcb_part.z], true); // front parts
    
                translate([0,0,pcb_part.z]) {
                    ccube([pcb.x, pcb.y, pcb.z]); // pcb
                    
                    // cable outlet
                    translate([0, pcb_part.y/2, pcb.z+pcb_clear/2]) {
                        ccube([pcb_part.x, walls*2, pcb_clear/2]);
                    }
                }
            }
        }

        pins(pin_d, cut);
    }
    
    // upper clearance
    translate([0, 0, cut]) {
        ccube([pcb.x, pcb.y, pcb_clear]);
    }
    
    
}
