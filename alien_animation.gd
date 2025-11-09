extends Node3D

func _ready() -> void:
	$AnimationPlayer.play("Armature|mixamo_com|Layer0")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.play("Armature|mixamo_com|Layer0")

	pass # Replace with function body.
