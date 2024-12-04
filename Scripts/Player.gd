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
	bob = sin(Time.get_ticks_msec() * .015625) * bob_strength * .015625
	camera.global_position = previous_position.lerp(global_position, Engine.get_physics_interpolation_fraction()) + Vector3.UP * (1.5 + bob)
	var look_velocity = Input.get_vector("look_left", "look_right", "look_up", "look_down") * 2
	rotation_velocity = rotation_velocity.lerp(look_velocity, 8 * delta)
	camera.global_rotation_degrees -= Vector3(rotation_velocity.y, rotation_velocity.x, 0)
	mouse_speed = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, camera.global_rotation.y)
	
	previous_position = global_position
	
	bob_strength = lerpf(0, 1, velocity.length() / SPEED)
	
	velocity += direction * SPEED
	move_and_slide()
	velocity *= .75
