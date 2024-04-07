include <lib/lasercut-box-openscad/box.scad>
// Note: could have used https://github.com/bmsleight/lasercut too, but this one just fits my usecase perfectly...

// Uncheck to get the final laser cut
assemble=true;

height=200;
thickness=3;
gaps=20;
radius=44;
countX=3;
countY=2;

diameter=radius*2;
width=countX*diameter + (countX+1)*gaps;
depth=countY*diameter + (countY+1)*gaps;

minkowskiSize=gaps;

difference() {
    box(width = width, height = height, depth = depth, thickness = thickness, assemble = assemble);

    // Holes
    for (x = [0:1:countX-1]){
        for (y = [0:1:countY-1]){
            translate([x*(diameter+gaps) + radius + gaps, y*(diameter+gaps) + radius + gaps, height-thickness-1])
            cylinder(r=radius, h=thickness+2);
        }
    };
    
    // Sides
    translate([gaps+minkowskiSize, -1, gaps+minkowskiSize])
    minkowski()
    {
        cube([width - gaps*2 - minkowskiSize*2, depth+2, height - gaps*2 - minkowskiSize*2]);
        rotate([90,0,0]) cylinder(r=minkowskiSize,h=1);
    }
}