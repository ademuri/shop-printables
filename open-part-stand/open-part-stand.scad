use <../third_party/openscad-fillets/fillets2d.scad>
use <../third_party/openscad-fillets/fillets3d.scad>

$fn = 50;

length = 80;
width = 100;
height = 50;

length_holes = 4;
width_holes = 4;
outer_width = 5;
outer_height = 3;
joist_width = 1.14;
joist_height = 2;
leg_width = 5;
leg_fillet = 10;

hole_width = (width - (width_holes - 1) * joist_width - outer_width * 2) / width_holes;
hole_length = (length - (length_holes - 1) * joist_width - outer_width * 2) / length_holes;

internal_fillet = 1;

module top_outer() {
    difference() {
        rounding2d(r = outer_width) {
            square(size = [width, length], center = false);
        }
        translate([outer_width, outer_width]) {
            square([width - outer_width * 2, length - outer_width * 2], center = false);
        }
    }
}

module top() {
    linear_extrude(height = height) {
        top_outer();
    }
    linear_extrude(height = joist_height) {
        difference() {
            rounding2d(r = outer_width) {
                square(size = [width, length], center = false);
            }
            union() {
                for (x = [0:width_holes - 1]) {
                    for (y = [0:length_holes - 1]) {
                        translate([outer_width + x * (hole_width + joist_width), outer_width + y * (hole_length + joist_width)]) {
                            rounding2d(r = internal_fillet) {
                                square(size = [hole_width, hole_length], center = false);
                            }
                        }
                    }
                }
            }
        }
    }
}

difference() {
    top();
    translate([0, length + 1, 0]) {
        rotate(90, [1, 0, 0]) {
            linear_extrude(height = length + 2) {
                union() {
                    translate([outer_width + leg_width + leg_fillet, outer_height]) {
                        square([width - (outer_width + leg_width + leg_fillet) * 2, height]);
                    }
                    translate([outer_width + leg_width, outer_height + leg_fillet]) {
                        square([width - (outer_width + leg_width) * 2, height]);
                    }
                    translate([outer_width + leg_width + leg_fillet, outer_height + leg_fillet]) {
                        circle(r = leg_fillet);
                    }
                    translate([width - (outer_width + leg_width + leg_fillet), outer_height + leg_fillet]) {
                        circle(r = leg_fillet);
                    }
                }
            }
        }
    }
    translate([-1, 0, 0]) {
        rotate([90, 0, 90]) {
            linear_extrude(height = width + 2) {
                union() {
                    translate([outer_width + leg_width + leg_fillet, outer_height]) {
                        square([length - (outer_width + leg_width + leg_fillet) * 2, height]);
                    }
                    translate([outer_width + leg_width, outer_height + leg_fillet]) {
                        square([length - (outer_width + leg_width) * 2, height]);
                    }
                    translate([outer_width + leg_width + leg_fillet, outer_height + leg_fillet]) {
                        circle(r = leg_fillet);
                    }
                    translate([length - (outer_width + leg_width + leg_fillet), outer_height + leg_fillet]) {
                        circle(r = leg_fillet);
                    }
                }
            }
        }
    }
}