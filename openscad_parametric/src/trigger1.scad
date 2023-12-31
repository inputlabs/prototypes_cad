// Libraries
include <BOSL2/std.scad>

// Project parameters
include <parameters.scad>

// Project dependencies
use <util.scad>

shaftDiameter = 5.8;
shaftHeight = 12.5;

bodyWidth = 6.81;
bodyLength = 17;
bodyHeight = 8.9;

bodyDraft1Width = 3;
bodyDraft1Length = 11.1;

bodyDraft2Width = 1.2;
bodyDraft2Length = 2;
bodyDraft2Offset = 6;

bodyDraft3Width = 3.5;
bodyDraft3Length = 3.7;

bodyDraft5Offset = 1.9;
bodyDraft5Width = 2.842-bodyDraft5Offset;
bodyDraft5Length = bodyLength-bodyDraft2Offset-bodyDraft2Length;

bodyDraft4Width = 1.058;
bodyDraft4Length = 2;
bodyDraft4Offset = bodyDraft5Offset-bodyDraft4Width;
bodyDraft4Depth = 0.9;

triggerSurfaceWidth = 5.1;
triggerSurfaceLength = 18.3;
triggerSurfaceTopLength = 7;
triggerSurfaceTopShift = 0.25;
triggerSurfaceHeight = 12.5;
triggerSurfaceTopHeight = 3.3;
triggerSurfaceDraft1Width = 0.4;
triggerSurfaceDraft2Width = 1.5;

chamfer = 0.5;

/**
 * Module: _trigger1Body()
 * Description: Creates a body for R1 and L1 trigger.
 * Usage: trigger1(fit);
 * Arguments:
 *   fit = Fit of the part.
 */
module _trigger1Body(fit) {
  effectiveBodyHeight = bodyHeight - (fit == FIT_TIGHT ? 0 : 0.2);

  bodyDraft1Angle = adj_opp_to_ang(bodyDraft1Length, bodyDraft1Width);
  bodyDraft2Angle = adj_opp_to_ang(bodyDraft2Length, bodyDraft2Width);
  bodyDraft3Angle = adj_opp_to_ang(bodyDraft3Width, bodyDraft3Length);
  bodyDraft4Angle = adj_opp_to_ang(bodyDraft4Length, bodyDraft4Width);
  bodyDraft5Angle = adj_opp_to_ang(bodyDraft5Length, bodyDraft5Width);
  
  difference() {
    diff()
      cube([bodyWidth, bodyLength, effectiveBodyHeight], anchor=BOTTOM+BACK+LEFT)
        edge_profile([BACK+RIGHT]) mask2d_chamfer(x=bodyDraft1Width, angle=bodyDraft1Angle);
    // Left coutout
    diff()
      move([-1,-bodyDraft2Offset,-1])
        cube([bodyDraft2Width+1, bodyLength, effectiveBodyHeight+2], anchor=BOTTOM+BACK+LEFT)
          edge_profile([BACK+RIGHT]) mask2d_chamfer(x=bodyDraft2Width, angle=bodyDraft2Angle);
    // Left draft
    move([1.2,-bodyLength,effectiveBodyHeight/2])
      linear_extrude(height=effectiveBodyHeight+2, center=true)
        mask2d_chamfer(x=3.5, angle=bodyDraft3Angle);
    // Top cutout
    diff()
      move([0,-bodyDraft2Offset,effectiveBodyHeight+1])
      cube([bodyDraft4Width+bodyDraft4Offset, bodyDraft4Length+1, bodyDraft4Depth+1], anchor=TOP+BACK+LEFT)
        edge_profile([BACK+RIGHT]) mask2d_chamfer(y=bodyDraft4Length, angle=bodyDraft4Angle);
    diff()
      move([0,-bodyLength,effectiveBodyHeight+1])
      cube([bodyDraft5Width+bodyDraft5Offset, bodyDraft5Length, bodyDraft4Depth+1], anchor=TOP+FRONT+LEFT)
        edge_profile([BACK+RIGHT]) mask2d_chamfer(y=bodyDraft5Length, angle=bodyDraft5Angle);
  }
}

/**
 * Module: _trigger1TriggerSurface()
 * Description: Creates a trigger surface for R1 and L1 trigger.
 * Usage: trigger1(fit);
 * Arguments:
 *   fit = Fit of the part.
 */
module _trigger1TriggerSurface(fit) {
  effectiveTriggerSurfaceHeight = triggerSurfaceHeight - (fit == FIT_TIGHT ? 0 : 0.2);
  triggerSurfaceBottomHeight = triggerSurfaceHeight-triggerSurfaceTopHeight;
  triggerSurfaceDraftAvr = (triggerSurfaceLength-triggerSurfaceTopLength)/2;
  
  difference() {
    intersection() {
      union() {
        cuboid(
          [triggerSurfaceWidth,triggerSurfaceLength,triggerSurfaceBottomHeight],
          anchor=BOTTOM+BACK+LEFT
        );
        up(triggerSurfaceBottomHeight)
          prismoid(
            [triggerSurfaceWidth,triggerSurfaceLength],
            [triggerSurfaceWidth,triggerSurfaceTopLength],
            h=triggerSurfaceTopHeight,
            shift=[0,-triggerSurfaceTopShift],
            anchor=BOTTOM+BACK+LEFT,
            chamfer=[chamfer,0,0,chamfer]
          );
      }
      cuboid(
        [triggerSurfaceWidth, triggerSurfaceLength,effectiveTriggerSurfaceHeight],
        anchor=BOTTOM+BACK+LEFT,
        chamfer=chamfer,
        edges=[RIGHT]
      );
    }
    move([0,0,effectiveTriggerSurfaceHeight/2]) rotate([180,0,0])
      linear_extrude(height=effectiveTriggerSurfaceHeight+1, center=true)
        mask2d_chamfer(
          x=triggerSurfaceDraft1Width,
          angle=adj_opp_to_ang(triggerSurfaceDraftAvr+triggerSurfaceTopShift,triggerSurfaceDraft1Width)
        );
    move([0,-triggerSurfaceLength,effectiveTriggerSurfaceHeight/2])
      linear_extrude(height=effectiveTriggerSurfaceHeight+1, center=true)
        mask2d_chamfer(
          x=triggerSurfaceDraft2Width, 
          angle=adj_opp_to_ang(triggerSurfaceDraftAvr-triggerSurfaceTopShift,triggerSurfaceDraft2Width)
        );
  }
}

/**
 * Module: trigger1()
 * Description: Creates a trigger for R1 and L1 switches.
 * Usage: trigger1([fit=], [anchor=], [spin=], [orient=]) [ATTACHMENTS];
 * Arguments:
 *   fit = Fit of the part. Default: `FIT_TIGHT`
 *   ---
 *   anchor = Translate so anchor point is at origin (0,0,0). Default: `BOTTOM`
 *   spin = Rotate this many degrees around the Z axis after anchor. Default: `0`
 *   orient = Vector to rotate top towards, after spin. Default: `UP`
 * Named anchors:
 *   axleBottom = Bottom of the axle
 *   axleTop = Top of the axle
 *   axleContact = Axle socket contact point
 *   switch = Switch contact point
 *   print = Print orientation
 */
module trigger1(fit=FIT_TIGHT, anchor=BOTTOM, spin=0, orient=UP) {
  assert(is_in(fit, FITS), "Invalid fit");
  fit = fit == undef ? defaultFit : fit;
  switchPosition = [
    bodyDraft2Width-shaftDiameter/2,
    -bodyLength+bodyDraft3Width+(bodyLength-bodyDraft2Length-bodyDraft2Offset-bodyDraft3Width)/2,
    bodyHeight/2-shaftHeight/2-bodyDraft4Depth/2
  ];
  
  anchors = [
    named_anchor("axleBottom", [0,0,-shaftHeight/2], UP, 0),
    named_anchor("axleTop", [0,0,shaftHeight/2], UP, 0),
    named_anchor("axleContact", [0,0,bodyHeight+-shaftHeight/2], UP, 0),
    named_anchor("switch", switchPosition, LEFT, 0),
    named_anchor("print", [0,0,-shaftHeight/2], UP, 0)
  ];
  
  attachable(anchor,spin,orient, d=shaftDiameter, l=shaftHeight, anchors=anchors) {
    down(shaftHeight/2) union() {
      cylinder(d=shaftDiameter, h=shaftHeight - (fit == FIT_TIGHT ? 0 : 0.2), $fn=64);
      left(shaftDiameter/2)
        _trigger1Body(fit);
      move([bodyWidth-shaftDiameter/2-triggerSurfaceDraft1Width, -bodyDraft1Length, 0])
        _trigger1TriggerSurface(fit);
    }
    children();
  }
}
