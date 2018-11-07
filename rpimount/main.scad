$fn=20;
use <../_lib/primitives.scad>

// official Raspberry Pi sizes
rpi = [85, 56, 1.6];
rpi_radius = 3;

walls = 2;
space = 4;
overlap = 0.5;

// create the model
difference() {
    union() {
        rim();
        frame();
        pins(3, 3); //outer
    }
    pins(1.5, 2.5); // inner
    sdcard();
}
grab();

/**
 * Create the space for the SD card
 */
module sdcard() {
    height = 3;
    width = 20;
    
    translate([0, (rpi.y+walls)/2 - width/2, walls + space - height])
    cube([walls, width, rpi.z + height]);
}

/**
 * Create the lip to help with holding the RPi in place
 */
module grab() {
    long = 50;
    long_off = 7;
    short = 6;
    short_off1 = 16;
    short_off2 = 72;
   
    translate([long_off + walls/2, rpi.y + walls/2 - overlap, walls+space+rpi.z])
        cube([long, overlap + walls/2, overlap]);
    
    /*
    translate([short_off1 + walls/2, 0, walls+space+rpi.z])
        cube([short, overlap + walls/2, overlap]);
    
    translate([short_off2 + walls/2, 0, walls+space+rpi.z])
        cube([short, overlap + walls/2, overlap]);
    */
}

/**
 * Create cylinders at the mount hole positions
 *
 * @param {number} r1 size of the lower diameter
 * @param {number} r2 size of the upper diameter
 */
module pins(r1, r2) {
    // official positions of the RPi mount holes
    bl = [3.5, 3.5];
    br = [3.5 + 58, 3.5];
    tl = [3.5, 3.5 + 49];
    tr = [3.5 + 58, 3.5 + 49];

    translate([walls/2, walls/2]) {
        translate(bl) {
            cylinder(h=space+walls, r1=r1, r2=r2);
        }
        translate(br) {
            cylinder(h=space+walls, r1=r1, r2=r2);
        }
        translate(tl) {
            cylinder(h=space+walls, r1=r1, r2=r2);
        }
        translate(tr) {
            cylinder(h=space+walls, r1=r1, r2=r2);
        }
    }
}

/**
 * Creates the mounting frame with holes
 */
module frame() {
    frame = 10; // width of the frame
    screws = 1.5; // mounting hole radius
    
    translate([(rpi.x + walls)/2, (rpi.y + walls)/2])
    difference() {
        curvedCube(
            [rpi.x + walls, rpi.y + walls, walls],
            r=rpi_radius
        );

        curvedCube(
            [rpi.x + walls - frame * 2, rpi.y + walls - frame * 2, walls],
            r=rpi_radius
        );
        
        translate([rpi.x/-2 + frame/2 - screws + walls/2, 0])
            cylinder(r=screws, h=walls);
        
        translate([rpi.x/2 - frame/2 + screws - walls/2, 0])
            cylinder(r=screws, h=walls);
        
        translate([0, rpi.y/-2 + frame/2 - screws + walls/2])
            cylinder(r=screws, h=walls);
        
        translate([0, rpi.y/2 - frame/2 + screws - walls/2])
            cylinder(r=screws, h=walls);
    }
}

/**
 * Create the rim around the RPi board
 */
module rim() {
    translate([(rpi.x + walls)/2, (rpi.y + walls)/2])
    
    difference() {
        curvedCube(
            [rpi.x + walls, rpi.y + walls, rpi.z + space + walls],
            r=rpi_radius
        );
        translate([0, 0, space + walls])
            curvedCube(rpi, r=rpi_radius);
        
        curvedCube(
            [rpi.x - overlap*2, rpi.y - overlap*2, rpi.z + space + walls],
            r=rpi_radius
        );
    }
}