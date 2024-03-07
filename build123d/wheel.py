from math import tau
from math import cos
from math import sin
from math import sqrt
from math import pi

from build123d import Box
from build123d import Circle
from build123d import Cylinder
from build123d import Pos
from build123d import Rectangle
from build123d import Polygon
from build123d import Polyline
from build123d import RegularPolygon
from build123d import Axis
from build123d import Plane
from build123d import Rot
from build123d import extrude
from build123d import chamfer
from build123d import mirror
from build123d import make_face


## Wheel
numberSpokes = 24
outerRadius: float = 10.75
innerRadius: float =  10.25
width = 6.75
chamfering = 0.75

## Core
coreRadius = 8
coreTolerance = 0.06 ## Distance core-cutout > core
contactRightWidth = 1.8
contactRightDia = 4
hexAxleDia = 1
hexAxleLenght = 3
leftAxleLength = 5

## Holder
holderBaseDepth = 13.8 ## original 13
holderTopDepth = 9.8
holderHeight = 13
holderWidth = 8.3 ## original 7
holderAxleTolerance = 0.1


def star(outerRadius: float = 1, innerRadius: float =  0.3, n: int = 6) -> Polygon:
    right = tau / 4
    thetaStep = tau / numberSpokes
    half_thetaStep = thetaStep / 2

    points = []
    for i in range(n):
        a = thetaStep * i + right
        outerPoint = (outerRadius * cos(a), outerRadius * sin(a))
        innerPoint = (innerRadius * cos(a + half_thetaStep), innerRadius * sin(a + half_thetaStep))
        points.append(outerPoint)
        points.append(innerPoint)
    return points

wheel = extrude(Polygon(star(outerRadius, innerRadius, numberSpokes)), amount = width)
wheel = chamfer(wheel.edges().group_by(Axis.Z)[-1], length=chamfering)
wheel = chamfer(wheel.edges().group_by(Axis.Z)[0], length=chamfering)


core = Circle(coreRadius)
core -= Pos(0, -coreRadius/2 - hexAxleDia * sin(pi/3)) * Rectangle(2*coreRadius, coreRadius)
core -= Pos(coreRadius + 0.5, 2) * Rectangle(2, 6)

coreCutout = Circle(coreRadius + coreTolerance)
coreCutout  -= Pos(0, -coreRadius/2 - hexAxleDia * sin(pi/3)) * Rectangle(2*(coreRadius + coreTolerance), coreRadius)
coreCutout  -= Pos(coreRadius + 0.5 + coreTolerance, 2) * Rectangle(2, 6)

wheel -= extrude(coreCutout  , width)

show_object(wheel)


wheelCore = extrude(core , width)
wheelCore += Pos(0, 0, width) * extrude(Circle(contactRightDia) - Pos(0, -contactRightDia/2 - hexAxleDia * sin(pi/3)) * Rectangle(8, 4), contactRightWidth)
wheelCore += Pos(0, 0, width + contactRightWidth) * extrude(RegularPolygon(hexAxleDia, 6), hexAxleLenght) 
axleDia = hexAxleDia * sin(pi/3)
wheelCore += Pos(0, 0, -leftAxleLength/2) * Cylinder(axleDia, leftAxleLength)

show_object(wheelCore)


holderPoints = [
    (0, 0),
    (holderBaseDepth / 2, 0),
    (holderTopDepth / 2, holderHeight),
    (0, holderHeight)
    ]

holderOutline = Polyline(holderPoints)
holderOutline += mirror(holderOutline, Plane.YZ)

plane = make_face(Plane.XZ * holderOutline)

holder = Pos(0, holderHeight - axleDia, 0) * Rot(X=90) * extrude(plane, holderWidth)
holder -= Pos(0, 0, -holderWidth/2) * Cylinder(axleDia + holderAxleTolerance, holderWidth)
holder -= Pos(0, -axleDia/2, -holderWidth/2) * Box(2*(axleDia + holderAxleTolerance), axleDia, holderWidth)

show_object(holder)


#wheel.export_stl("wheel.stl")
#wheelCore.export_stl("wheelcore.stl")
#holder.export_stl("holder.stl")
