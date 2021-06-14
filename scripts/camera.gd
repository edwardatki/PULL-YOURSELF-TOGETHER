extends Node2D

func _process(delta):
	var target_pos = Vector2.ZERO
	for n in get_tree().get_nodes_in_group("camera_target"):
		target_pos += n.global_position
	target_pos /= get_tree().get_nodes_in_group("camera_target").size()
	
	var diff = target_pos - self.global_position
	if diff.length() > 32.0:
		self.global_position = target_pos
	else:
		self.global_position = lerp(self.global_position, target_pos, delta * 10.0)
	
	pass
