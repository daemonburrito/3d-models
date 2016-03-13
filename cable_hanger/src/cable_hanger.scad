// pigtail perpendicular hanger
$fn=32;

w = 30;
l = 90;
d = 5;

wire_r = 3;
notch_spacing = 10;

module hanger() {
    module back() {
        difference() {
            cube([w,w,d]);
            
            rotate([0,0,90])
            union() {
                translate([(w/2)+d,-(w/4),-d/2])
                cylinder(d=2.54, h=d+d);

                translate([(w/2)+d,-(w*0.75),-d/2])
                cylinder(d=2.54, h=d+d);
            }
        }
    }

    module notch(wire_r) {
        cube([w/3+1, wire_r+1, d*2]);
    }

    module platform() {
        rotate([0,0,-90])
        translate([0,-(w/2),0])
        cube([l, w, d]);
    }

    module barrier() {
        cube([l,d/2,d/2]);
    }

    difference() {
        union() {
            platform();

            rotate([0,0,-90])
            translate([0,(w/2)-d/2,d])
            barrier();

            rotate([0,0,-90])
            translate([0,-w/2,d])
            barrier();
        }
        notches();
    }

    rotate([90,0,0])
    translate([-(w/2),0,0])
    back();

    module notches() {
        // divide up platform into maximum # of notches,
        max_notches = (l-d)/(wire_r+notch_spacing);
        for(i=[0:max_notches]) {
            union() {
                // right
                translate([w-w*0.865,
                    (-l+notch_spacing)+(notch_spacing*i),
                    0])
                rotate([0,0,0])
                notch(wire_r);

                // left
                translate([-w+w/2,
                    (-l+notch_spacing)+(notch_spacing*i),
                    0])
                rotate([0,0,0])
                notch(wire_r);
            }
        }
    }
}

hanger();