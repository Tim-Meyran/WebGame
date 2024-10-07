extends Node3D

@export var GROW_TIME = 60.0
@export var MAX_HEALTH = 60.0

@onready var mesh = $tree_pineSmallA2

var currGrowTime = GROW_TIME
var currHealth = MAX_HEALTH
var growing = false


func _init() -> void:
	updateMesh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if growing:
		grow(delta)

func updateMesh():
	var progress = min(1.0,currGrowTime / GROW_TIME)
	
	if mesh == null:
		return
		
	mesh.scale = Vector3(progress,progress,progress)
	#scale
	
	if progress >= 1.0:
		mesh.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		mesh.process_mode = Node.PROCESS_MODE_DISABLED
			
	#visChild.scale = Vector3(progress,progress,progress)
	
func grow(delta:float):
	currGrowTime += delta
	if currGrowTime > GROW_TIME:
		currHealth = MAX_HEALTH
		growing = false

func hit(force:int) -> int:
	#print("Hit", force,currHealth)
	currHealth -= force
	if currHealth < 0.0:
		currHealth = 0.0
		destroy()
	return currHealth
	
func destroy():
	print("Destry" , self)
	updateMesh()
	#monitorable = false
	remove_from_group("tree")
	
	currGrowTime = 0.0
	growing = true
	queue_free()
	#remove_from_group("tree")
	get_tree().call_group("NavRegions","bake_navigation_mesh",true)
	
