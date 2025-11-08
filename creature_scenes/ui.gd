class_name UI 

extends Node

static var ui

var log_message:String


var vars = Dictionary()

static func console(message):
	ui.log_message += (message + "\n")
	
	print(message)
	
func _ready():
	ui = self
	
static func variables(key, val):
	if ui:
		ui.vars[key] = val
	
func _process(delta: float) -> void:
	$scroll/console.text = log_message
	# Get the ScrollContainer node
	var scroll_container = $scroll

	# Scroll to the bottom
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

	# Scroll to the right edge
	scroll_container.scroll_horizontal = scroll_container.get_h_scroll_bar().max_value

	# Or both at once
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
	scroll_container.scroll_horizontal = scroll_container.get_h_scroll_bar().max_value
	
	show_variables()
	vars.clear()
	
func show_variables():
	var i = 0
	for s in vars.keys():
		var count = $variables/GridContainer.get_child_count()
		var lab:Label
		if i == count:
			lab	= Label.new()
			lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			$variables/GridContainer.add_child(lab)
		else:
			lab = $variables/GridContainer.get_child(i)		
		i = i + 1
		var v = float(vars[s])
		var absv = abs(v)
		lab.text = s + ":%07.3f" % absv
		if v < 0:
			lab.modulate = Color.REBECCA_PURPLE
		else:
			lab.modulate = Color.GREEN
		
