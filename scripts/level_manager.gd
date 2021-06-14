extends Node2D

var goals = []
var spikes = []
var won = false

export(bool) var pull_enabled = true

signal level_complete
signal reset_level

func _ready():
	for c in self.get_children():
		if c.is_in_group("goal"):
			goals.append(c)
		if c.is_in_group("spikes"):
			spikes.append(c)
	
	return

func _process(_delta):
	var win = true
	for g in goals:
		var complete = false
		for b in g.get_overlapping_bodies():
			if b.is_in_group("player"):
				complete = true
		if !complete:
			win = false
	
	for s in spikes:
		for b in s.get_overlapping_bodies():
			if b.is_in_group("player"):
				emit_signal("reset_level")
	
	if win and !won:
		won = true
		$WinAudio.play()
		yield($WinAudio, "finished")
		emit_signal("level_complete")
	
	return
