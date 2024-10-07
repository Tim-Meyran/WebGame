extends GridMap

@export var width = 50
@export var height = 50
@export var threshold = 0.1
@export var noiseTexture:NoiseTexture3D = NoiseTexture3D.new()

@onready var navRegion :NavigationRegion3D = $".."

var treeIds:Array[int] = []

func _init() -> void:
	for id in mesh_library.get_item_list():
		var name = mesh_library.get_item_name(id)
		if name.begins_with("ground_grass"):
			print(name)
			treeIds.append(id)
			
	#noiseTexture.changed.connect(Callable(update))

# Called when the node enters the scene tree for the first time.
func _process(delta: float):
	#update()
	pass
	
func update():
	#print("update")
	for y in range(0,2):
		for x in range(-width/2,width/2):		
				for z in range(-height/2,height/2):		
					var pos = Vector3(x,y,z)
					#get_cell_item(pos)
					var noise = noiseTexture.get_noise()
					#noise.seed = randi()
					var data = noise.get_noise_3d(x,y,z)
					
					var id =0 # treeIds.size() * data
					var mesh = treeIds[id]# mesh_library.get_item_mesh(treeIds[id])
					#randi_range(0,get_meshes().size()-1)
					if data > threshold:
						set_cell_item(pos,mesh)
					else:
						set_cell_item(pos,-1)
	navRegion.bake_navigation_mesh(true)
