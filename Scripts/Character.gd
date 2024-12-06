extends AnimatableBody3D

const simulator = preload("res://Globals/Nodes/Bone Simulator.tscn")

var player: Node3D
var animate: bool:
	set(value):
		$Root/Animator.active = value
		$Root/Tree.active = value

const words = [
	"Hey!",
	"Easy on the gas there buddy",
	"Hey I'm walkin' here!",
	"What are you stupid?",
	"Watch it moron",
	"Careful!",
	"GET OUT",
	"Hello everybody my name is EURGH",
	"What the gubma?",
	"What the sigma?",
	"IT'S THE RANGAH"
]

const soup = [
	"I think I might have shat myself",
	"Whiskey and cigars",
	"...",
	"I wonder what Gub Gub is doing",
	"What a wonderful day!",
	"The sun is shining!",
	"This is indeed a crowd simulation",
	"Marketplier",
	"The Industrial Revolution and its consequences have been a disaster for the human race",
	"Ermm... what the sigma",
	"GUYS, ARE YA BLIND",
	"I'm the real Gub Gub",
	"I'm too old for this horse shit",
	"DID I EVER TELL YA ABOUT THE TIME ME AND MY BUDDY KEITH-"
]

var process: bool:
	set(value):
		if visible != value:
			visible = value
		
			if !value:
				$Root/Skeleton3D/characterLargeMale.transparency = 1
				process_mode = PROCESS_MODE_DISABLED
			else:
				create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).tween_property($Root/Skeleton3D/characterLargeMale, "transparency", 0, .5)
				process_mode = PROCESS_MODE_INHERIT
		
		process = value
	get:
		return process

var is_visible: bool:
	get:
		return $Enabler.is_on_screen()

@onready var random_destination: Vector3 = Vector3(randf_range(-64, 64), 0, randf_range(-64, 64))

func reset_speaker_timer():
	$Speak.wait_time = randf_range(0, 15)
	$Speak.start()

func _ready():
	$Root/Skeleton3D/characterLargeMale.set_instance_shader_parameter("interpolate", true)
	player = get_tree().get_first_node_in_group("Player")
	$Root/Skeleton3D/characterLargeMale.set_instance_shader_parameter("color", Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1)))
	
	process = false
	reset_speaker_timer()


func _physics_process(delta: float) -> void:
	var next_path_position: Vector3 = $Navigator.get_next_path_position()

	$Navigator.set_velocity($Navigator.velocity.lerp(global_position.direction_to(next_path_position) * $Navigator.max_speed, .125))
	
	#var headRotation : Transform3D = $Root/Skeleton3D.get_bone_global_pose_no_override(head)
	#headRotation = headRotation.looking_at(player.global_position, Vector3(0, 1, 0), false)
	#$Root/Skeleton3D.set_bone_global_pose_override(head, headRotation, 1.0, true)
	
	if !$Timer.time_left > 0:
		if global_position.distance_squared_to(player.global_position) < 3:
			$Speaker.play()
			say(words.pick_random())

func _on_navigator_velocity_computed(safe_velocity: Vector3) -> void:
	$Navigator.set_target_position(global_position + safe_velocity)
	var next_path_position: Vector3 = $Navigator.get_next_path_position()
	$Navigator.set_target_position(random_destination)
	
	var previous_rotation = global_rotation.y
	var previous_position = global_position
	
	global_rotation.y = lerp_angle(global_rotation.y, atan2(safe_velocity.x, safe_velocity.z), .125)
	global_position = next_path_position
	
	if $Root/Tree.active:
		$Root/Tree.set("parameters/blend_position", safe_velocity.length() / $Navigator.max_speed)
	
	$Root/Skeleton3D/characterLargeMale.set_instance_shader_parameter("current_position", global_position - previous_position)
	$Root/Skeleton3D/characterLargeMale.set_instance_shader_parameter("current_rotation", global_rotation.y - previous_rotation)
	

func kill():
	$Root/Skeleton3D/characterLargeMale.set_instance_shader_parameter("interpolate", false)
	var new_bone_simulator = simulator.instantiate()
	$Root/Skeleton3D.add_child(new_bone_simulator)
	$Collider.disabled = true
	new_bone_simulator.physical_bones_start_simulation()
	$Root.top_level = true
	
	#$"Root/Skeleton3D/Bone Simulator".physical_bones_start_simulation()
	

func _on_enabler_screen_exited() -> void:
	animate = false

func say(text: String) -> void:
	$Label.text = text
	$Label.visible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	$Label.text = ""
	$Label.visible = false
	$Speaker.stop()
	reset_speaker_timer()

func _on_speak_timeout() -> void:
	if !$Timer.time_left > 0:
		say(soup.pick_random())
