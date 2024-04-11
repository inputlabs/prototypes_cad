from build123d import BuildSketch, BuildPart, BuildLine, Circle, Plane, \
    Line, Locations, PolarLine, Polyline, PolarLocations, RegularPolygon, \
    SlotCenterToCenter, Keep, Mode, Axis, Kind
from build123d import add, split, mirror, make_face, faces, extrude, edges, \
    chamfer, offset
from math import cos, pi

# Wheel
numberSpokes = 24
outerRadius: float = 10.75
innerRadius: float = 10.25
width = 6.75
chamfering = 0.75

# Core
coreRadius = 8
coreTolerance = 0.06  # Distance core-cutout > core
contactRightWidth = 1.8
contactRightDia = 4
hexAxleDia = 2.05
hexAxleLength = 3.5
leftAxleLength = 5
leftAxleDia = hexAxleDia * cos(pi / 6)

# Holder
holderBaseDepth = 13.8  # original 13
holderTopDepth = 9.8
holderHeight = 13
holderWidth = 8.3  # original 7
holderAxleTolerance = 0.2
holderAxleHeight = 1.0


with BuildSketch() as core_s:
    Circle(coreRadius)
    split(bisect_by=Plane.XZ.offset(leftAxleDia / 2), keep=Keep.BOTTOM)

with BuildPart() as wheel_p:
    with BuildSketch() as wheel_s:
        with BuildLine(mode=Mode.PRIVATE) as wheel_l:
            # construction line first
            c1 = PolarLine(
                (0, 0), innerRadius, 360 / numberSpokes / 2, mode=Mode.PRIVATE
            )
            m1 = Line((outerRadius, 0), c1 @ 1)  # make half of one spoke
            mirror(about=Plane.XZ)  # make one spoke
        with PolarLocations(0, numberSpokes):
            add(wheel_l.line)  # pattern all spokes
        make_face()
    extrude(amount=width)
    forchamfer = edges().filter_by(Axis.Z, reverse=True)
    chamfer(forchamfer, chamfering)

    with BuildSketch() as coreCutout_s:
        add(core_s.sketch)  # reuse sketch
        offset(amount=coreTolerance, kind=Kind.INTERSECTION)  # apply tolerance
        # consider best kind              ^^^
    extrude(amount=width, mode=Mode.SUBTRACT)


with BuildPart() as wheelCore_p:
    add(core_s.sketch)
    extrude(amount=width)
    split_pln = Plane(faces().sort_by(Axis.Y)[0])
    with BuildSketch(Plane.XY.offset(width)) as s:
        Circle(contactRightDia / 2)  # FYI circle accepts radius, not dia
        split(bisect_by=split_pln, keep=Keep.BOTTOM)
    extrude(amount=contactRightWidth)

    with BuildSketch(Plane.XY.offset(width + contactRightWidth)) as s:
        RegularPolygon(hexAxleDia / 2, 6)
    extrude(amount=hexAxleLength)

    with BuildSketch() as s:
        Circle(leftAxleDia / 2)
    extrude(amount=-leftAxleLength)


with BuildPart() as holder_p:
    with BuildSketch(-Plane.XY) as holder_s:
        with Locations((0, leftAxleDia / 2)):
            with BuildLine() as holderLine:
                Polyline([
                    (0, 0),
                    (holderTopDepth / 2, 0),
                    (holderBaseDepth / 2, holderHeight),
                    (0, holderHeight)
                    ])
                mirror(holderLine.line, about=Plane.YZ)
            make_face()
            with Locations((0, holderAxleHeight)):
                Circle(leftAxleDia / 2 + holderAxleTolerance, mode=Mode.SUBTRACT)
    extrude(amount=holderWidth)
    
# show_object(wheel_p)
# show_object(wheelCore_p)
# show_object(holder_p)

# STL Exports
# wheel_p.part.export_stl("wheel.stl")
# wheelCore_p.part.export_stl("wheelcore.stl")
# holder_p.part.export_stl("holder.stl")

# STEP Exports
# wheel_p.part.export_step("wheel.step")
# wheelCore_p.part.export_step("wheelcore.step")
# holder_p.part.export_step("holder.step")
