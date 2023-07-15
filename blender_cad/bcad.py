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

def debug(message, title="Info", icon='INFO'):
    def draw(self, context):
        self.layout.label(text=message)
    bpy.context.window_manager.popup_menu(draw, title=title, icon=icon)

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
        data.rotation_euler = BlenderVector(self.entity.rotation_euler).export()
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
            modifier_blender = obj.modifiers.new(name, tpe)
            if tpe == 'SOLIDIFY': modifier = BlenderSolidify(modifier_blender)
            if tpe == 'BEVEL': modifier = BlenderBevel(modifier_blender)
            modifier.update(modifier_json)
        return obj


class BlenderMesh:
    def __init__(self, entity):
        self.entity = entity

    def export(self):
        data = SimpleNamespace()
        data.name = self.entity.name
        if self.is_parametrizable():
            # TODO: Remove extra dimension.
            if self.is_rectangle():
                vertices = [v.co for v in self.entity.vertices]
                normal = self.get_normal()
                data.sketch = Rectangle(vertices, normal).export()
        else:
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

    def is_parametrizable(self):
        faces = self.entity.polygons
        if len(faces) != 1: return False
        # TODO: Check if all vertices are on the same plane.
        return True

    def is_rectangle(self):
        vertices = [v.co for v in self.entity.vertices]
        if len(vertices) != 4: return False
        if len(set([v.x for v in vertices])) > 2: return False
        if len(set([v.y for v in vertices])) > 2: return False
        if len(set([v.z for v in vertices])) > 2: return False
        return True

    def get_normal(self):
        vertices = [v.co for v in self.entity.vertices]
        if len(set([v.x for v in vertices])) == 1: return [1, 0, 0]
        if len(set([v.y for v in vertices])) == 1: return [0, 1, 0]
        if len(set([v.z for v in vertices])) == 1: return [0, 0, 1]
        # TODO: Support flipped faces.
        raise Exception('Could not determine normal')

    @staticmethod
    def from_json(mesh_json):
        mesh = bpy.data.meshes.new(mesh_json['name'])
        if mesh_json['sketch']:
            sketch = mesh_json['sketch']
            if sketch['type'] == 'RECTANGLE':
                center = sketch['center']
                width = sketch['width']
                height = sketch['height']
                origin = [
                    center[0] - (width/2),
                    center[1] - (height/2),
                ]
                vertices = [
                    [origin[0],       origin[1],        0],
                    [origin[0]+width, origin[1],        0],
                    [origin[0]+width, origin[1]+height, 0],
                    [origin[0],       origin[1]+height, 0],
                ]
                polygons = [[0, 1, 2, 3]]
                # debug(f'{center} / {width} / {height} / {origin}')
        else:
            vertices = [v['co'] for v in mesh_json['vertices']]
            polygons = [p for p in mesh_json['polygons']]
        mesh.from_pydata(vertices, [], polygons)
        return mesh

class Rectangle:
    def __init__(self, vertices, normal):
        self.vertices = vertices
        self.normal = normal

    def export(self):
        data = SimpleNamespace()
        data.type = 'RECTANGLE'
        data.normal = self.normal
        all_x = [v.x for v in self.vertices]
        all_y = [v.y for v in self.vertices]
        data.center = [
            min(all_x) + ((max(all_x) - min(all_x)) / 2),
            min(all_y) + ((max(all_y) - min(all_y)) / 2),
        ]
        data.width = max(all_x) - min(all_x)
        data.height = max(all_y) - min(all_y)
        return data.__dict__

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
        scene.unit = 'Millimeter' # TODO
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
            if len(joined) < 80:
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
