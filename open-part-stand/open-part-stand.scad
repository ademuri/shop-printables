use <../third_party/openscad-fillets/fillets2d.scad>
use <../third_party/openscad-fillets/fillets3d.scad>

$fn = 50;

length = 100;
width = 100;
height = 50;

length_holes = 4;
width_holes = 4;
outer_width = 5;
joist_width = 1.14;
joist_height = 2;
leg_width = 10;
leg_fillet = 10;

hole_width = (width - (width_holes - 1) * joist_width - outer_width * 2) / width_holes;
hole_length = (length - (length_holes - 1) * joist_width - outer_width * 2) / length_holes;

internal_fillet = 1;

module top() {
    linear_extrude(height = joist_height) {
        difference() {
            rounding2d(r = outer_width) {
                square(size = [length, width], center = false);
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

module leg() {
    rotate(90, [1, 0, 0]) {
        linear_extrude(height = outer_width) {
            square(size = [leg_width, height - joist_height], center = false);
            difference() {
                translate([-leg_fillet, 0]) {
                    square([leg_width + leg_fillet * 2, leg_fillet], center = false);
                }
                translate([-leg_fillet, leg_fillet]) {
                    circle(r = leg_fillet);
                }
                translate([leg_width + leg_fillet, leg_fillet]) {
                    circle(r = leg_fillet);
                }
            }
        }
    }
}

module legs() {
    translate([width / 2 - leg_width / 2, outer_width, joist_height]) {
        leg();
    }
    translate([width - outer_width, length / 2 - leg_width / 2, joist_height]) {
        rotate(90, [0, 0, 1]) {
            leg();
        }
    }
    translate([width / 2 + leg_width / 2, length - outer_width, joist_height]) {
        rotate(180, [0, 0, 1]) {
            leg();
        }
    }
    translate([outer_width, length / 2 + leg_width / 2, joist_height]) {
        rotate(270, [0, 0, 1]) {
            leg();
        }
    }
}


top();
legs();