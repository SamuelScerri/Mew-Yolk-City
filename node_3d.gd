extends Node

var character: PackedScene = preload("res://Nodes/Crowd.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(2048):
		var new_character = character.instantiate()

		add_child(new_character)
		new_character.global_position.x = randf_range(-64, 64)
		new_character.global_position.z = randf_range(-64, 64)
