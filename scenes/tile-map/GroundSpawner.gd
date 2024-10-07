@tool
extends Node3D

@export var scene: PackedScene
@export var groupName: String

@export var width = 50
@export var height = 50
@export var treeThreshold = 0.5
@export var noiseTexture:NoiseTexture3D = NoiseTexture3D.new()

@onready var navRegion :NavigationRegion3D = $".."

@export var live = false:
	set(new_setting):
		update()
		live = new_setting

func _ready() -> void:
	if Engine.is_editor_hint():
		update()
	navRegion.bake_navigation_mesh(true)

func update() -> void:
	for child in get_children():
		child.queue_free()
	
	var noise = noiseTexture.get_noise()
	for x in range(-width/2,width/2):
		for z in range(-height/2,height/2):		
			var isBlockAbove = false
			for y in range(0,1):
				var pos = Vector3(x,y,z)
				var mesh = -1
				var data = (noise.get_noise_3d(x,y,z) + 1) / 2.0
				if isBlockAbove or data > treeThreshold:
					isBlockAbove = true
					var instance = scene.instantiate()
					#instance.create_convex_collision(true,true)
					instance.position = Vector3(x,-y/2.0,z)
					instance.add_to_group(groupName)
					add_child(instance)
