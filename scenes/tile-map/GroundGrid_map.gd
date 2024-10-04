extends GridMap

@export var width = 50
@export var height = 50
@export var threshold = 0.1
@export var noiseTexture:NoiseTexture3D = NoiseTexture3D.new()

@onready var navRegion :NavigationRegion3D = $".."

var treeIds:Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for id in mesh_library.get_item_list():
		var name = mesh_library.get_item_name(id)
		if name.begins_with("ground_grass"):
			print(name)
			treeIds.append(id)
			
	for x in range(-width/2,width/2):		
			for y in range(-height/2,height/2):		
				var pos = Vector3(x,0,y)
				#get_cell_item(pos)
				#var noise = noiseTexture.get_noise()
				#noise.seed = randi()
				#var data = noise.get_noise_3d(x,0,y)
				
				#if data > threshold:
				var id =0 # treeIds.size() * data
				var mesh = treeIds[id]# mesh_library.get_item_mesh(treeIds[id])
				#randi_range(0,get_meshes().size()-1)
				set_cell_item(pos,mesh)
					
	navRegion.bake_navigation_mesh(true)
