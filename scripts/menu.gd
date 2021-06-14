extends Node

var pull_enabled

signal select_level

func play_pressed():
	$ButtonAudio.play()
	yield($ButtonAudio, "finished")
	emit_signal("select_level", 1)
	return
