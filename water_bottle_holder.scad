include <lib/lasercut-box-openscad/box.scad>
// Note: could have used https://github.com/bmsleight/lasercut too, would avoid the double cutout, but as the cutouts are very simple this one works just fine.

// Uncheck to get the final laser cut
assemble=true;

height=200;
thickness=4;
gaps=20;
radius=44;
countX=3;
countY=2;
fingerWidth=30;
fingerMargin=10;

diameter=radius*2;
width=countX*diameter + (countX+1)*gaps;
depth=countY*diameter + (countY+1)*gaps;

minkowskiSize=gaps;

module side_cutout() {
    translate([gaps+minkowskiSize, gaps+minkowskiSize, -1])
        minkowski()
        {
            cube([width - gaps*2 - minkowskiSize*2, height - gaps*2 - minkowskiSize*2, thickness+2]);
            cylinder(r=minkowskiSize,h=1);
        }
}

module top_cutout() {
    for (x = [0:1:countX-1]){
        for (y = [0:1:countY-1]){
            translate([x*(diameter+gaps) + radius + gaps, y*(diameter+gaps) + radius + gaps, -1])
            cylinder(r=radius, h=thickness+2);
        }
    };
}

if (assemble) {
    difference() {
        box(width = width, height = height, depth = depth, thickness = thickness, finger_width=fingerWidth, finger_margin=fingerMargin, assemble = assemble);

        // Holes
        translate([0, 0, height-thickness]) top_cutout();
        
        // Sides
        translate([0, thickness, 0]) rotate([90, 0, 0]) side_cutout();
        translate([0, depth, 0]) rotate([90, 0, 0]) side_cutout();
    }
} else {
    difference() {
        box(width = width, height = height, depth = depth, thickness = thickness, finger_width=fingerWidth, finger_margin=fingerMargin, assemble = assemble);

        // Holes
        projection() translate([0, height, 0]) top_cutout();
        
        
        // Sides
        projection() side_cutout();
        projection() translate([width, 0, 0]) side_cutout();
 }
}