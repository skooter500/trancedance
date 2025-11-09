extends Node3D

var sc = 1.0


func _process(delta: float) -> void:
	
	sc = lerp(sc, 0.5 + (Analyser.energy_db), delta * 5)
	Analyser.energy_db
