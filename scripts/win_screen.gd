extends Node

signal level_complete
signal reset_level

func _ready():
	yield(get_tree().create_timer(5.0), "timeout")
	emit_signal("level_complete")
	return

