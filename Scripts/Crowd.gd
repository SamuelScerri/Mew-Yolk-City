extends MultiMeshInstance3D

func _ready():
	multimesh.instance_count = 4096
	
	for i in range(512):
		global_position.x = randf_range(0, 25)
		multimesh.set_instance_transform(i, global_transform)
