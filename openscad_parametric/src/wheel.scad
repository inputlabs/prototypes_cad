// Libraries
include <BOSL2/std.scad>

// Project parameters
include <parameters.scad>
include <common_references.scad>

// Project dependencies
use <util.scad>
use <wheel_shaft.scad>

// Section: Encoder wheel

// Diameter of the wheel touch surface
wheelDiameter = 21.5;
// Inner diameter of the wheel touch surface of star type
wheelInnerDiameter = 20.5;
// OWidth of the wheel touch surface
wheelWidth = 6.75;
// Diameter of the spacer contact surface
wheelContactDiameter = 9;
// Offset of the spacer contact surface from the touch surface side
wheelContactOffset = 0.335;
// Lenght of the wheel axle
wheelAxelLength = 4.3;
// Chamfer of the wheel touch surface
wheelChamfer = 0.75;

/* 
 * Module: _wheel_body_cylinder()
 * Description: Creates a cylinder shaped wheel body.
 * Usage: _wheel_body_cylinder(n);
 * Arguments:
 *   n = The number of vertices to form the cylinder.
 */
module _wheel_body_cylinder(n) {
  assert(is_num(n) && round(n) == n, "Vertex count must be an integer");
  assert(n > 3, "Vertex count must be more than 3");
 
  cyl(d=wheelDiameter, h=wheelWidth, chamfer=wheelChamfer, anchor=BOTTOM, $fn=n);
}

/* 
 * Module: _wheel_body_star()
 * Description: Creates a star shaped wheel body.
 * Usage:  _wheel_body_star(n);
 * Arguments:
 *   n = The number of vertices to form the star.
 */
module _wheel_body_star(n) {
  assert(is_num(n) && round(n) == n, "Vertex count must be an integer");
  assert(n > 3, "Vertex count must be more than 3");
  
  r = wheelDiameter/2;
  ir = wheelInnerDiameter/2;
  skin(
    [
      star(n=n, r=r-wheelChamfer, ir=ir-wheelChamfer),
      star(n=n, r=r, ir=ir),
      star(n=n, r=r, ir=ir),
      star(n=n, r=r-wheelChamfer, ir=ir-wheelChamfer)
    ], 
    0,
    z=[0, wheelChamfer, wheelWidth-wheelChamfer, wheelWidth]
  );
}

/* 
 * Module: _wheel_body()
 * Description: Creates a wheel body.
 * Usage: _wheel_body(type, n);
 * Arguments:
 *   type = The wheel body type.
 *   n = The number of vertices to form the body.
 */
module _wheel_body(type, n) {
  assert(is_in(type, WHEEL_TYPES), "Invalid wheel type");
  assert(is_num(n) && round(n) == n, "Vertex count must be an integer");
  assert(n > 3, "Vertex count must be more than 3");
  
  type = type == undef ? defaultWheelType : type;
  if (type == WHEEL_TYPE_POLYGON) {
    _wheel_body_cylinder(n);
  }
  if (type == WHEEL_TYPE_STAR) {
    _wheel_body_star(n);
  }
}

/**
 * Module: wheel()
 * Description: Creates a wheel.
 * Usage: wheel([type=], [n=], [anchor=], [spin=], [orient=]) [ATTACHMENTS];
 * Arguments:
 *   type = The wheel body type. Default: `WHEEL_TYPE_STAR`
 *   n = The number of vertices to form the body. Default: `24`
 *   ---
 *   anchor = Translate so anchor point is at origin (0,0,0). Default: `BOTTOM`
 *   spin = Rotate this many degrees around the Z axis after anchor. Default: `0`
 *   orient = Vector to rotate top towards, after spin. Default: `UP`
 * Named anchors:
 *   axle = Encoder wheel axle root
 *   print = Print orientation
 */
module wheel(type=WHEEL_TYPE_STAR, n=24, anchor=BOTTOM, spin=0, orient=UP) {
  assert(is_in(type, WHEEL_TYPES), "Invalid wheel type");
  assert(is_num(n) && round(n) == n, "Vertex count must be an integer");
  assert(n > 3, "Vertex count must be more than 3");
  height = wheelWidth+wheelContactOffset+wheelAxelLength;
  
  anchors = [
    named_anchor("axle", [0,0,height/2-wheelAxelLength], UP, 0),
    named_anchor("print", [0,0,-height/2], UP, 0)
  ];
  
  attachable(anchor,spin,orient, d=wheelDiameter, l=height, anchors=anchors) {
    down(height/2) difference() {
      union() {
        _wheel_body(type, n);
        // Contact interface
        up(wheelWidth)
          cylinder(d=wheelContactDiameter, h=wheelContactOffset, $fn=64);
        // Axle
        up(wheelWidth+wheelContactOffset)
          cylinder(d=wheelAxelDiameter, h=wheelAxelLength, $fn=64);
      }
      wheelShaftCutout(orient=DOWN);
    }
    children();
  }
}
