extends RigidBody2D

export(String) var action_name

export(NodePath) var otherGrabberPath
onready var otherGrabber = self.get_node(otherGrabberPath)

onready var level_manager = self.get_parent().get_parent()

var enabled = true
var grabbing = false
var was_grabbing = false
var anchor_pos

var can_pull = true

func _ready():
	return

func _process(_delta):
	if enabled:
		if Input.is_action_pressed(action_name):
			$AnimatedSprite.animation = "grab"
		else:
			$AnimatedSprite.animation = "default"
	return

func _physics_process(delta):
	if enabled:
		grabbing = Input.is_action_pressed(action_name) and $Area2D.get_overlapping_bodies().size() > 0
		#grabbing = true
		
		if grabbing and !was_grabbing:
			anchor_pos = self.global_position
			$GrabAudio.play()
		
		if !grabbing and was_grabbing:
			$ReleaseAudio.play()
		
		if grabbing:
			self.linear_velocity = Vector2.ZERO
			self.angular_velocity = 0.0
			self.global_position = anchor_pos
		else:
			if level_manager.pull_enabled and can_pull and Input.is_action_just_pressed("pull"):
				var dir = (otherGrabber.global_position - self.global_position).normalized()
				self.linear_velocity *= 0.8
				self.apply_central_impulse(dir * 800.0)
				can_pull = false
				get_parent().get_node("AnimationPlayer").play("rope_fade_out")
				$PullAudio.play()
				yield(get_tree().create_timer(1.5), "timeout")
				can_pull = true
				get_parent().get_node("AnimationPlayer").play("rope_fade_in")
			else:
				var dir = (otherGrabber.global_position - self.global_position).normalized()
				var dist = (self.global_position - otherGrabber.global_position).length()
				self.add_central_force(dir * clamp(24.0-dist, 0.0, 24.0) * 0.15 * delta)
	
	was_grabbing = grabbing
	
	return
