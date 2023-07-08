module annotate (name, coord, shift="RIGHT") {
    let (
        pad = 1,
        margin = shift=="UP" ?    [0, pad] :
                 shift=="DOWN" ?  [0, -pad] :
                 shift=="LEFT" ?  [-pad, 0] :
                 shift=="RIGHT" ? [pad , 0] :
                 [0, 0]
    ) {
        translate(coord) {
            scale([1, 1, 0.1])
            translate(margin)
            color("black")
            text(
                name,
                1,
                halign="center",
                valign="center"
            );
            color("aqua")
            sphere(0.25, $fn=16);
        }
    }
}
