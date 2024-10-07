extends DirectionalLight3D


#@export var offset = Vector3(0,10,0)
@export var speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = 0
func _process(delta: float) -> void:
	time += delta*speed
	#offset = offset.rotated(Vector3(.5,0.0,0.5),delta*0.1)
	
	look_at(position + Vector3(sin(time),-1,cos(time)))

	#var pos = Vector3(0,10,0)
	
	
	#if offset.y < 1.0:	
	#	offset = Vector3(-offset.x,1,-offset.z)
	#if offset.y < 0.0:	
	#	light_energy = 0.0
	#else:
	#	light_energy = 1.0
	
	#look_at_from_position(offset,Vector3(0,0,0),Vector3.UP)
	#print(position)
	pass
