extends Node3D

func _ready() -> void:
	$AnimationPlayer.play("Action")

func  _process(delta: float) -> void:
	rotation = Vector3(Controller303.targetPit, Controller303.targetYaw, Controller303.targetRol)
	$AnimationPlayer.speed_scale = remap(Controller303.targetSpe, 0, 3.58, -2, 2)
