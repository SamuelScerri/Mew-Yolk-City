@tool
extends Node

var player: Node3D
var characters: Array

func _ready() -> void:
	if Engine.is_editor_hint():
		var settings: EditorSettings = EditorInterface.get_editor_settings()
		settings.set_setting("interface/inspector/float_drag_speed", 0)
		settings.set_setting("interface/inspector/default_float_step", 0)
	else:
		player = get_tree().get_first_node_in_group("Player")
		characters = get_tree().get_nodes_in_group("Character")

func _process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set("physics_interpolation", Engine.get_physics_interpolation_fraction())

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if len(characters) == 0:
			characters = get_tree().get_nodes_in_group("Character")
		
		characters.sort_custom(sorter)
		
		for i in range(len(characters)):
			characters[i].animate = i < 16
			characters[i].process = i < 512

func sorter(target1, target2):
	return target1.position.distance_squared_to(player.position) < target2.position.distance_squared_to(player.position)
