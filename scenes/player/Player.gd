extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5

@onready var cameraPivot = $"../CameraPivot"
@onready var animationTree:AnimationTree = $"AuxScene/AnimationTree"
@onready var hitArea: Area3D = $HitArea

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta: float) -> void:
	#print(position)
	
	# Handle jump.
	if Input.is_action_just_pressed("HIT") and is_on_floor():
		print("Hitting 1")
		
		var bodies = hitArea.get_overlapping_areas()
		for body in bodies:
			if body.get_parent() != null and body.has_method("hit"):
				print("Hitting ", body)
				body.hit(40)
			
	
	# Add the gravity.
	if not is_on_floor() and global_position.y > 0.0:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("PLAYER_JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("PLAYER_LEFT", "PLAYER_RIGHT", "PLAYER_FORWARD", "PLAYER_BACK")
	input_dir = input_dir.rotated(deg_to_rad(-45))
	var direction := Vector3(input_dir.x, 0, input_dir.y)
	
	if direction.length() > 0.1:
		rotation.y = lerp_angle(rotation.y,atan2(-direction.x, -direction.z),15*delta)
	
	#var newDir = Basis.looking_at(direction,Vector3.UP).get_euler()
	#rotation = lerp(rotation,newDir,delta*10)
	
	#look_at() 
	
	var currSpeed = SPEED
	if Input.is_action_pressed("PLAYER_SPRINT") and is_on_floor():
		currSpeed *= 2.0
		
	if direction:
		velocity.x = direction.x * currSpeed
		velocity.z = direction.z * currSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currSpeed)
		velocity.z = move_toward(velocity.z, 0, currSpeed)	
	#Water
	if global_position.y < 0.0:
		velocity.y *= 0.99
		velocity.y += delta * abs(global_position.y)

	move_and_slide()
	
	cameraPivot.position = cameraPivot.position.lerp(position,delta*10)
	#cameraPivot.quaternion = cameraPivot.quaternion.slerp(quaternion,delta*20)
	
	var speed = Vector2(velocity.x,velocity.z).length()
	#print(speed)
	if animationTree:
		var oldAnimSpeed = animationTree.get("parameters/BlendSpace1D/blend_position")
		animationTree.set("parameters/BlendSpace1D/blend_position",lerp(oldAnimSpeed, speed / (2*SPEED),delta*10))

	#get_tree().call_group("NPC", "set_movement_target",global_position)
#func _unhandled_input(event):
#	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		if event is InputEventMouseMotion:
#			rotate_y(-event.relative.x  /1000)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseButton and not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
