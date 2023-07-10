// Libraries
include <BOSL2/std.scad>

// Project parameters
include <parameters.scad>
include <common_references.scad>

// Section: Encoder wheel shaft

// Length of the wheel shaft side
shaftSideLenght = 6;
// Width of the wheel shaft base
shaftBaseWidth = 11.75;
// Height of the wheel shaft base
shaftBaseHeight = 5.15;
// Width of the wheel shaft contact spacer surface
shaftContactWidth = 5;
// Outer diameter of the wheel shaft hex axle
shaftAxelDiameter = 2;
// Height of the wheel shaft hex axle
shaftAxelHeight = 3;

// Distance of parallel sides of the wheel shaft hex axle
shaftAxelWidth = sqrt(3)/2*shaftAxelDiameter;

/*
 * Module: _wheelShaftBody()
 * Description: Creates a wheel shaft body.
 * Usage: _wheelShaftBody([tolerance=]);
 * Arguments:
 *   tolerance = The tolerance by which the body faces are expanded. Default: `0`
 */
module _wheelShaftBody(tolerance=0) {
  // Vertical tolerance is doubled to compensate for bridge sagging
  height = shaftBaseHeight+4*tolerance;
  width = shaftBaseWidth+2*tolerance;
  side = shaftSideLenght+2*tolerance;
  chamfer = (width - side)/2;
  
  down(2*tolerance)
    cuboid([width, width, height], chamfer=chamfer, edges="Z", anchor=BOTTOM);
}

/**
 * Module: wheelShaft()
 * Description: Creates a wheel shaft.
 * Usage: wheelShaft([anchor=], [spin=], [orient=]) [ATTACHMENTS];
 * Arguments:
 *   anchor = Translate so anchor point is at origin (0,0,0). Default: `"wheel"`
 *   spin = Rotate this many degrees around the Z axis after anchor. Default: `0`
 *   orient = Vector to rotate top towards, after spin. Default: `UP`
 * Named anchors:
 *   wheel = Encoder wheel mount point
 *   axle = Rotary encoder hex axle mount point
 *   print = Print orientation
 */
module wheelShaft(anchor="wheel", spin=0, orient=UP) {
  height = shaftBaseHeight+wheelShaftContactOffset+shaftAxelHeight;
  move = height/2;
  
  anchors = [
    named_anchor("wheel", [0,0,shaftBaseHeight-move], UP, 0),
    named_anchor("axle", [0,0,shaftBaseHeight+wheelShaftContactOffset-move], UP, 0),
    named_anchor("print", [0,0,-move], UP, 0)
  ];
  
  attachable(anchor,spin,orient, size=[shaftBaseWidth,shaftBaseWidth,height], anchors=anchors) {
    down(move) difference() {
      union() {
        _wheelShaftBody();
        // Contact Pad
        up(shaftBaseHeight)
          cuboid([shaftContactWidth, shaftContactWidth, wheelShaftContactOffset], anchor=BOTTOM);
        // Shaft Hex
        up(shaftBaseHeight+wheelShaftContactOffset)
          cylinder(h=shaftAxelHeight, d=shaftAxelDiameter, $fn=6);
      }
      back(shaftBaseWidth+shaftAxelWidth/2)
        cube(shaftBaseWidth*2, true);
    }
    children();
  }
}

/**
 * Module: wheelShaftCutout()
 * Description: Creates a cutout for wheel shaft to fit in.
 * Usage: wheelShaftCutout([anchor=], [spin=], [orient=]) [ATTACHMENTS];
 * Arguments:
 *   anchor = Translate so anchor point is at origin (0,0,0). Default: `"wheel"`
 *   spin = Rotate this many degrees around the Z axis after anchor. Default: `0`
 *   orient = Vector to rotate top towards, after spin. Default: `UP`
 * Named anchors:
 *   wheel = Encoder wheel mount point
 */
module wheelShaftCutout(anchor="wheel", spin=0, orient=UP) {
  height = shaftBaseHeight+4*Tolerance;
  move = height/2;

  anchors = [
    named_anchor("wheel", [0,0,shaftBaseHeight-move], UP, 0)
  ];

  attachable(anchor,spin,orient, size=[shaftBaseWidth,shaftBaseWidth,height], anchors=anchors) {
    down(move) difference() {
      _wheelShaftBody(Tolerance);
      back(shaftBaseWidth+shaftAxelWidth/2+Tolerance)
        cube(shaftBaseWidth*2, true);
    }
    children();
  }
}
