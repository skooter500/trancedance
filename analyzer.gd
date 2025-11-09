class_name Analyser

extends Node

var spectrum_analyzer: AudioEffectInstance
var MIN_DB = -80.0  # Minimum decibel threshold

func _ready():
	# Get the spectrum analyzer from the audio bus
	var bus_index = AudioServer.get_bus_index("Master")  # Or your bus name
	spectrum_analyzer = AudioServer.get_bus_effect_instance(bus_index, 0)

static var energy_db

func _process(_delta):
	if spectrum_analyzer:
		# Get the magnitude (amplitude) at a specific frequency
		var magnitude = spectrum_analyzer.get_magnitude_for_frequency_range(20, 20000)
		
		# Convert to decibels
		var energy = magnitude.length()
		energy_db = linear_to_db(energy)
		## print("Amplitude: ", energy)

		# Normalize to 0-1 range		
		
