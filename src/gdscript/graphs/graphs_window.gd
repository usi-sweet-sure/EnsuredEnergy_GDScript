extends CanvasLayer

var x_axis_min_value: int
var x_axis_max_value: int
var y_axis_min_value: int
var y_axis_max_value: int


var context: String = "none" # Allows to know what the graph is displaying
var season := "winter"
var default_line_width = 4
var default_point_size = Vector2(15.0,15.0)

@onready var label_theme = load("res://scenes/windows/label_themes.tres")
@onready var graph = $MainFrame/Screen
@onready var line_names_container = $MainFrame/LineNamesContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.toggle_graphs.connect(_on_toggle_graphs)
			

# Adapts the graph axis,labels and lines for a known context, add them as needed
func _set_graph_context(context_name: String):
	context = context_name
	_reset_graph()
	
	match context_name:
		"economy":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = -1000
			y_axis_max_value = 2000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)
			_add_data_set_to_graph("building")
		"environment":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 2000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)
		"energy":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 3000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)
		"none":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 2000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)
		
		
	if season == "winter":
		_on_season_switch_toggled(false)
	elif season == "summer":
		_on_season_switch_toggled(true)


# Draws the axis tick lines and labels
func _draw_base_graph(x_axis_ticks_delta: int, y_axis_ticks_delta):
	_draw_axis_tick_lines("x", x_axis_ticks_delta)
	_draw_axis_tick_lines("y", y_axis_ticks_delta)
	
	
func _add_data_set_to_graph(data_set_name: String, line_color = Color(0.836, 0.718, 0.898, 1)):	
	_remove_dataset_from_graph(data_set_name)
		
	_add_new_line_to_graph(data_set_name, line_color, default_line_width)
	
	var points = GraphsData.get_data_set(data_set_name)
	var abscissas = points.keys()
	var ordinates = points.values()
	
	for i in range(points.size()):
		_add_new_point_to_line(data_set_name, abscissas[i], ordinates[i])
	
	
func _add_new_line_to_graph(line_name: String, line_color: Color = Color(1,1,1,1), line_width = 2):
	var new_line = Line2D.new()
	new_line.name = line_name
	new_line.antialiased = true
	new_line.width = line_width
	new_line.default_color = line_color
	new_line.z_index = 1 # So axis lines doesnt draw over the lines
	graph.add_child(new_line)
	
	# Line name at the top
	var vertical_container := VBoxContainer.new()
	vertical_container.name = line_name
	vertical_container.mouse_entered.connect(func(): change_line_highlight(line_name))
	vertical_container.mouse_exited.connect(func(): change_line_highlight(line_name, false))
	line_names_container.add_child(vertical_container)
	var line := Line2D.new()
	line.add_point(Vector2(0,0))
	line.add_point(Vector2(150,0))
	line.default_color = line_color
	line.width = default_line_width
	var label := Label.new()
	label.text = tr(line_name.to_upper() + "_LINE_NAME")
	vertical_container.add_child(line)
	vertical_container.add_child(label)

func _add_new_point_to_line(line_name: String, x, y) -> Line2D:
	var line: Line2D = graph.get_node(line_name)
	var x_in_pixels = (graph.size.x / (x_axis_max_value - x_axis_min_value)) * (x - x_axis_min_value)
	var y_in_pixels = graph.size.y - ((graph.size.y / (y_axis_max_value - y_axis_min_value)) * (y - y_axis_min_value))
	line.add_point(Vector2(x_in_pixels, y_in_pixels))
	
	# Button for the value point
	var new_button = ColorRect.new()
	new_button.custom_minimum_size = default_point_size
	new_button.position = Vector2(x_in_pixels - default_point_size.x / 2, y_in_pixels - default_point_size.y / 2)
	new_button.tooltip_text = str(round(y))
	new_button.color = line.default_color
	new_button.color.a = 0.75
	
	line.add_child(new_button)
	
	return line


func _remove_dataset_from_graph(data_set_name: String):
	if graph.has_node(data_set_name):
		var line = graph.get_node(data_set_name)
		graph.remove_child(line)
		line.queue_free()
		
	if line_names_container.has_node(data_set_name):
		var vcontainer = line_names_container.get_node(data_set_name)
		line_names_container.remove_child(vcontainer)
		vcontainer.queue_free()
		
		
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

func _on_toggle_graphs():
	visible = not visible
	
	if visible:
		_set_graph_context(context)


func _on_season_switch_toggled(toggled_on):
	if toggled_on:
		season = "summer"
		
		_remove_dataset_from_graph("winter_demand")
		_add_data_set_to_graph("summer_demand", Color(1, 0.702, 0.255, 1))
	else:
		season = "winter"
	
		_remove_dataset_from_graph("summer_demand")
		_add_data_set_to_graph("winter_demand", Color(0, 0.569, 1, 1))
		
func _reset_graph():
	for n in graph.get_children():
		graph.remove_child(n)
		n.queue_free()
	
	for n in line_names_container.get_children():
		line_names_container.remove_child(n)
		n.queue_free()


func _on_economy_button_pressed():
	_set_graph_context("economy")


func _on_environment_button_pressed():
	_set_graph_context("environment")


func _on_energy_button_pressed():
	_set_graph_context("environment")

# Makes a line grow in size to highlight it
func change_line_highlight(line_name, highlight := true):
	var size_factor := 2.5
	var move_factor = size_factor
	
	if not highlight:
		size_factor = 1.0
	
	if graph.has_node(line_name):
		# Line size
		var line = graph.get_node(line_name)
		var tween = get_tree().create_tween()
		tween.tween_property(line, "width", default_line_width * size_factor, 0.1)
		
		# Points size (only grow if only one point (no line), it's ugly otherwise)
		if line.get_children().size() == 1:
			for child in line.get_children():
				if child is ColorRect:
					tween = get_tree().create_tween()
					tween.tween_property(child, "size", default_point_size * size_factor, 0.1)
					
					if highlight:
						child.position -= default_point_size / (move_factor / 2)
					else:
						child.position += default_point_size / (move_factor / 2)
