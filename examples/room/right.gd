extends XRNode3D


func _on_hand_pose_detector_pose_started(p_name: String) -> void:
	print(p_name + " started")
	pass # Replace with function body.


func _on_hand_pose_detector_pose_ended(p_name: String) -> void:
	print(p_name + " stoped")
	
	pass # Replace with function body.


func _on_right_hand_area_entered(area: Area3D) -> void:
	print("right hand entered")
	pass # Replace with function body.
