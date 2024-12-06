extends MeshInstance3D

var shake: bool

func _process(delta: float) -> void:
	if shake:
		$"../../../../../Camera".h_offset = randf_range(-.125, .125)
		$"../../../../../Camera".v_offset = randf_range(-.125, .125)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and !$Player.is_playing():
		$Timer.start()
		shake = true
		$Player.play("Shoot")
		#Input.start_joy_vibration(0, 0, 1, 1)
		$Muzzle.restart() 
		$Muzzle/Muzzle.visible = true
		if $"../../Caster".is_colliding():
			$"../../Caster".get_collider().hit()
			#print($"../../Caster".get_collider())

func _on_timer_timeout() -> void:
	shake = false
	$"../../../../../Camera".h_offset = 0
	$"../../../../../Camera".v_offset = 0
	$Muzzle/Muzzle.visible = false
