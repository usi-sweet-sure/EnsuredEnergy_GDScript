# Used to draw the graphs.
# This is the way to add data to the graphs:
# 1. Add the data with a dataset name and the way to update it
#	 (via signal, etc.) in "graphs_data.gd".
# 2. Add a context in "set_graph_context".
#	 You define the axis min and max values and axis scales (ticks value) and the
#	 data to add from "graphs_data.gd" by using a dataset name
#
# The whole context is redrawn when the graphs are opened, so the last data from
# "graphs_data" is fetched every time.
extends CanvasLayer

@export var draw_axes_outer_lines := false

signal context_changed

var x_axis_min_value: int
var x_axis_max_value: int
var y_axis_min_value: int
var y_axis_max_value: int

var context: String = "energy" # Allows to know what the graph is displaying
var season := "winter"
var default_line_width = 4
var default_point_size = Vector2(15.0,15.0)

@onready var label_theme = load("res://scenes/windows/label_themes.tres")
@onready var graph = $MainFrame/Screen/Drawable
@onready var line_names_container = $MainFrame/LineNamesContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.toggle_graphs.connect(_on_toggle_graphs)
	
		
# Adapts the graph axis,labels and lines for a known context, add them as needed.
func _set_graph_context(context_name: String):
	context = context_name
	_reset_graph()
	context_changed.emit(context)
	$MainFrame/RightContainer/SeasonSwitch.hide()
	
	match context_name:
		"economy":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = -1000
			y_axis_max_value = 2000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)
			_add_data_set_to_graph("building_costs", Color(0.929, 0.651, 0.247))
			_add_data_set_to_graph("production_costs", Color(0.902, 0.49, 0.384))
			_add_data_set_to_graph("import_costs", Color(1, 0.875, 0.255))
			_add_data_set_to_graph("borrowed_money", Color(0.522, 0.98, 0.404))
			_add_data_set_to_graph("available_money", Color(0.2, 0.89, 0.282))
		"landuse":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 250
			_draw_base_graph(Gameloop.years_in_a_turn, 10)
			_add_data_set_to_graph("land_use", Color(0.663, 0.929, 0.416))
		"emissions":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 5
			_draw_base_graph(Gameloop.years_in_a_turn, 1)
			_add_data_set_to_graph("co2_emissions", Color(0.91, 0.38, 0.38))
		"energy":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 2000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)
			$MainFrame/RightContainer/SeasonSwitch.show()
			
			if season == "summer":
				_add_data_set_to_graph("summer_demand", Color(1, 0.702, 0.255, 1))
				_add_data_set_to_graph("summer_energy_supply", Color(0.929, 0.875, 0.416))
			else:
				_add_data_set_to_graph("winter_demand", Color(0, 0.569, 1, 1))
				_add_data_set_to_graph("winter_energy_supply", Color(0.431, 0.961, 0.957))
				_add_data_set_to_graph("winter_energy_import", Color(0.988, 0.973, 0.855))
		"none":
			x_axis_min_value = Gameloop.start_year
			x_axis_max_value = Gameloop.start_year + (Gameloop.total_number_of_turns * Gameloop.years_in_a_turn)
			y_axis_min_value = 0
			y_axis_max_value = 2000
			_draw_base_graph(Gameloop.years_in_a_turn, 200)


# This is what you want to use in a normal use case when adding data to the graph.
# Takes care of everything
func _add_data_set_to_graph(data_set_name: String, line_color = Color(0.836, 0.718, 0.898, 1)):	
	_remove_dataset_from_graph(data_set_name)
		
	_add_new_line_to_graph(data_set_name, line_color, default_line_width)
	
	var points = GraphsData.get_data_set(data_set_name)
	var abscissas = points.keys()
	var ordinates = points.values()
	
	for i in range(points.size()):
		_add_new_point_to_line(data_set_name, abscissas[i], ordinates[i])
		
		
# Draws the axis tick lines and labels
func _draw_base_graph(x_axis_ticks_delta: int, y_axis_ticks_delta):
	_draw_axis_tick_lines("x", x_axis_ticks_delta)
	_draw_axis_tick_lines("y", y_axis_ticks_delta)
	

# Adds the line to the graph and the line name at the top.
# The points are to be added individually after with "_add_new_point_to_line"
func _add_new_line_to_graph(line_name: String, line_color: Color = Color(1,1,1,1), line_width = 2):
	# The line in the graph
	var new_line = Line2D.new()
	new_line.name = line_name
	new_line.antialiased = true
	new_line.width = line_width
	new_line.default_color = line_color
	new_line.z_index = 1 # So axis lines doesnt draw over the lines
	graph.add_child(new_line)
	
	# Container of the line name at the top
	var container := Control.new()
	container.name = line_name
	line_names_container.add_child(container)

	# The line above the line name
	var line := Line2D.new()
	line.add_point(Vector2(0,0))
	line.add_point(Vector2(150,0))
	line.default_color = line_color
	line.width = default_line_width
	
	# The line name
	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_STOP
	label.text = tr(line_name.to_upper() + "_LINE_NAME")
	label.size.x = 150
	# Highlights the line when hovering the line name at the top
	label.mouse_entered.connect(func(): change_line_highlight(line_name))
	label.mouse_exited.connect(func(): change_line_highlight(line_name, false))
	
	container.add_child(line)
	container.add_child(label)



# Add a point at the end of the line
func _add_new_point_to_line(line_name: String, x, y) -> Line2D:
	var line: Line2D = graph.get_node(line_name)
	var x_in_pixels = (graph.size.x / (x_axis_max_value - x_axis_min_value)) * (x - x_axis_min_value)
	var y_in_pixels = graph.size.y - ((graph.size.y / (y_axis_max_value - y_axis_min_value)) * (y - y_axis_min_value))
	line.add_point(Vector2(x_in_pixels, y_in_pixels))
	
	# Square for the value point
	var visual_point = ColorRect.new()
	visual_point.custom_minimum_size = default_point_size
	visual_point.position = Vector2(x_in_pixels - default_point_size.x / 2, y_in_pixels - default_point_size.y / 2)
	visual_point.tooltip_text = str(round(y))
	
	# Custom label to show the value instead of tooltip
	var label = Label.new()
	visual_point.add_child(label)
	label.text = str(round(y))
	label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	label.hide()
	visual_point.color = line.default_color
	visual_point.color.a = 0.75
	visual_point.mouse_entered.connect(func(): change_point_highlight(visual_point))
	visual_point.mouse_exited.connect(func(): change_point_highlight(visual_point, false))
	
	line.add_child(visual_point)
	
	return line


# Removes the line and the line names linked to a dataset
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
	
	# Switch to y axis values as needed
	if not isXAxis:
		axis_size = graph.size.y
		line_size = graph.size.x
		distance_between_ticks = (axis_size / (y_axis_max_value - y_axis_min_value)) * ticks_value_delta
		first_tick_value = y_axis_min_value
	
	# Draw the lines and the labels
	var tick_index = 0
	while tick_index * distance_between_ticks <= axis_size:
		var new_line = Line2D.new()
		new_line.width = 2
		
		if not draw_axes_outer_lines && (tick_index == 0 || tick_index * distance_between_ticks == axis_size):
			new_line.default_color = Color(1,1,1,0)
		else:
			new_line.default_color = Color(1,1,1,0.4)
			
		var new_label = Label.new()
		var label_size_x = 100
		new_label.size.x = label_size_x
		new_line.add_child(new_label)
		new_label.text = str(first_tick_value + (tick_index * ticks_value_delta))
		
		var tick_position = tick_index * distance_between_ticks
		if isXAxis:
			new_line.add_point(Vector2(tick_position, 0))
			new_line.add_point(Vector2(tick_position, line_size))
			new_label.position = Vector2(tick_position - 20, line_size + 3)
		else:
			new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			new_line.add_point(Vector2(0, tick_position))
			new_line.add_point(Vector2(line_size, tick_position))
			new_label.position = Vector2((label_size_x + 15) * -1, axis_size - tick_position - 15)

		graph.add_child(new_line)
		
		tick_index += 1


func _on_toggle_graphs():
	visible = not visible
	
	# All the lines are redrawn when the window is shown
	if visible:
		_set_graph_context(context)


# Season demands aren't linked to a contest, since we want to display them as will
# with the switch
func _on_season_switch_toggled(toggled_on):	
	if toggled_on:
		season = "summer"
	else:
		season = "winter"
		
func _reset_graph():
	for n in graph.get_children():
		graph.remove_child(n)
		n.queue_free()
	
	for n in line_names_container.get_children():
		line_names_container.remove_child(n)
		n.queue_free()

func _on_landuse_button_pressed():
	_set_graph_context("landuse")

func _on_emissions_button_pressed():
	_set_graph_context("emissions")

func _on_economy_button_pressed():
	_set_graph_context("economy")

func _on_energy_button_pressed():
	_set_graph_context("energy")

# Makes a line grow in size to highlight it
func change_line_highlight(line_name, highlight := true):
	var size_factor := 2.5
	var move_factor = size_factor # Used for the points
	var z_index = 2
	
	if not highlight: # Reverts the size back
		size_factor = 1.0
		z_index = 1
	
	if graph.has_node(line_name):
		# Tweens line size
		var line: Line2D = graph.get_node(line_name)
		line.z_index = z_index
		
		var tween = get_tree().create_tween()
		tween.tween_property(line, "width", default_line_width * size_factor, 0.1)
		
		# Change points size only if one point (no line), find it ugly otherwise
		var change_point_size = line.get_children().size() == 1
		
		for child in line.get_children():
			if change_point_size:
				var tween2 = get_tree().create_tween()
				tween2.tween_property(child, "size", default_point_size * size_factor, 0.1)
			
			# Those formula are to be adapated if the size_factor changes
			# For example, a size_factor of 2 doesn't require the move_factor to be divided
			# I'd find a formula but hey
			var label = child.get_children()[0]
			var tween3 = get_tree().create_tween()
			
			if highlight:
				label.show()
				
				if change_point_size:
					child.position -= default_point_size / (move_factor / 2)
					
				tween3.tween_property(label, "position", Vector2(label.position.x, label.position.y - 25), 0.1)
			else:
				if change_point_size:
					child.position += default_point_size / (move_factor / 2)
				tween3.tween_property(label, "position", Vector2(label.position.x, 0), 0.1)
				
				var tween4 = get_tree().create_tween()
				tween4.tween_property(label, "visible", false, 0.1)

# Highlights the point when the mouse is hovering above it
func change_point_highlight(point: ColorRect, highlight := true):
	var size_factor := 2.0
	var move_factor = size_factor # Used for the points
		
	if not highlight: # Reverts the size back
		size_factor = 1.0
		
	var tween = get_tree().create_tween()
	tween.tween_property(point, "size", default_point_size * size_factor, 0.02)
	
	# Those formula are to be adapated if the size_factor changes
	# For example, a size_factor of 2 doesn't require the move_factor to be divided
	if highlight:
		point.position -= default_point_size / (move_factor)
	else:
		point.position += default_point_size / (move_factor)

