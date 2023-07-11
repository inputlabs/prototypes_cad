include <constants.scad>

// Thread diammeter of screws used in the project
// Default: 2.5
ScrewDiameter = 2.5;

// Tolerance to add between moving parts
// Default: 0.1
Tolerance = 0.1;

// Part fit
// Options: FIT_TIGHT, FIT_LOOSE
// Default: FIT_TIGHT
TriggerFit = FIT_TIGHT;

// Encoder wheel type
// Option: WHEEL_TYPE_STAR, WHEEL_TYPE_POLYGON
// Default: WHEEL_TYPE_STAR
WheelType = WHEEL_TYPE_STAR;

// Encoder wheel vetex count
// Default: 24
WheelVertices = 24;
