use <third_party/openscad-fillets/fillets2d.scad>

$fn=50;
epsilon = 0.01;
text_height = 0.2;

module nut_holder(length, nut_circumradius, nut_height, wall, label_text) {
  outer_side = nut_circumradius / 2 + wall;
  outer_inradius = outer_side * sqrt(3) / 2;

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
                linear_extrude(height = outer_side) {
                  hexagon(side = outer_side); 
                }
              }
            }
          }
        }

        // Top holder hole
        translate([0, 0, length - outer_inradius]) {
          rotate([-90, 0, 0]) {
                translate([0, 0, outer_side - nut_height]) {
                  linear_extrude(height = 100) {
                    hexagon(side = nut_circumradius / 2); 
                  }
                }
          }
        }

        // Side holder
        translate([0, 0, -epsilon]) {
          linear_extrude(height = nut_height + epsilon) {
            hexagon(side = nut_circumradius / 2);
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

//nut_holder(length = 70, nut_circumradius = 6.01, nut_height = 2.4, wall = 2.01, label_text = "M3");
nut_holder_text(length = 70, nut_circumradius = 6.01, wall = 2.01, label_text = "M3");