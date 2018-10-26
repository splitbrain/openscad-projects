use <../_lib/primitives.scad>
$fn=90;

postheight = 26;
post = 10;
screw = 4;
walls = 2;
holder_space = 10;
drill = 3;

post();


module post() {
    difference() {
        hull(){
            translate([0,0,(postheight/3)*2]) {
                roundedCube([post, post, postheight/3]);
            }
            cylinder(d=post, h=postheight/3);
        }

        translate([0, 0, postheight - screw/2 - walls]) {
            rotate([90,0,0]) {
                cylinder(d=screw, h=post, center=true);
            }
        }
        
        cylinder(d=drill, h=(post/3)*2);
    }
}
