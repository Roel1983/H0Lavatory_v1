$fn= 128;

translate([0,0,20]) roof([14,14], 15, 0.5, 0.8, 0.4);
wall_back();
wall_front();
wall_left();
wall_right();
base();

*difference() {
    translate([0,6-.06*3,13/2+1]) cube([7,1 + 0.06*8,13], true);
    translate([2.5,6-.06*3]) cylinder(d=1, h=100, center=true);
}

module base() {
    difference() {
        union() {
            translate([0,0,-10])cylinder(d=19.8, h=10);
            translate([0,0,-3/2-9.5])cube([35,35,3], true);
            cube([12-2-.2,12-2-.2,1], true);
            translate([0,3]) cube([7.2,12-2-.2,1], true);
            translate([0,-2.4])cube([9.8,5,10], true);
        }
        for(x=[-12,12], y=[-12,12]) translate([x,y, -14]) {
            cylinder(d1=10, d2=4,3);
            cylinder(d=4,100);
        }
        translate([2.5,6-.06*3]) cylinder(d=1.2, h=100, center=true);
        translate([4.1,4.3,1.1]) cylinder(d=1.2, h=100, center=true);
        translate([-4.1,4.3,1.1]) cylinder(d=1.2, h=100, center=true);
        translate([-4.1,4.3,-1.1]) mirror([0,0,1]) cylinder(d=2.8, h=100);
        translate([0,-1.5]) cylinder(d=1.3, h=100, center=true);
    }
}

module wall_front() {
    difference() {
        union() {
            wall_front_back();
            translate([0,6]) {
                translate([0,0,16/2]) cube([9,1,16], true);
            }
        }
        translate([0,6]) {
            cube([9-1.6,4,(16-1.6)*2], true);
        }
        translate([2.5,6-.06*3]) {
            cylinder(d=1, h=15.9);
        }
    }
}

module wall_back() {
    mirror([0,1,0]) wall_front_back();
}

module wall_left() {
    difference() {
        union() {
            mirror([1,0,0]) wall_side();
            translate([6,0,16]) cube([1,7,7], true);
        }
        translate([6,0,16]) cube([4,7-1.6,7-1.6], true);
    }
    translate([6,0,16]) {
        cube([1,0.75,5.5], true);
        cube([1,5.5,0.75], true);
    }
}

module wall_right() {
    wall_side();
}

module wall_front_back() {
    intersection() {
        translate([0,6]) wall([12,25,1], 0.75, 0.24);
        r();
    }
}

module wall_side() {
    intersection() {
        rotate(90) translate([0,6]) wall([12,25,1], 0.75, 0.24);
        r();
    }
}

module r() {
    translate([0,0,6.7]) rotate(90,[1,0,0])cylinder(r=15, h=1000, center=true);
}

module wall(dim, p_w, p_d) {
    p_n = floor((dim[0] / p_w - 2) / 2) * 2;
    points = concat(
        [
            for(i=[-p_n/2:2:p_n/2], j=[0:3]) [
                (i + (j <= 1?-.5:.5)) * p_w,
                j == 0 || j == 3 ? 0 : p_d
            ]
        ], [
            [ dim[0]/2,0],
            [ dim[0]/2-dim[2],-dim[2]],
            [-dim[0]/2+dim[2],-dim[2]],
            [-dim[0]/2,0]
        ]
    );
    linear_extrude(dim[1]) polygon(points, convexity=1);
} 

module roof(dim, radius, thickness, rib_p, rib_d) {
    intersection() {
        points = concat(
            [for(y=[-dim[1]/2:rib_p/8:dim[1]/2]) [
                radius + thickness + (sin(y/rib_p * 360) + 1) * rib_d /2,
                y]
            ], [
                [0, dim[1]/2],
                [0, -dim[1]/2]
            ]
        );
        translate([0,0, -sqrt(pow(radius,2)-pow(dim[0]/2, 2))]) {
            difference() {
                rotate(90, [1,0,0]) rotate_extrude(center = true) polygon(points);
                rotate(90,[1,0,0])cylinder(r=radius, h=1000, center=true);
            }
        }
        translate([0,0,dim[0]/2])cube([dim[0], dim[1], dim[0]], true);
    }
}