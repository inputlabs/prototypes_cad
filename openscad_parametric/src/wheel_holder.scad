// Libraries
include <BOSL2/std.scad>

// Project parameters
include <parameters.scad>
include <common_references.scad>

// Section: Encoder wheel holder

// Width of the whele holder
wheelHolderWidth = 7;
// Height of the whele holder
wheelHolderHeight = 13;
// Depth of the slot for wheel axle
wheelHolderTopDepth = 9.8;
// Depth of the slot for wheel axle
wheelHolderBottomDepth = 13;

// Size of the cutout for wheel axle
wheelHolderCutSize = wheelAxelDiameter + 2*Tolerance;

/**
 * Module: wheelHolder()
 * Description: Creates a holder for ecoder wheel to fit the wheel axle into.
 * Usage: wheelHolder([anchor=], [spin=], [orient=]) [ATTACHMENTS];
 * Arguments:
 *   anchor = Translate so anchor point is at origin (0,0,0). Default: `BOTTOM`
 *   spin = Rotate this many degrees around the Z axis after anchor. Default: `0`
 *   orient = Vector to rotate top towards, after spin. Default: `UP`
 * Named anchors:
 *   axle = Encoder wheel axle mount point
 *   print = Print orientation
 */
module wheelHolder(anchor=BOTTOM, spin=0, orient=UP) {
  anchors = [
    named_anchor(
      "axle",
      [wheelHolderWidth/2, 0, (wheelHolderHeight-wheelAxelDiameter)/2], 
      RIGHT,
      0
    ),
    named_anchor("print", [0, 0, 0], UP, 0)
  ];

  attachable(
    anchor,spin,orient, 
    size=[wheelHolderWidth, wheelHolderBottomDepth, wheelHolderHeight],
    size2=[wheelHolderWidth, wheelHolderTopDepth],
    anchors=anchors
  ) {
    difference() {
      prismoid(
        size1=[wheelHolderWidth, wheelHolderBottomDepth],
        size2=[wheelHolderWidth, wheelHolderTopDepth],
        h=wheelHolderHeight,
        anchor=CENTER
      );
      up(wheelHolderHeight/2+Tolerance)
        cuboid([
          wheelHolderWidth+2*Tolerance, 
          wheelHolderCutSize,
          wheelHolderCutSize+Tolerance
        ], anchor=TOP);
    }
    children();
  }
}
