extends MeshInstance3D

var shake: bool

func _process(delta: float) -> void:
	if shake:
		$"../../../../Camera".h_offset = randf_range(-.125, .125)
		$"../../../../Camera".v_offset = randf_range(-.125, .125)
		#$"../../Camera".h_offset = $"../../../../Camera".h_offset * .0625
		#$"../../Camera".v_offset = $"../../../../Camera".v_offset * .0625

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and !$Player.is_playing():
		$Timer.start()
		shake = true
		$Player.play("Shoot")
		$Muzzle.restart()


func _on_timer_timeout() -> void:
	shake = false
	$"../../../../Camera".h_offset = 0
	$"../../../../Camera".v_offset = 0
	#$"../../Camera".h_offset = 0
	#$"../../Camera".v_offset = 0
