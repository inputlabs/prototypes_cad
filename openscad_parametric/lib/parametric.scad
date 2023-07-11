include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/skin.scad>

module extrude (region, height, fillet_top=0, steps=5) {
    up(height/2) rounded_prism(
        region,
        h=height,
        joint_top=fillet_top,
        splinesteps=steps
    );
}

module loft (region1, region2, height) {
    skin(
        [region1, region2],
        z=[0, height],
        slices=0,
        method="distance"
    );
}

function fillet (path, r=0, $fs=0.5) = round_corners(path, r=r);

function sketch (path) = make_region(path);

function mirrorx (path) =
    set_union(
        path,
        reverse(xflip(path))
    );

function line_horizontal (from, value, constrain_x=undef) = [
    constrain_x==undef ? from.x + value : constrain_x,
    from.y
];

function line_vertical (from, value, constrain_y=undef) = [
    from.x,
    constrain_y==undef ? from.y + value : constrain_y
];

function line (from, value, constrain_x=undef, constrain_y=undef) = [
    constrain_x==undef ? from.x + value.x : constrain_x,
    constrain_y==undef ? from.y + value.y : constrain_y
];

origin = [0, 0];





