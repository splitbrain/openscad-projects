use <../_lib/primitives.scad>
$fn=90;

//arm();

/**
 * Creates the arm for mounting the camera to the bed
 *
 * Currently only the prusa MK3 bed is supported, but others could be
 * added here.
 *
 * @param {number} armlen The length of the arm from the mounting in mm
 * @param {number} armrot The arm's rotation in degrees
 * @param {number} walls The wall thickness in mm
 * @param {number} screw The diameter of the screw hole
 * @param {number} screwhead The diameter of the screw head hole
 */
module arm (
    armlen = 80,
    armrot = 0,
    walls  = 2,
    screw = 4,
    screwhead = 6
) {
    // basic setup
    arm = [armlen, 10, 10];
    bedarm = [20, 12.5, 6.5];
    zip = [4, bedarm.y+walls*2, 0.5]; // zip tie grove
    attachment = bedarm.y+walls*2; // the size of the attachment overlap

    // build part
    prusaMK3mount();
    arm();

    /**
     * Creates the actual Arm
     *
     * This is basically device independent. The arm is postioned
     * to be attached (and rotated) around [0,0]
     */
    module arm() {
        rotate([0, 0, armrot]) {
            translate([attachment/-4, arm.y/-2, 0]) {
                difference(){
                    roundedCube(arm, walls, false);
                    translate([arm.x-screwhead/2-walls, arm.y/2, 0]) {
                        cylinder(h=arm.z, d=screw);
                        translate([0,0,arm.z/2])
                          cylinder(h=arm.z/2, d=screwhead);
                    }
                }
            }
        }
    }

    /**
     * Create the mounting mechanism for a Prusa i3 MK3
     *
     * The attachment point for the arm is at [0,0]
     */
    module prusaMK3mount() {
        open = [bedarm.x - 2.5, 7, walls];

        // move everything so that the attachment point is centered
        translate([
            (bedarm.x+walls+attachment/2)*-1,
            (bedarm.y+walls*2)/-2,
            0
        ]) {
            // create the casing
            difference(){
                roundedCube([
                    bedarm.x+walls+attachment,
                    bedarm.y+walls*2,
                    bedarm.z+walls*2
                ], walls, false);

                translate([0, walls, walls]) {
                    // hole for the arm
                    cube(bedarm);

                    // opening for the screw
                    translate([0, bedarm.y/2 - open.y/2, -walls]) {
                        cube(open);
                    }
                }

                // zip tie grove
                translate([zip.x, 0, 0]){
                    cube(zip);
                }
            }
        }
    }
}
