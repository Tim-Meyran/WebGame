extends Camera3D

@onready var pivot := $".."
@onready var centerNode = $"../Center"


# mouse properties
var invert_y = false
var invert_x = false
var mouse_control = false
var mouse_sensitivity = 0.005

var last_position = Vector2()
var velocity = Vector2()
var speed = 0.005

var distance = 20

var a = 0
var b = 0

var pressed := false

func _process(delta):
	if Input.is_key_pressed(KEY_W):
		centerNode.position.z += delta
	if Input.is_key_pressed(KEY_D):
		centerNode.position.x += delta
	if Input.is_key_pressed(KEY_A):
		centerNode.position.x -= delta
	if Input.is_key_pressed(KEY_W):
		centerNode.position.z -= delta
	

func _input(event):
	if event is InputEventMouseButton:
		pressed = event.pressed
		if Input.is_key_pressed(KEY_SHIFT):
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				centerNode.position.y += 1
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				centerNode.position.y -= 1
		elif event.pressed:
			last_position = event.position
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				distance -=1
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				distance +=1
		#else:
			#velocity = Vector2.ZERO
	elif event is InputEventMouseMotion:
		velocity = (event.position - last_position) * speed
		last_position = event.position
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			a += -velocity.x
			b += velocity.y 
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			var localCenter = centerNode.position * transform
			localCenter += Vector3(-velocity.x,velocity.y,0) * distance * 0.1
			
			centerNode.position = localCenter * transform.inverse()
			#print(center)
			
		

	var x = (cos(b) * sin(a)) *distance
	var y = sin(b)*distance
	var z = (cos(b) * cos(a))*distance
			
	look_at_from_position(Vector3(x,y,z) + centerNode.position,centerNode.position,Vector3.UP)
	
	#if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
	#	var obj = get_object_under_mouse()
	#	if obj:
	#		pass
			#print(obj)
		

		
func get_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var ray_from = camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + camera.project_ray_normal(mouse_pos) * 50.0
	var space_state = get_world_3d().direct_space_state
	var selection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_from, ray_to))
	return selection
		
