// Libraries
include <BOSL2/std.scad>

// Project parameters
include <parameters.scad>
include <common_references.scad>

// Project dependencies
use <wheel.scad>
use <wheel_shaft.scad>
use <wheel_holder.scad>

/**
 * Module: wheelAssembly()
 * Description: Creates a encoder wheel assembly including a cutout.
 * Usage: wheelAssembly([type=], [n=], [anchor=], [spin=], [orient=]) [ATTACHMENTS];
 * Arguments:
 *   type = The wheel body type. Default: `WHEEL_TYPE_STAR`
 *   n = The number of vertices to form the body. Default: `24`
 *   ---
 *   anchor = Translate so anchor point is at origin (0,0,0). Default: `"axle"`
 *   spin = Rotate this many degrees around the Z axis after anchor. Default: `0`
 *   orient = Vector to rotate top towards, after spin. Default: `RIGHT`
 * Named anchors:
 *   axle = Rotary encoder hex axle mount point
 */
module wheelAssembly(type=WHEEL_TYPE_STAR, n=24, anchor="axle", spin=0, orient=RIGHT) {
  anchors = [
    named_anchor("axle", [0,0,0], RIGHT, 0)
  ];
  
  attachable(anchor,spin,orient, anchors=anchors) {
    wheelShaft(anchor="axle", orient=UP)
      wheel(type, n, orient=DOWN, anchor=BOTTOM)
        up(Tolerance) position("axle") wheelHolder(anchor="axle", orient=RIGHT);
    children();
  }
}

/**
 * Module: wheelAssemblyCutout()
 * Description: Creates a cutout for the encoder wheel assembly.
 * Usage: wheelAssembly([anchor=], [spin=], [orient=]) [ATTACHMENTS];
 * Arguments:
 *   anchor = Translate so anchor point is at origin (0,0,0). Default: `"axle"`
 *   spin = Rotate this many degrees around the Z axis after anchor. Default: `0`
 *   orient = Vector to rotate top towards, after spin. Default: `RIGHT`
 * Named anchors:
 *   axle = Rotary encoder hex axle mount point
 */
module wheelAssemblyCutout(anchor="axle", spin=0, orient=RIGHT) {
  anchors = [
    named_anchor("axle", [0,0,0], RIGHT, 0)
  ];
  
  attachable(anchor,spin,orient, anchors=anchors) {
    union() {} // TODO replace the placeholder
    children();
  }
}
