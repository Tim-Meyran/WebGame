extends GridMap

@export var width = 50
@export var height = 50
@export var treeThreshold = 0.1
@export var grassThreshold = 0.00
@export var noiseTexture:NoiseTexture3D = NoiseTexture3D.new()

@onready var navRegion :NavigationRegion3D = $".."

var treeIds:Array[int] = []
var grassIds:Array[int] = []

func _ready() -> void:
	for id in mesh_library.get_item_list():
		var name = mesh_library.get_item_name(id)
		if name.begins_with("tree"):
			treeIds.append(id)
		elif name.begins_with("grass") or name.begins_with("flower"):
			grassIds.append(id)	
			
	for x in range(-width/2,width/2):		
			for y in range(-height/2,height/2):		
				var pos = Vector3(x,0,y)
				
				var noise = noiseTexture.get_noise()
				noise.seed = randi()
				
				var mesh = -1
				var data = noise.get_noise_3d(x*10,0,y*10)
				if data > grassThreshold:
					var id = grassIds.size() * data
					mesh = grassIds[id]
					
				data = noise.get_noise_3d(x,0,y)
				if data > treeThreshold:
					var id = treeIds.size() * data
					mesh = treeIds[id]
					var itemMesh:Mesh = mesh_library.get_item_mesh(mesh)
					
				set_cell_item(pos,mesh)
				
	navRegion.bake_navigation_mesh(true)
