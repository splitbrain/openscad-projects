include <customizer.scad>
include <picamera.scad>
include <post.scad>
include <arm.scad>

print_part(cnf_part);

/**
 * Decide which part to print based on the given parameter
 */
module print_part(part="all") {
    if (part == "camera" ) {
        picamera(
            part="camera",
            flip = cnf_flip,
            lidscrew = cnf_lidscrew,
            walls = cnf_walls,
            screw = cnf_screw,
            screwhead = cnf_screwhead
        );
    } else if (part == "lid") {
        picamera(
              part="lid",
              flip = cnf_flip,
              lidscrew = cnf_lidscrew,
              walls = cnf_walls,
              screw = cnf_screw,
              screwhead = cnf_screwhead
          );
    } else if (part == "post") {
        post(
          height = cnf_postheight,
          screw = cnf_screw,
          walls = cnf_walls,
          drill = cnf_drill
        );
    } else if (part == "arm") {
        arm (
            armlen = cnf_armlength,
            armrot = cnf_armrotation,
            walls  = cnf_walls,
            screw = cnf_screw,
            screwhead = cnf_screwhead
        );
    } else {
        translate([-30, 0, 0]) print_part("camera");
        translate([30, 0, 0]) print_part("lid");
        translate([0, -45, 0]) print_part("post");
        translate([0, 45, 0]) print_part("arm");
    }
}
