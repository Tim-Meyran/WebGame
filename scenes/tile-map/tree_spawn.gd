@tool
class_name Spawner
extends Node3D

@export var meshLibrary: MeshLibrary
@export var groupName: String
@export var mesh: String

@export var width = 50
@export var height = 50
@export var treeThreshold = 0.1
@export var noiseTexture:NoiseTexture3D = NoiseTexture3D.new()

@onready var navRegion :NavigationRegion3D = $".."

@export var live = false:
	set(new_setting):
		update()
		live = new_setting

var itemIds = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		update()
	navRegion.bake_navigation_mesh(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update() -> void:
	for child in get_children():
		child.queue_free()
	
	for id in meshLibrary.get_item_list():
		var name = meshLibrary.get_item_name(id)
		if name.begins_with(mesh):
			itemIds.append(id)
	
	var noise = noiseTexture.get_noise()
	#noise.seed = randi()
	
	for x in range(-width/2,width/2):		
			for y in range(-height/2,height/2):		
				var pos = Vector3(x,0,y)
				
				var mesh = -1
				var data = (noise.get_noise_3d(x*10,0,y*10) + 1) / 2.0
				if data > treeThreshold:
					var id = itemIds.size() * data
					mesh = itemIds[id]
					
			
					var arrayMesh:Mesh = meshLibrary.get_item_mesh(mesh)
					var meshInstance3d = MeshInstance3D.new()
					meshInstance3d.mesh = arrayMesh
					var aabb :AABB = meshInstance3d.mesh.get_aabb()
					
					meshInstance3d.create_convex_collision(true,true)
					
					var supp = aabb.get_support(Vector3.DOWN) 
					var center = aabb.get_center()
					meshInstance3d.position = Vector3(x-center.x,supp.y,y-center.z)
					
					meshInstance3d.add_to_group(groupName)
					add_child(meshInstance3d)
				#set_cell_item(pos,mesh)
				
	#navRegion.bake_navigation_mesh(true)
