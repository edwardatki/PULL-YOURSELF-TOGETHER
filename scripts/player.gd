extends Node

export(bool) var enabled = true


func _process(delta):
	$LeftGrabber.enabled = enabled
	$RightGrabber.enabled = enabled
	
	if enabled:
		if !$CameraAnchor/CameraTarget.is_in_group("camera_target"):
			$CameraAnchor/CameraTarget.add_to_group("camera_target")
	else:
		if $CameraAnchor/CameraTarget.is_in_group("camera_target"):
			$CameraAnchor/CameraTarget.remove_from_group("camera_target")
	
	return
