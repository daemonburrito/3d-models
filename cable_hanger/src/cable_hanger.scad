// pigtail perpendicular hanger
$fn=32;

w = 30;
l = 90;
d = 5;

wire_d = 5;
notch_spacing = 10;
probe = true;
probe_d = 3.9;

back_h = 30;
spine_w = 10;

module hanger() {
    module back() {
        module mounting_hole() {
            cylinder(d=2.54, h=d+d, center=true);
        }

        module holes() {
            hole_spacing = 11;
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
            #holes();
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
            #union() {
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