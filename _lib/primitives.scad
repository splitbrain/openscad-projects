/**
 * A centered cube, but flat on the Z-Surface
 */
module ccube(v) {
    translate([0, 0, v.z/2]) cube(v, true);
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
