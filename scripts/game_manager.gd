extends Node2D

var level_index = 0
var current_level
var levels = [preload("res://levels/menu.tscn"),
			preload("res://levels/level_01.tscn"),
			preload("res://levels/level_02.tscn"),
			preload("res://levels/level_03.tscn"),
			preload("res://levels/level_04.tscn"),
			preload("res://levels/level_05.tscn"),
			preload("res://levels/win_screen.tscn")]

var levels_unlocked = []
var progress_file = "user://progress.save"

func save_progress():
	var f = File.new()
	f.open(progress_file, File.WRITE)
	f.store_var(levels_unlocked)
	f.close()

func load_progress():
	var f = File.new()
	if false:#f.file_exists(progress_file):
		f.open(progress_file, File.READ)
		levels_unlocked = f.get_var()
		f.close()
	else:
		levels_unlocked.resize(levels.size())
		levels_unlocked[1] = true
		for i in range(2, levels.size()-1):
			levels_unlocked[i] = false

func get_progress():
	var highest_unlocked
	for i in range(1, levels.size()-1):
		if levels_unlocked[i]:
			highest_unlocked = i
	return highest_unlocked

func _ready():
	load_progress()
	load_level(level_index)
	return

func clear_level():
	current_level.queue_free()
	return

func load_level(index):
	if index > levels.size()-1:
		index = 0
	
	print("Load level " + str(index))
	
	current_level = levels[index].instance()
	self.add_child(current_level)
	
	# Fade in
	current_level.modulate.a = 0.0
	while(current_level.modulate.a < 1.0):
		current_level.modulate.a += 0.1
		yield(get_tree(), "idle_frame")
	
	if index == 0:
		current_level.connect("select_level", self, "goto_level")
	else:
		current_level.connect("level_complete", self, "level_complete")
		current_level.connect("reset_level", self, "reset_level")
	
	level_index = index
	return

func level_complete():
	if level_index+1 < levels.size()-1:
		levels_unlocked[level_index+1] = true
	save_progress()
	clear_level()
	load_level(level_index+1)
	return

func reset_level():
	clear_level()
	load_level(level_index)
	return

func goto_level(new_index):
	clear_level()
	load_level(new_index)
	return

func _process(_delta):
	if level_index != 0 and level_index != levels.size()-1:
		if Input.is_action_just_pressed("reset"):
			reset_level()
		if Input.is_action_just_pressed("menu"):
			goto_level(0)
