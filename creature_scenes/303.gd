extends Node3D

@onready var tree = $jellyquid2/AnimationTree
	

func _ready() -> void:
	tree.set_process_callback(AnimationTree.ANIMATION_PROCESS_MANUAL)

func _physics_process(delta: float) -> void:	
	var tar = remap(Controller303.targetSpe, 0, 3.58, -2, 2)
	tree.advance(delta * tar)

	
