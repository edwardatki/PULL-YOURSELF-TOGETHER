extends Node2D

export(NodePath) var leftGrabberPath
onready var leftGrabber = self.get_node(leftGrabberPath)

export(NodePath) var rightGrabberPath
onready var rightGrabber = self.get_node(rightGrabberPath)

func _ready():
	return

func _process(delta):
	var pos = (leftGrabber.global_position + rightGrabber.global_position) / 2.0
	self.global_position = pos
	return
