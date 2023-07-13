# Alpakka Controller: OpenSCAD Parametric Design

This repository contains the [OpenSCAD] source code that generates printable parts
for the [Alpakka] controller parametric modeling abstractions
(sketches, constrains, extrusion, loft, fillet, etc).

## Dependencies

This project requires you to have the libraries installed on your system.
To install a library, download it's source code and place it in
an appropriately named directory in your system's OpenSCAD libraries directory.

You can locate your system libraries directory based on your operating system
as follows:
- Windows: `My Documents\OpenSCAD\libraries\`
- Linux: `$HOME/.local/share/OpenSCAD/libraries/`
- Mac OS X: `$HOME/Documents/OpenSCAD/libraries/`

**Libraries:**
- [BOSL2] - An OpenSCAD library of shapes, masks,
  and manipulators to make working with OpenSCAD easier
  - extract into `<SYSTEM_LIBRARIES>/BOSL2`

## Project structure

- [`constants.scad`](constants.scad) defines constants used for parametric design
- [`parameters.scad`](parameters.scad) defines most of the important variables
  (parameters) used in the design in order to provide configurability
- [`common_references.scad`](common.scad) contains dimensions used
  across multiple files

## Useful resources

- [OpenSCAD Documentation]
- [OpenSCAD Cheet Sheet] - reference of OpenSCAD features
- [BOSL2 Documentation]
- [BOSL2 Cheet Sheet] - reference of BOSL2 features

[OpenSCAD]: https://openscad.org/
[Alpakka]: https://inputlabs.io/alpakka
[BOSL2]: https://github.com/BelfrySCAD/BOSL2

[OpenSCAD Documentation]: http://openscad.org/documentation.html
[OpenSCAD Cheet Sheet]: http://openscad.org/cheatsheet/
[BOSL2 Documentation]: https://github.com/BelfrySCAD/BOSL2/wiki
[BOSL2 Cheet Sheet]: https://github.com/BelfrySCAD/BOSL2/wiki/CheatSheet
