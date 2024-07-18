extends CanvasLayer


var year_x = []
@onready var label_theme = load("res://scenes/windows/label_themes.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_year_x_position()
	_set_line_x_points($Screen/Demand/DemandW)
	_set_line_x_points($Screen/Demand/DemandS)
	_set_line_y_points($Screen/Demand/DemandW, Gameloop.demand_winter, 3000, 10)
	_set_line_y_points($Screen/Demand/DemandS, Gameloop.demand_summer, 3000, 5)
	_draw_year_lines()


func _set_year_x_position():
	var distance = $Screen.size.x / Gameloop.n_turns
	for i in Gameloop.n_turns:
		year_x.append(i * distance)
		
func _draw_year_lines():
	var i = 0
	for year in year_x:
		var new_line = Line2D.new()
		new_line.width = 2
		new_line.default_color = Color(1,1,1,0.4)
		new_line.add_point(Vector2(year, 0), 0)
		new_line.add_point(Vector2(year, $Screen.size.y), 1)
		$Screen.add_child(new_line)
		
		var new_label = Label.new()
		new_label.text = str(2020+(i * 3))
		i += 1
		new_label.position = Vector2(new_line.points[1].x - 20, $Screen.size.y + 20)
		new_line.add_child(new_label)

func _set_line_x_points(line):
	for i in Gameloop.n_turns:
		line.set_point_position(i, Vector2(year_x[i], line.points[i].y))
		
		
func _set_line_y_points(line, value, scale, increase_rate):
	for i in Gameloop.n_turns:
		var point = remap(value + (increase_rate * i), 0, scale, $Screen.size.y, 0)
		line.set_point_position(i, Vector2(line.points[i].x, point))
		
func _add_new_point(line, value, turn, scale):
	var point = remap(value, 0, scale, $Screen.size.y, 0)
	line._add_point(Vector2(year_x[turn], point), turn)
	
	var new_button = Button.new()
	new_button.focus_mode = Control.FOCUS_NONE
	new_button.flat = true
	new_button.custom_minimum_size = Vector2(10,10)
	new_button.position = Vector2(year_x[turn], point)
	new_button.tooltip_text = str(value)
	line.add_child(new_button)
	
func _change_point(line, new_value, turn, scale, long_term = false):
	if long_term:
		for i in Gameloop.n_turns:
			var point = remap(new_value, 0, scale, $Screen.size.y, 0)
			line.set_point_position(i, Vector2(line.points[i].x, point))
	else:
		var point = remap(new_value, 0, scale, $Screen.size.y, 0)
		line.set_point_position(turn, Vector2(line.points[turn].x, point))
		
func _create_line(name, x_position, node, scale):
	var new_line = Line2D.new()
	new_line.width = 2
	new_line.default_color = Color(0,1,0,1)
	new_line.name = name
	_add_new_point(new_line, x_position, Gameloop.current_turn, scale)
	_add_new_point(new_line, x_position, Gameloop.current_turn + 1, scale)
	node.add_child(new_line)
	
	var new_label = Label.new()
	new_label.text = name
	new_label.theme = label_theme
	new_label.theme_type_variation = "Screen"
	new_label.custom_minimum_size = Vector2(150,0)
	new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	new_label.position = Vector2(-170, new_line.points[0].y - 20)
	new_line.add_child(new_label)
	
func _create_lines(name, x_position, node, scale, first_time):
	if first_time && Gameloop.current_turn == 0:
		_create_line(name, x_position, node, scale)
	if first_time && Gameloop.current_turn > 0:
		for line in node.get_children():
			if (line.name == name):
				_add_new_point(line, x_position, Gameloop.current_turn + 1, scale)
				
	else:
		for line in node.get_children():
			if line.name == name:
				_change_point(line, x_position, Gameloop.current_turn + 1, scale, false)
	
