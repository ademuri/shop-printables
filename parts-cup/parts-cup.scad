use <../third_party/openscad-fillets/fillets3d.scad>

$fn=50;
epsilon = 0.01;

wall = 2.01;
base_diameter = 50;
base_height = 4;
flare = 8;
height = 30;
fillet = 5;

rotate_extrude(convexity = 10) {
    points = [
        [0, 0], [base_diameter / 2 + wall, 0], [base_diameter / 2 + wall + flare, base_height + height],
        [base_diameter / 2 + flare, base_height + height], [base_diameter / 2, base_height], [0, base_height],
        [0, 0],
        ];
    polygon(points);

    difference() {
        translate([base_diameter / 2 - fillet, base_height, 0]) {
            square(size = fillet, center = false);
        }
        translate([base_diameter / 2 - fillet, fillet + base_height, 0]) {
            circle(r = fillet);
        }
    }
}