// Libraries
include <BOSL2/std.scad>

// Project parameters
include <parameters.scad>

// Project dependencies
use <util.scad>

caseWidth = 157.6;
caseHeight = 97;
caseDepth = 21;

bottomProfile = [
  [0,-2,0], [31,-2,0], each repeat([38,0,0], 2), each repeat([59,0,0], 3),
  [68,-11.83,0], [71.8,-23.25,0], [caseWidth/2,-63.89,0], // max right point
  [77.02,-91,0], [66.63,-caseHeight,0], // max front point
  [53.62,-90.73,0], [46.85,-81.01,0], [41.91,-69.18,0],
  [37.29,-62.3,0], [35.6,-61.4,0], [31,-59.5,0], [0,-59.5,0]
];
middleProfile = [
  [0,-2,14], [31,-2,14], [38,0,10], [45,0,14], each repeat([52,0,14], 2),
  [59,0,10], [68,-10,10], [72,-22.21,10], [74,-35.9,9.49], [71.86,-57,14.72],
  each repeat([61.94,-72,14], 2), [47.22,-76.52,5.15], [40.82,-62.32,10.3],
  each repeat([37.25,-62.27,2.4], 2), [31,-60,5], [0,-60,5]
];
topProfile = [
  [0,-14,19], [31,-14,19], [31,-2,14], [45,0,14], [49,-4,19],
  each repeat([67,-14,19], 4),
  [67,-34,19],[67,-34,19], each repeat([49,-44,19], 2),
  each repeat([40.82,-62.32,10.3], 4), [31,-59,13], [0,-59,13]
];
surfaceProfile = [
  [0,-34,19], [31,-34,19],
  each repeat([31,-14,19], 7), each repeat([49,-44,19], 4),
  [31,-56.5,15.7], [0,-56.5,15.7]
];
hexProfile = [[49,-4], [67,-14], [67,-34], [49,-44], [31,-34], [31,-14]];

/**
 * Module: frontCase()
 * Description: Creates a front case.
 * Usage: frontCase([anchor=], [spin=], [orient=]) [ATTACHMENTS];
 * Arguments:
 *   anchor = Translate so anchor point is at origin (0,0,0). Default: `BOTTOM+BACK`
 *   spin = Rotate this many degrees around the Z axis after anchor. Default: `0`
 *   orient = Vector to rotate top towards, after spin. Default: `UP`
 * Named anchors:
 *   print = Print orientation
 */
module frontCase(anchor=BOTTOM+BACK, spin=0, orient=UP) {
  anchors = [
    named_anchor("print", [0,0,-caseDepth/2], UP, 0)
  ];
  
  attachable(anchor,spin,orient, size=[caseWidth,caseHeight,caseDepth], anchors=anchors) {
    move([0,caseHeight/2,-caseDepth/2]) {
      xflip_copy() {
        skin([bottomProfile, middleProfile, topProfile, surfaceProfile], 0);
        move([14,-2,14]) prismoid([12,12], [12,8], h=5, shift=[0,-2], anchor=BOTTOM+LEFT+BACK);
        linear_extrude(caseDepth) polygon(hexProfile);
      }
    }
    children();
  }
}
