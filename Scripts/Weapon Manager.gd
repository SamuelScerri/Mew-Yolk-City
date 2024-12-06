extends SubViewport

var offset: float

var linear_velocity: Vector3
var rotation_velocity: Vector2

var weapon_offset: Vector3
var weapon_rotation: Vector3

@onready var weapon_original_offset = $Player/Weapon.position

func _process(delta: float) -> void:
	$Player.global_transform = $"../../Camera".global_transform

func _physics_process(delta: float) -> void:
	weapon_offset = weapon_offset.lerp(-linear_velocity * .0625 * .5, .0625)
	
	weapon_rotation.x = lerp_angle($Player/Weapon.rotation.x, -rotation_velocity.y * .125, .25) + offset * 8
	weapon_rotation.y = lerp_angle($Player/Weapon.rotation.y, -rotation_velocity.x * .125, .25)
	weapon_rotation.z = lerp_angle($Player/Weapon.rotation.z, (-rotation_velocity.x - linear_velocity.x) * .0625, .25) - offset * 2
	
	create_tween().tween_property($Player/Weapon, "rotation", weapon_rotation, delta)
	create_tween().tween_property($Player/Weapon, "position", weapon_original_offset + weapon_offset + Vector3.UP * offset, delta)
