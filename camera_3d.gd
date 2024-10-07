extends Camera3D

@export var height = 5
@export var distance = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rotate_y(deg_to_rad(-45))
	#position = Vector3(distance,height,0)
	
	var pos = Vector3(distance,height,0).rotated(Vector3.UP ,deg_to_rad(-45))
	
	look_at_from_position(pos,Vector3(0,0,0))
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
