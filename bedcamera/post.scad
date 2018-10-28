use <../_lib/primitives.scad>

//post();

/**
 * Creates the post to mount the camera on the arm
 *
 * @param {number} height The height of the post in mm
 * @param {number} width The diameter of the post in mm
 * @param {number} screw The diameter of the screw hole
 * @param {number} walls The wall thickness in mm
 * @param {number} drill The diameter of the hole in the post bottom
 */
module post(
    height = 26,
    width = 10,
    screw = 4,
    walls = 2,
    drill = 3,
) {
    holder_space = 10;
    $fn = $fn ? $fn : 90;

    difference() {
        // smooth from round to square
        hull(){
            translate([0,0,(height/3)*2]) {
                roundedCube([width, width, height/3]);
            }
            cylinder(d=width, h=height/3);
        }

        // screw hole
        translate([0, 0, height - screw/2 - walls]) {
            rotate([90,0,0]) {
                cylinder(d=screw, h=width, center=true);
            }
        }

        // drill hole
        cylinder(d=drill, h=(width/3)*2);
    }
}
