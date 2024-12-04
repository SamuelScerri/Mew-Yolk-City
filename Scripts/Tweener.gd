extends Node3D

@onready var offset: Vector3 = position
@onready var parent: Node3D = get_parent()

func _ready() -> void:
	top_level = true

func _physics_process(delta: float) -> void:
	create_tween().tween_property(self, "global_position", parent.global_position + offset, delta)
	create_tween().tween_property(self, "quaternion", parent.quaternion, delta)
