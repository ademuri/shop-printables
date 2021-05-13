use <../third_party/openscad-fillets/fillets2d.scad>

$fn=50;
epsilon = 0.01;
text_height = 0.2;
text_scale = 0.95;

function inch(x) = x * 25.4;

// The side holder is printed with a 45 degree overhang and a bridge, so the
// fit is a little tighter. This adds a little extra space to the side holder
// to compensate.
side_holder_extra_space = 0.02;

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
              [0, through_diameter * 0.62],
            ];
            polygon(points);
          }
        }

        // Text outline
        rotate([-90, 0, 0]) {
          translate([0, -length / 2, -(outer_inradius + epsilon)]) {
            linear_extrude(height = text_height + epsilon) {
              label(label_text = label_text, size = outer_side * text_scale);
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
                label(label_text = label_text, size = outer_side * text_scale);
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

// length, nut_circumradius, nut_height, wall, label_text
params = [
  [100, 4.65, 1.6, 2, "M2"  ],
  [100, 5.8 , 2  , 2, "M2.5"],
  [100, 6.35, 2.9, 2, "M3"],
  [100, 8.08, 3.8, 2, "M4"  ],
  [100, inch(23/64), inch(7/64), 2, "#6"],
  [100, inch(25/64), inch(1/8), 2, "#8"],
  [100, inch(27/64), inch(1/8), 2, "#10"],
  [100, inch(1/2), inch(3/16), 2, "1/4"],
];

spacing = 20;
translate([-len(params) / 2 * spacing, 0, 0]) {
  for (i = [0 : len(params) - 1]) {
    p = params[i];
    translate([i * 20, 0, 0]) {
      nut_holder(length = p[0], nut_circumradius = p[1], nut_height = p[2], wall = p[3], label_text = p[4]);
      nut_holder_text(length = p[0], nut_circumradius = p[1], wall = p[3], label_text = p[4]);
    }
  }
}

