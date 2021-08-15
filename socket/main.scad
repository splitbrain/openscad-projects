include <../_lib/primitives.scad>;

$fn=60;
thickness = 11;
number = 2;

// socket hole
inner=60;
// frame size
outer=71;


for(i=[0 : number-1]) translate([outer*i,0,0]) {
    frame();
}

/**
 * Output a single socket frame
 */
module frame() {

    // put the children into the for cardinal corners
    module cardinals() {
        translate([inner/2,0,0]) {
            children();
        }
        translate([inner/-2,0,0]) {    
            children();
        }
        translate([0,inner/2,0]) {
            children();
        }
        translate([0,inner/-2,0]) {
            children();
        }
    }

    difference() {
        union() {
            difference() {
                curvedCube([outer, outer, thickness], 5, true);
                cylinder(h=thickness, d=inner);
            }
            cardinals(){
                cylinder(h=thickness, d=6.5);
            }
        }
        
        cardinals(){
            cylinder(h=thickness, d=3);
        }
    }

}