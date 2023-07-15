import json
import pprint
import re
from types import SimpleNamespace
import bpy
from bpy.types import Operator
from bpy_extras.io_utils import ImportHelper, ExportHelper

# Metadata.
bl_info = {
    "name": "BCAD format",
    "author": "Input Labs Oy.",
    "blender": (3, 6, 0),
    "category": "Import-Export",
}

# Classes.
class BlenderObject:
    def __init__(self, entity):
        self.entity = entity

    def export(self):
        data = SimpleNamespace()
        data.type = self.entity.type
        if data.type != 'MESH':
            return {'type': data.type}
        data.name = self.entity.name
        data.location = BlenderVector(self.entity.location).export()
        data.scale = BlenderVector(self.entity.scale).export()
        data.rotation_mode = self.entity.rotation_mode
        data.vertex_groups = 'TODO' # str(self.entity.vertex_groups)
        data.hide_render = self.entity.hide_render
        data.hide_select = self.entity.hide_select
        data.hide_viewport = self.entity.hide_viewport
        data.modifiers = []
        data.data = BlenderMesh(self.entity.data).export()
        for modifier in self.entity.modifiers:
            if modifier.type == 'SOLIDIFY':
                modifier_data = BlenderSolidify(modifier).export()
                data.modifiers.append(modifier_data)
            if modifier.type == 'BEVEL':
                modifier_data = BlenderBevel(modifier).export()
                data.modifiers.append(modifier_data)
        return data.__dict__

    @staticmethod
    def from_json(obj_json):
        mesh = BlenderMesh.from_json(obj_json['data'])
        obj = bpy.data.objects.new(name=obj_json['name'], object_data=mesh)
        view_layer = bpy.context.view_layer
        view_layer.active_layer_collection.collection.objects.link(obj)
        obj.select_set(True)
        view_layer.objects.active = obj
        # Generate modifiers
        for modifier_json in obj_json['modifiers']:
            tpe = modifier_json['type']
            name = modifier_json['name']
            modifier = obj.modifiers.new(name, tpe)
            if tpe == 'SOLIDIFY': modifier_blender = BlenderSolidify(modifier)
            if tpe == 'BEVEL': modifier_blender = BlenderBevel(modifier)
            modifier_blender.update(modifier_json)
        return obj


class BlenderMesh:
    def __init__(self, entity):
        self.entity = entity

    def export(self):
        data = SimpleNamespace()
        data.name = self.entity.name
        data.vertices = []
        for vertex in self.entity.vertices:
            v = SimpleNamespace()
            v.co = BlenderVector(vertex.co).export()
            if vertex.bevel_weight:
                v.bw = vertex.bevel_weight
            data.vertices.append(v.__dict__)
        data.polygons = []
        for polygon in self.entity.polygons:
            data.polygons.append([v for v in polygon.vertices])
        return data.__dict__

    @staticmethod
    def from_json(mesh_json):
        mesh = bpy.data.meshes.new(mesh_json['name'])
        vertices = [v['co'] for v in mesh_json['vertices']]
        polygons = [p for p in mesh_json['polygons']]
        mesh.from_pydata(vertices, [], polygons)
        return mesh


class BlenderSolidify:
    def __init__(self, entity):
        self.entity = entity

    def update(self, modifier_json):
        self.entity.thickness = modifier_json['thickness']
        self.entity.offset = modifier_json['offset']

    def export(self):
        data = SimpleNamespace()
        data.type = self.entity.type
        data.name = self.entity.name
        data.thickness = round(self.entity.thickness, ndigits=5)
        data.offset = self.entity.offset
        return data.__dict__


class BlenderBevel:
    def __init__(self, entity):
        self.entity = entity

    def update(self, modifier_json):
        self.entity.width = modifier_json['width']
        self.entity.segments = modifier_json['segments']

    def export(self):
        data = SimpleNamespace()
        data.type = self.entity.type
        data.name = self.entity.name
        data.width = round(self.entity.width, ndigits=5)
        data.segments = self.entity.segments
        return data.__dict__

class BlenderVector:
    def __init__(self, vector):
        self.vector = vector

    def export(self):
        return [
            round(self.vector.x, ndigits=5),
            round(self.vector.y, ndigits=5),
            round(self.vector.z, ndigits=5)
        ]


class ExportBCAD(Operator, ExportHelper):
    """Export to BCAD format"""
    bl_idname = "export.bcad"
    bl_label = "Export BCAD"
    filename_ext = ".bcad"

    def execute(self, context):
        bcad = SimpleNamespace()
        bcad.format_version = '0.0.1'
        scene = SimpleNamespace()
        scene.unit_system = 'metric' # TODO
        scene.unit_scale = 0.001 # TODO
        scene.unit_name = 'Millimeter' # TODO
        bcad.scene = scene.__dict__
        bcad.objects = []
        # self.report({'INFO'}, str(data))
        for obj in bpy.data.objects:
            obj = BlenderObject(obj)
            bcad.objects.append(obj.export())
        data = json.dumps(bcad.__dict__, indent='  ')
        data = self.prettify(data)
        f = open(self.filepath, 'w', encoding='utf8')
        f.write(data)
        return {'FINISHED'}

    def prettify(self, data):
        def repl(match):
            string = match.group(1)
            joined = re.sub('\n\s*', ' ', string, flags=re.DOTALL)
            if len(joined) < 100:
                return joined
            else:
                return string
        data = re.sub('(\[[^\[]+?\])', repl, data, flags=re.DOTALL)
        data = re.sub('(\{[^\{]+?\})', repl, data, flags=re.DOTALL)
        return data


class ImportBCAD(Operator, ImportHelper):
    """Import from BCAD format"""
    bl_idname = "import.bcad"
    bl_label = "Import BCAD"
    filename_ext = ".bcad"

    def execute(self, context):
        f = open(self.filepath, 'r', encoding='utf8')
        data = json.loads(f.read())
        for obj_json in data['objects']:
            BlenderObject.from_json(obj_json)
        # self.report({'INFO'}, str(data))
        return {'FINISHED'}


# Menus.
def menu_export(self, context):
    self.layout.operator(ExportBCAD.bl_idname, text="BCAD (.bcad)")

def menu_import(self, context):
    self.layout.operator(ImportBCAD.bl_idname, text="BCAD (.bcad)")


# Register.
def register():
    bpy.utils.register_class(ExportBCAD)
    bpy.utils.register_class(ImportBCAD)
    bpy.types.TOPBAR_MT_file_export.append(menu_export)
    bpy.types.TOPBAR_MT_file_import.append(menu_import)

def unregister():
    bpy.utils.unregister_class(ExportBCAD)
    bpy.utils.unregister_class(ImportBCAD)
    bpy.types.TOPBAR_MT_file_export.remove(menu_export)
    bpy.types.TOPBAR_MT_file_import.remove(menu_import)


if __name__ == "__main__":
    register()
