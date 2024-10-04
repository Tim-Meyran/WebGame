extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

@export var movement_speed: float = 4.0
@onready var animationTree:AnimationTree = $"AuxScene/AnimationTree"
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
	set_movement_target(Vector3(10,0,0))
	
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.timeout.connect(Callable(setTreeTarget))
	timer.start()
	
	
func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func sort_closest(a:Node3D, b:Node3D) -> bool:
	return b.global_position.distance_to(global_position) > a.global_position.distance_to(global_position)

var tree:Node3D
func setTreeTarget():
	if tree != null:
		return
		
	var trees:Array[Node] = get_tree().get_nodes_in_group("tree")
	
	var minDist = 99999.0
	for t:Node3D in trees:
		var dist = t.global_position.distance_squared_to(global_position)
		if dist < minDist:
			minDist = dist
			tree = t
			
	if tree:
		print("Set target" , tree)
		set_movement_target(tree.global_position)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z
	#print("")
	#print(velocity)
	move_and_slide()
	#print(velocity)
	
func _process(delta: float):
	#if not navigation_agent.is_target_reachable():
	#	tree = null
		
	var distance = navigation_agent.distance_to_target()
	if tree and (navigation_agent.is_target_reached() or distance < 1.5 or navigation_agent.is_target_reachable()):
		print("reached")
		tree.remove_from_group("tree")
		tree.queue_free()
		set_movement_target(position)
		tree = null
	
	
	if velocity.length() > 0.01:
		rotation.y = lerp_angle(rotation.y,atan2(-velocity.x, -velocity.z),15*delta)
		
	var speed = Vector2(velocity.x,velocity.z).length()
	#print(speed)
	if animationTree:
		var oldAnimSpeed = animationTree.get("parameters/BlendSpace1D/blend_position")
		animationTree.set("parameters/BlendSpace1D/blend_position",lerp(oldAnimSpeed, speed/4.0,delta*10))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and global_position.y > 0.0:
		velocity += get_gravity() * delta
		
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
