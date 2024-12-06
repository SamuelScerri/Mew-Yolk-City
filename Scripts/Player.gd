extends CharacterBody3D

const SPEED = 1.5

var rotation_velocity: Vector2
var rotation_x: float
var mouse_speed: Vector2
var previous_position: Vector3

var bob: float
var bob_strength: float

@onready var camera: Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera = get_viewport().get_camera_3d()
	camera.top_level = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_speed = event.relative * .0073125

func _process(delta: float) -> void:
	var thing = sin(Time.get_ticks_msec() * .015625)
	
	bob = thing * bob_strength * .015625

	if thing < deg_to_rad(-45):
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if input_dir.length() > 0:
			Input.start_joy_vibration(0, .25, 0, bob_strength * .06215)
	
	camera.global_position = previous_position.lerp(global_position, Engine.get_physics_interpolation_fraction()) + Vector3.UP * (2.5 + bob)
	
	var look_velocity = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	rotation_velocity = rotation_velocity.lerp(look_velocity * 2, 8 * delta)
	camera.global_rotation_degrees -= Vector3(rotation_velocity.y, rotation_velocity.x, 0)
	camera.global_rotation_degrees.x = clampf(camera.global_rotation_degrees.x, -45, 45)
	
	$Container/Viewport.offset = bob * .0625
	$Container/Viewport.rotation_velocity = look_velocity

	mouse_speed = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, camera.global_rotation.y)
	
	previous_position = global_position
	
	bob_strength = lerpf(0, 1, velocity.length() / SPEED)
	
	$Container/Viewport.linear_velocity = Vector3(input_dir.x, 0, input_dir.y)
	
	velocity += direction * SPEED
	move_and_slide()
	velocity *= .75
