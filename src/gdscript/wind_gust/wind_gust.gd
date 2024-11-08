extends Line2D

class_name WindGust

var path_followers = []
var use_gradient = false

@export var line_segments = 20
@export var trail_length = 0.5 # (float,0.0,1.0)
@export var trail_speed = 0.003
@export var trail_color_gradient : Gradient
@export var random_y_offset = 0.0

@onready var path_2d: Path2D = $Path2D

var active = false
var loop = true
var initial_curve_points: Array[Vector2]

func _ready() -> void:
	var curve = path_2d.curve
	
	
	for i in range(curve.point_count):
		var initial_point = curve.get_point_position(i)
		var new_point = Vector2(initial_point.x, initial_point.y)
		initial_curve_points.append(new_point)


func activate():
	loop = true
	active = false
		
	if random_y_offset > 0.0:
		randomize_path()
		
	init_path_followers()
	
	if trail_color_gradient != null:
		use_gradient = true
		
	
	active = true
	

func deactivate():
	loop = false
	

func _process(delta):
	if active:
		move_path()
		
		if use_gradient:
			update_path_gradient()
			
		draw_path()
	
	
func move_path():
	for path_follower: TrailFollow2D in path_followers:
		path_follower.trail_offset += trail_speed
		path_follower.progress_ratio = clamp(path_follower.trail_offset, 0, 1)

	if path_followers[0].progress_ratio >= 1.0:
		if loop:
			activate()


func update_path_gradient():
		for pcnt in range(line_segments + 1):
			gradient.colors[pcnt] = trail_color_gradient.sample(gradient.offsets[pcnt])
			gradient.colors[pcnt].a *= trail_color_gradient.sample(path_followers[pcnt].progress_ratio).a
		

func randomize_path():
	var i = 0
	for point in initial_curve_points:
		var new_point = Vector2(point.x, point.y)
		new_point.y += randf_range(-random_y_offset, random_y_offset)
		path_2d.curve.set_point_position(i, new_point)
		i += 1
		
		
func draw_path():
	clear_points()
	
	for path_follower in path_followers:
		add_point(path_follower.position)


func init_path_followers():
	path_followers = []
	
	for path_follower_index in range(line_segments + 1):
		var new_path_follower = TrailFollow2D.new()
		path_2d.add_child(new_path_follower)
		new_path_follower.trail_offset = path_follower_index / float(line_segments) * trail_length - trail_length
		new_path_follower.loop = false
		path_followers.append(new_path_follower)
	
	gradient = Gradient.new()
	gradient.remove_point(0)

	for gradient_index in range(line_segments):
		gradient.add_point((gradient_index + 1)/float(line_segments), Color(1.0,1.0,1.0,1.0))
