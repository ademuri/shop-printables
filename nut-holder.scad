use <third_party/openscad-fillets/fillets2d.scad>

$fn=50;
epsilon = 0.01;
text_height = 0.2;

// The side holder is printed with a 45 degree overhang and a bridge, so the
// fit is a little tighter. This adds a little extra space to the side holder
// to compensate.
side_holder_extra_space = 0.1;

module nut_holder(length, nut_circumradius, nut_height, wall, label_text) {
  outer_side = nut_circumradius / 2 + wall;
  outer_inradius = outer_side * sqrt(3) / 2;
  through_diameter = nut_circumradius * 2 / 3;

  translate([0, 0, outer_inradius]) {
    rotate([90, 0, 0]) {
      difference() {
        union() {
          // Main body
          linear_extrude(height = length) {
            hexagon(side = outer_side);
          }

          // Top holder
          translate([0, 0, length - outer_inradius]) {
            rotate([-90, 0, 0]) {
              difference() {
                linear_extrude(height = outer_inradius) {
                  hexagon(side = outer_side); 
                }
              }
            }
          }
        }

        translate([0, 0, length - outer_inradius]) {
          rotate([-90, 0, 0]) {
            // Top holder nut hole
            translate([0, 0, outer_inradius - nut_height]) {
              linear_extrude(height = nut_height + epsilon) {
                hexagon(side = nut_circumradius / 2); 
              }
            }
            // Top holder through hole
            translate([0, 0, -(outer_inradius + epsilon)]) {
              linear_extrude(height = 2 * (outer_inradius + epsilon)) {
                circle(d = through_diameter);
              }
            }
          }
        }
       

        // Side holder nut hole
        translate([0, 0, -epsilon]) {
          linear_extrude(height = nut_height + epsilon) {
            hexagon(side = nut_circumradius / 2 + side_holder_extra_space);
          }
        }
        // Side holder through hole
        translate([0, 0, nut_height - epsilon]) {
          linear_extrude(height = length - outer_side * 2 - 2 + epsilon) {
            radius = through_diameter / 2;
            circle(d = through_diameter);
            points = [
              [radius * cos(45), radius * sin(45)], 
              [radius * cos(135), radius * sin(45)],
              [0, through_diameter * 0.65],
            ];
            polygon(points);
          }
        }

        // Text outline
        rotate([-90, 0, 0]) {
          translate([0, -length / 2, -(outer_inradius + epsilon)]) {
            linear_extrude(height = text_height + epsilon) {
              label(label_text = label_text, size = outer_side);
            }
          }
        }
      }
    }
  }
}

module nut_holder_text(length, nut_circumradius, wall, label_text) {
  outer_side = nut_circumradius / 2 + wall;
  outer_inradius = outer_side * sqrt(3) / 2;

  color("red") {
    translate([0, 0, outer_inradius]) {
      translate([0, -length / 2, -(outer_inradius + epsilon)]) {
              linear_extrude(height = text_height + epsilon) {
                label(label_text = label_text, size = outer_side);
              }
            }
    }
  }
}

module hexagon(side) {
  points = [
    for (a = [0 : 60 : 360]) [side * cos(a), side * sin(a)]
  ];
  polygon(points);
}

module label(label_text, size) {
  rotate([180, 0, 90]) {
    text(text = label_text, halign = "center", valign = "center", size = size);
  }
}

nut_holder(length = 100, nut_circumradius = 6.35, nut_height = 2.9, wall = 2, label_text = "M3");
//nut_holder_text(length = 100, nut_circumradius = 6.35, wall = 1.67, label_text = "M3");
