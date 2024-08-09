extends CanvasLayer

var x_axis_min_value: int
var x_axis_max_value: int
var y_axis_min_value: int
var y_axis_max_value: int

#var x_axis_ticks: Array[float] = [] # years are represented on the x-axis
#var y_axis_ticks: Array[float] = [] # data represented on y-axis may vary, but ticks remains at the same place
# We store all the lines in a dictionnary of the form :
# {
#   "line_1_name": Line2D,
#   "line_2_name": Line2D,
# }
# We can retrieve and update them more easily this way
var lines = {}

# Allows to know what the graph is displaying
var context: String = "none"

@onready var label_theme = load("res://scenes/windows/label_themes.tres")
@onready var graph = $MainFrame/Screen


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.toggle_graphs.connect(_on_toggle_graphs)
	_set_graph_context("energy_winter")

			
# Draws the axis tick lines and labels
func _draw_base_graph(x_axis_ticks_delta: int, y_axis_ticks_delta):
	_draw_axis_tick_lines("x", x_axis_ticks_delta)
	_draw_axis_tick_lines("y", y_axis_ticks_delta)
	
	
func _add_new_line_to_graph(line_name: String, line_color: Color = Color(1,1,1,1), line_width = 2):
	var new_line = Line2D.new()
	new_line.width = line_width
	new_line.default_color = line_color
	
	lines[line_name] = new_line
	graph.add_child(new_line)
	

func _add_new_point_to_line(line_name: String, x, y) -> Line2D:
	var line: Line2D = lines[line_name]
	var x_in_pixels = (graph.size.x / (x_axis_max_value - x_axis_min_value)) * (x - x_axis_min_value)
	var y_in_pixels = graph.size.y - ((graph.size.y / (y_axis_max_value - y_axis_min_value)) * (y - y_axis_min_value))
	print("(", x_in_pixels, ",", y_in_pixels ,")")
	line.add_point(Vector2(x_in_pixels, y_in_pixels))
	
	var new_button = Button.new()
	new_button.focus_mode = Control.FOCUS_NONE
	new_button.flat = true
	new_button.custom_minimum_size = Vector2(10,10)
	new_button.position = Vector2(x_in_pixels, y_in_pixels)
	new_button.tooltip_text = str(y)
	line.add_child(new_button)
	
	return line
	
	
#func _change_line_point(line_name: String, new_value, turn, value_max_range, long_term = false) -> Line2D:
	#var line = lines[line_name]
	#var ordinate = remap(new_value, 0, value_max_range, graph.size.y, 0)
	#
	#if long_term:
		#for i in Gameloop.total_number_of_turns:
			#line.set_point_position(i, Vector2(line.points[i].x, ordinate))
	#else:
		#line.set_point_position(turn, Vector2(line.points[turn].x, ordinate))
	#
	#return line
		#
#func _create_line(name, x_position, node, scale):
	#var new_line = Line2D.new()
	#new_line.width = 2
	#new_line.default_color = Color(0,1,0,1)
	#new_line.name = name
	#_add_new_point(new_line, x_position, Gameloop.current_turn, scale)
	#_add_new_point(new_line, x_position, Gameloop.current_turn + 1, scale)
	#node.add_child(new_line)
	#
	#var new_label = Label.new()
	#new_label.text = name
	#new_label.theme = label_theme
	#new_label.theme_type_variation = "Screen"
	#new_label.custom_minimum_size = Vector2(150,0)
	#new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	#new_label.position = Vector2(-170, new_line.points[0].y - 20)
	#new_line.add_child(new_label)
	#
	
#func _create_lines(name, x_position, node, scale, first_time):
	#if first_time && Gameloop.current_turn == 0:
		#_create_line(name, x_position, node, scale)
	#if first_time && Gameloop.current_turn > 0:
		#for line in node.get_children():
			#if (line.name == name):
				#_add_new_point(line, x_position, Gameloop.current_turn + 1, scale)
				#
	#else:
		#for line in node.get_children():
			#if line.name == name:
				#_change_point(line, x_position, Gameloop.current_turn + 1, scale, false)


# Draws a line for every tick of the axis and the labels
func _draw_axis_tick_lines(axis: String, ticks_value_delta: int):
	var isXAxis := axis == "x" || axis == "X"
	
	# Defaults to x axis values
	var axis_size = graph.size.x
	var line_size = graph.size.y
	var distance_between_ticks = (axis_size / (x_axis_max_value - x_axis_min_value)) * ticks_value_delta
	var first_tick_value = x_axis_min_value
	
	# Switch to y axis values if needed
	if not isXAxis:
		axis_size = graph.size.y
		line_size = graph.size.x
		distance_between_ticks = (axis_size / (y_axis_max_value - y_axis_min_value)) * ticks_value_delta
		first_tick_value = y_axis_min_value
	
	# Draw the lines
	var tick_index = 0
	
	while tick_index * distance_between_ticks <= axis_size:
		var abscissa = 0
		var ordinate = 0
		
		var new_line = Line2D.new()
		new_line.width = 2
		new_line.default_color = Color(1,1,1,0.4)
		
		var new_label = Label.new()
		new_label.text = str(first_tick_value + (tick_index * ticks_value_delta))
		
		var tick_position = tick_index * distance_between_ticks
		if isXAxis:
			new_line.add_point(Vector2(tick_position, 0))
			new_line.add_point(Vector2(tick_position, line_size))
			new_label.position = Vector2(tick_position - 20, line_size + 3)
		else:
			new_line.add_point(Vector2(0, tick_position))
			new_line.add_point(Vector2(line_size, tick_position))
			new_label.position = Vector2(-40, axis_size - tick_position - 15)

		
		new_line.add_child(new_label)
		graph.add_child(new_line)
		
		tick_index += 1
	
		
# Adapts the graph axis,labels and lines for a known context, add them as needed
func _set_graph_context(context_name: String):
	_reset_graph()
	
	match context_name:
		"energy_winter":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 3000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)
			
			# Add demand line to graph
			_add_new_line_to_graph("winter_demand_line", Color(0, 0.569, 1, 1), 4)
			
			for i in Gameloop.total_number_of_turns:
				_add_new_point_to_line("winter_demand_line",
						Gameloop.start_year + (Gameloop.years_in_a_turn * i),
						Gameloop.demand_winter + (10 * i))
		"energy_summer":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 3000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)
			
			# Add demand line to graph
			_add_new_line_to_graph("summer_demand_line", Color(1, 0.702, 0.255, 1), 4)
			
			for i in Gameloop.total_number_of_turns:
				_add_new_point_to_line("summer_demand_line",
										Gameloop.start_year + (Gameloop.years_in_a_turn * i),
										Gameloop.demand_summer + (5 * i))


func _on_toggle_graphs():
	visible = not visible


func _on_season_switch_toggled(toggled_on):
	if toggled_on:
		_set_graph_context("energy_summer")
	else:
		_set_graph_context("energy_winter")
		
		
func _reset_graph():
	for n in graph.get_children():
		graph.remove_child(n)
		n.queue_free() 
