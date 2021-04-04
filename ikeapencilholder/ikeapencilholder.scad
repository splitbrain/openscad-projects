
length = 90; // 87 is the official size
dia = 8; // 7.0 is the official size
number = 10; // how many pencils to hold

finger = 30; // finger/view hole

wall = 1.5; // wall thickness

difference() {
    union() {
        // main corpus
        cube([length + wall*2, dia + wall*2, dia*number + wall]);
        
        // tray
        translate([0, dia + wall, 0])
            cube([length + wall*2, dia + wall*2, dia + wall]);
    }
    
    // inner corpus
    translate([wall, wall, wall])
        cube([length, dia, dia*number]);
    
    // inner tray
    translate([wall, dia+wall, wall])
        cube([length, dia+wall, dia+wall]);
    
    // view/finger hole
    translate([((length  + wall*2)-finger)/2 ,wall,0])
        cube([finger, dia*2+wall*2, dia*number + wall]);
    
    // finger hole in the back
    translate([((length  + wall*2)-finger)/2 ,0 ,0])
        cube([finger, wall*2, dia + wall]);
}

