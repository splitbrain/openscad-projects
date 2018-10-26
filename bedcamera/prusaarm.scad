use <../_lib/primitives.scad>
$fn=90;

armlen = 80;
armrot = 0; // rotation in deg
arm = [armlen, 10, 10];
walls  = 2;
screw = 4;
screwhead = 6;
bedarm = [20, 12.5, 6.5];
zip = [4, bedarm.y+walls*2, 0.5]; // zip tie grove
attachment = bedarm.y+walls*2; // the size of the attachment overlap

bedmount();
arm();

module arm() {
    rotate([0, 0, armrot]) {
        translate([attachment/-4, arm.y/-2, 0]) {
            difference(){
                roundedCube(arm, walls, false);
                translate([arm.x-screwhead/2-walls, arm.y/2, 0]) {
                    cylinder(h=arm.z, d=screw);
                    translate([0,0,arm.z/2]) cylinder(h=arm.z/2, d=screwhead);
                }
            }
        }
    }
}

module bedmount() {
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

