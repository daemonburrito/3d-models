// pigtail perpendicular hanger
$fn=32;

w = 55;
l = 90;
d = 5;

wire_d = 5;
notch_spacing = 13;
probe = false;
probe_d = 3.9;

back_h = 30;
spine_w = 8;

mounting_hole_d = (5/32) * 25.4 + 0.25;
mounting_hole_spacing = 25.4;

keyhole = true;
mounting_head_d = (11/32) * 25.4 + 0.5;

module hanger() {
    module back() {
        module mounting_hole() {
            if (!keyhole) {
                cylinder(d=mounting_hole_d, h=d+d, center=true);
            }
            else {
                translate([0,-mounting_head_d/2,0])
                union() {
                    cylinder(d=mounting_head_d, h=d+d,
                        center=true);

                    translate([0,mounting_head_d/2,0])
                    cube([mounting_hole_d, back_h/3, d+d],
                        center=true);

                    translate([0,back_h/3,0])
                    cylinder(d=mounting_hole_d, h=d*2,
                        center=true);
                }
            }
        }

        module holes() {
            hole_spacing = mounting_hole_spacing;
            mount_w = w;

            translate([0,(back_h/2)+(d/2),0])
            union() {
                translate([(mount_w/2)+(hole_spacing/2),0,1])
                mounting_hole();

                translate([(mount_w/2)-(hole_spacing/2),0,1])
                mounting_hole();
            }
        }

        difference() {
            cube([w,back_h,d]);
            
            //rotate([0,0,90])
            holes();
        }
    }

    module notch(wire_d) {
        cube([(w/2)-(spine_w/2), wire_d+1, d*3], center=true);
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

        translate([0,-notch_spacing/2,0])
        notches();
    }

    rotate([90,0,0])
    translate([-(w/2),0,0])
    back();

    module notches() {
        // divide up platform into maximum # of notches,
        max_notches = (l-d)/(wire_d+notch_spacing)+1;
        notch_w = (w/2)-(spine_w/2);

        for(i=[0:max_notches]) {
            union() {
                // right
                translate([(w-(notch_w))/2,
                    (-l+notch_spacing)+(notch_spacing*i),
                    d/2])
                notch(wire_d);

                // left
                translate([-(w-(notch_w))/2,
                    (-l+notch_spacing)+(notch_spacing*i),
                    d/2])
                notch(wire_d);

                if (probe) {
                    //right
                    translate([(w/2)-probe_d,
                        (-l+notch_spacing)+(notch_spacing*i)+probe_d/2,
                        0])
                    cylinder(r=probe_d, h=d*2);

                    //left
                    translate([-w+w/2+probe_d,
                        (-l+notch_spacing)+(notch_spacing*i)+probe_d/2,
                        0])
                    cylinder(r=probe_d, h=d*2);
                }
            }
        }
    }
}

hanger();