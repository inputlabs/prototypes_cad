# Blender CAD prototype

## Introduction

This is a proof of concept for a new savefile format with extension `.bcad`, this format is a `JSON` representation of some properties of a Blender file, with the purpose of allowing better collaboration using GIT.

It can be imported or exported in Blender, with the same interface than any other supported format (`File > Import > BCAD` or in the search bar).

## JSON structure
The structure in the `.bcad` file follows as much as possible the structure and naming exposed by Blender Python API.

## How to install the plugin
In Blender, `Preferences > Add-ons > Install`, and select `bcad.py`.

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
If the mesh has a single face, and all vertex are coplanar, it saves the geometry as a primitive of the type:
- Square.
- Rectangle.
- Circle / Regular polygon. (TODO)
- Polygon with relative dimensions from point to point (TODO).
- In theory sketch+constrain data from Blender CAD Sketcher could be also saved here.

Otherwise geometry data is stored with Blender native structure (a big list of vertices and faces).

## Challenges
- Modifiers that reference objects (eg `Boolean` modifier), these references will have to be encoded in the JSON file so they can be recreated.
- Assembly using Blender `File link` won't work anymore, so this format should also support cross-file references.
