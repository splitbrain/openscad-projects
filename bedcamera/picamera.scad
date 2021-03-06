use <../_lib/primitives.scad>;

//picamera(part="camera");
//picamera(part="lid");

/**
 * Creates the body or lid for the camera
 *
 * @param {string} part The part to print, either "camera" or "lid"
 * @param {bool} flip Should the cable come out of the bottom?
 * @param {bool} lidscrew Should the be screwed on?
 * @param {number} walls The wall thickness in mm
 * @param {number} screw The diameter of the screw hole
 * @param {number} screwhead The diameter of the screw head hole
 */
module picamera (
    part = "camera",
    flip = false,
    lidscrew = true,
    walls = 2,
    screw = 4,
    screwhead = 4
) {
    // basic setup
    pcb = [26, 25, 1];
    pcb_part = [17, pcb.y, 1.5];
    cable_z = 1; // above pcb
    pcb_clear = 4;
    tab = 14;
    body_z   = walls+pcb.z+pcb_part.z+pcb_clear;
    holder_z = walls+pcb.z+pcb_part.z+cable_z;
    $fn = $fn ? $fn : 90;

    // print part
    if(part == "camera") {
        camera();
    } else {
        lid();
    }

    /**
     * The lid
     */
    module lid() {
        ridge=1; // thickness of the inner ridge
        cable=1; // space for the cable
        pin_off=0.2;

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
            // the pins holding the pcb down (half a rigde shorter)
            difference(){
                pins(4, pcb_clear-pin_off);
                translate([0,0,pcb_clear-ridge/2]) pins(2, ridge);
            }

            // closes the cable outlet (half a ridge smaller than the outlet)
            translate([0, (pcb.y+walls) /2,0]) {
                ccube([pcb_part.x-ridge/2, walls, pcb_clear-cable_z-cable]);
            }
        }

        // the tab for screwing down the lid
        if(lidscrew) translate([0, -1*pcb.y/2, 0]) {
            tab();
        }
    }

    /**
     * Create the camera case
     */
    module camera() {
        holder_space = 10;
        mod = flip ? 1 : -1;

        body();

        // add two arms
        translate([0, mod*(pcb.y/2 + walls), 0]) {
            translate([(holder_space+walls)/-2, 0 , 0]) {
                holderarm(flip);
            }
            translate([(holder_space+walls)/2, 0 , 0]) {
                holderarm(flip);
            }
        }

        // mechanism to screw the lid on
        if(lidscrew) translate([0, pcb.y/-2, 0]) {
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
     */
    module holderarm() {
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
                        translate([0, pcb_part.y/2, pcb.z+cable_z]) {
                            ccube([pcb_part.x, walls*2, pcb_clear-cable_z]);
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
}
