# BlenderCAD file format prototype

## Introduction

This is a proof of concept for a new savefile format with extension `.bcad`, this format is a textual (`JSON`) representation of objects within a Blender file, with the purpose of allowing better CAD collaboration using GIT (in comparison with binary `.blend` files).

## How to install the plugin
In Blender, `Preferences > Add-ons > Install`, and select `bcad.py`.

Then `.bcad` files can be imported or exported in Blender, with the same interface than any other supported format (`File > Import > BCAD` or in the search bar).

## JSON structure
The structure in the `.bcad` file follows as much as possible the structure and naming exposed by Blender Python API.

## What is (or will be) stored
- Objects.
- Modifiers.
- Vertex groups.
- [Blender CAD Sketcher](https://www.cadsketcher.com) sketches ???

## What is NOT stored
- Textures.
- Materials.
- Animations.
- Scenes.
- Workspaces.
- Brushes.
- Any other Blender stuff unrelated to CAD design.

## How are meshes stored
If the mesh has a single face, and all vertex are coplanar, it analyses the geometry and store it as a primitive of the type:
- Square.
- Rectangle.
- Circle / Regular polygon. (TODO)
- Polygon with relative dimensions from point to point. (TODO).
- Sketches and constrain data from Blender CAD Sketcher. (TO INVESTIGATE).

Otherwise geometry data is stored with Blender native structure (a big list of vertices and faces).

## Challenges
- Modifiers that reference objects (eg `Boolean` modifier), these references will have to be encoded in the JSON file so they can be recreated without name collisions.
- Assembly using Blender `File link` won't work anymore, so this format should also support cross-file references.
- Saving geometry nodes modifiers?
