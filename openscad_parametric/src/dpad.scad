include <../lib/cad.scad>
include <../lib/annotate.scad>

// Sketch 1.
a = line_horizontal(origin, 5);
b = line_vertical(a, 7);
c = line(b, [undef, 5], constrain_x=origin.x);
s1 = sketch(mirrorx([a, b, c]));

// Sketch 2.
inset = 1;
d = line_horizontal(origin, a.x-inset);
e = line_vertical(d, undef, constrain_y=b.y);
f = line(e, [undef, undef], constrain_x=origin.x, constrain_y=c.y-inset);
s2 = sketch(fillet(r=1, mirrorx([d, e, f])));

// Heights.
// TODO: These could be workplanes?
h1 = 2.5;
h2 = 2;
h3 = 14;

// Bodies.
color("red")            extrude(s1, h1);
color("gold") up(h1)    loft(s1, s2, h2);
color("lime") up(h1+h2) extrude(s2, h3, fillet_top=0.5, steps=1);

// Annotations.
annotate("A", a);
annotate("B", b);
annotate("C", c);
up(h1+h2) {
    annotate("D", d);
    annotate("E", e);
    annotate("F", f);
}
