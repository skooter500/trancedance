extends Marker3D

var samples:Array
var players:Array

@export var font:Font 

var sequence = []
var file_names = []

@export var path_str = "" 
@export var pad_scene:PackedScene

@export var steps = 8

var rows:int
var cols:int

signal start
signal step
signal stop

@export var out_color:Color
@export var in_color:Color


@onready var mm:MultiMeshInstance3D = $MultiMeshInstance3D

func test_sequence():
	sequence[0][0] = true
	sequence[4][5] = true
	sequence[5][7] = true
	sequence[1][8] = true
	sequence[1][2] = true
	sequence[3][3] = true
	sequence[3][4] = true
	sequence[2][6] = true

func initialise_sequence(rows, cols):
	for i in range(rows):
		var row = []
		for j in range(cols):
			row.append(false)
		sequence.append(row)
	self.rows = rows
	self.cols = cols
	
func _process(delta: float) -> void:
	assign_colors()

func assign_colors():
	var i = 0
	for col in range(steps):				
		for row in range(samples.size()):
			var c = in_color if sequence[row][col] else out_color
			mm.multimesh.set_instance_color(i, c)
			i += 1

func _ready():
	load_samples()
	initialise_sequence(samples.size(), steps)
	make_sequencer()
	# test_sequence()
	for i in range(50):
		var asp = AudioStreamPlayer.new()
		asp.bus = "Sequencer"
		add_child(asp)
		players.push_back(asp)

var asp_index = 0

func print_sequence():
	print()
	for row in range(samples.size() -1, -1, -1):
		var s = ""
		for col in range(steps):
			s += "1" if sequence[row][col] else "0" 
		print(s)
		
func play_sample(e, i):
	
	# print("play sample:" + str(i))
	var p:AudioStream = samples[i]
	var asp = players[asp_index]
	asp.stream = p
	asp.play()
	asp_index = (asp_index + 1) % players.size()

func toggle(e, row, col):
	print("toggle " + str(row) + " " + str(col))
	sequence[row][col] = ! sequence[row][col]
	play_sample(0, row)
	print_sequence()
	

var s = 0.08
var spacer = 1.1

func make_sequencer():	
	
	mm.multimesh.instance_count = steps * samples.size()
	var i = 0 
	for col in range(steps):				
		for row in range(samples.size()):
			var pad = pad_scene.instantiate()
			
			var p = Vector3(s * col * spacer, s * row * spacer, 0)
			pad.position = p		
			# pad.rotation = rotation
			#var tm = TextMesh.new()
			#tm.font = font
			#tm.font_size = 1
			#tm.depth = 0.005
			## tm.text = str(row) + "," + str(col)
			#tm.text = file_names[row]
			#pad.get_node("MeshInstance3D2").mesh = tm
			var t = Transform3D()
			
			var s1 = 0.7
			t = t.scaled(Vector3(s * s1, s * s1, s * s1))
			t.origin = p
			mm.multimesh.set_instance_transform(i, t)
			i += 1
			pad.area_entered.connect(toggle.bind(row, col))
			add_child(pad)
		
func load_samples():
	var dir = DirAccess.open(path_str)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		# From https://forum.godotengine.org/t/loading-an-ogg-or-wav-file-from-res-sfx-in-gdscript/28243/2
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			if file_name.ends_with('.wav.import') or file_name.ends_with('.mp3.import'):			
				file_name = file_name.left(len(file_name) - len('.import'))
				# var asp = AudioStreamPlayer.new()
				# asp.set_stream(load(SOUND_DIR + '/' + filename))
				# add_child(asp)
				# var arr = file_name.split('/')
				# var name = arr[arr.size()-1].split('.')[0]
				# samples[name] = asp
			
				var stream = load(path_str + "/" + file_name)
				stream.resource_name = file_name
				samples.push_back(stream)
				file_names.push_back(file_name)
				# $AudioStreamPlayer.play()
				# break
			file_name = dir.get_next()	

func play_step(col):
	var p = Vector3(s * col * spacer, s * -1 * spacer, 0)
			
	$timer_ball.position = p
	for row in range(rows):
		if sequence[row][col]:
			play_sample(0, row)

var step_index:int = 0

func _on_timer_timeout() -> void:
	play_step(step_index)
	step_index = (step_index + 1) % steps
	pass # Replace with function body.


func _on_start_stop_area_entered(area: Area3D) -> void:
	# $"../sequencer/Timer".start()
	
	if $Timer.is_stopped():
		start.emit()
		$Timer.start()
		$"../sequencer3/Timer".start()
		$"../sequencer2/Timer".start()
	else:
		stop.emit()
		$Timer.stop()
		$"../sequencer3/Timer".stop()
		$"../sequencer2/Timer".stop()
	pass # Replace with function body.
