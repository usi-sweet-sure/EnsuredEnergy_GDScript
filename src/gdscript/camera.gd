extends Camera2D

const ZOOM_OUT_LIMIT := Vector2(0.25, 0.25)
const ZOOM_IN_LIMIT := Vector2(0.6, 0.6)
const ZOOM_SPEED := Vector2(0.2, 0.2)
const POWER_PLANT_ZOOM_IN_LIMIT := Vector2(0.65, 0.65)
const PLANT_ZOOM := Vector2(0.55, 0.55)
const CAMERA_SPEED := 40
const ZOOM_ANIMATION_DURATION := 0.3
const PAN_ZOOM_SENSITIVITY := 0.05
var camera_blocked = false

# Record initial position and zoom for reset
var init_pos := Vector2()
var init_zoom := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Record initial position and zoom
	init_pos = position
	init_zoom = zoom
	scale_plants(init_zoom)
	
	# Allows to reset the zoom, so the tutorial windows are placed correctly
	TutorialManager.tutorial_started.connect(_on_show_tutorial)
	TutorialManager.tutorial_ended.connect(_on_tutorial_ended)
	#E. !!! Do or remove
	# Maybe TODO for carbon sequestration if we add a button for it !!
	#for power_plant in get_tree().get_nodes_in_group("PP"):
		#power_plant.ZoomSignal.connect(plant_zoom);
	camera_blocked = true # Unblocked at the end of the tutorial
	CameraManager.block_camera.connect(_on_block_camera)
	CameraManager.unlock_camera.connect(_on_unlock_camera)
	
func _physics_process(delta):
	if not camera_blocked:
		# Arrow key camera movement
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		position = position.lerp(position + direction * CAMERA_SPEED * zoom, CAMERA_SPEED * delta)


# Updates the size of power plants and build buttons according to the zoom
func scale_plants(zoom_val: Vector2):
	# Is zoom valid ?
	if zoom_val < POWER_PLANT_ZOOM_IN_LIMIT and not camera_blocked:
		var new_zoom = Vector2(1.0, 1.0) / (zoom_val * 2.5)
		
		#for power_plant in get_tree().get_nodes_in_group("PP"):
			#animate_power_plant_zoom(power_plant, new_zoom)


		#for sprite in get_tree().get_nodes_in_group("pp_sprites"):
			#animate_power_plant_zoom(sprite, new_zoom)
			
		
		for frame in get_tree().get_nodes_in_group("pp_info_frames"):
			animate_power_plant_zoom(frame, new_zoom)
			
		
		#for build_button in get_tree().get_nodes_in_group("BB"):
			#animate_power_plant_zoom(build_button, new_zoom)


# Adds control to inputs that otherwise would not have triggered any events  
# In our case, this includes 2 events:  
#     1) When the player clicks the screen, in which case we want to drag the camera around
#     2) When the player uses the mouse wheel, in which case we want to zoom in or out
func _unhandled_input(event):
	if event is InputEventMagnifyGesture and not camera_blocked:
		var target_zoom = clamp(zoom * event.factor, ZOOM_OUT_LIMIT, ZOOM_IN_LIMIT)
		zoom = target_zoom
		scale_plants(target_zoom)
	
	elif event is InputEventPanGesture and not camera_blocked:
		var target_zoom = clamp(zoom + Vector2(event.delta.y * PAN_ZOOM_SENSITIVITY, event.delta.y * PAN_ZOOM_SENSITIVITY), ZOOM_OUT_LIMIT, ZOOM_IN_LIMIT)
		zoom = target_zoom
		scale_plants(target_zoom)
	
	# Mouse drag moves the camera
	if event is InputEventMouseMotion and not camera_blocked:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative / zoom
			
	# Mouse wheel zooms the camera
	# Scrolling down zooms out, scrolling up zooms in
	# The higher the zoom value, the more zoom in we are
	if event is InputEventMouseButton and not camera_blocked:
		# Zoom out if within limits
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && zoom > ZOOM_OUT_LIMIT:
			var new_zoom = clamp(zoom - ZOOM_SPEED, ZOOM_OUT_LIMIT, ZOOM_IN_LIMIT)
			animate_camera_zoom(new_zoom)
		# Zoom in if within limits
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP && zoom < ZOOM_IN_LIMIT:
			var new_zoom = clamp(zoom + ZOOM_SPEED, ZOOM_OUT_LIMIT, ZOOM_IN_LIMIT)
			animate_camera_zoom(new_zoom)


func animate_camera_zoom(new_zoom):
	if not camera_blocked:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "zoom", new_zoom, ZOOM_ANIMATION_DURATION)
		scale_plants(new_zoom)


func animate_camera_position(new_position):
	if not camera_blocked:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", new_position, ZOOM_ANIMATION_DURATION)
	
	
# Animate power plants and build buttons zoom
func animate_power_plant_zoom(object, new_zoom):
	var tween = get_tree().create_tween()
	tween.tween_property(object, "scale", new_zoom, ZOOM_ANIMATION_DURATION)


func _on_show_tutorial():
	animate_camera_position(init_pos)
	animate_camera_zoom(init_zoom)
	camera_blocked = true
	
	

func _on_tutorial_ended():
	camera_blocked = false
	
#E. Do or remove
# func plant_zoom(_plant_pos: Vector2):
	#pass
	#var position_tween = get_tree().create_tween();
	#position_tween.tween_property(self, "position", plant_pos, ZOOM_ANIMATION_DURATION + 0.1);
	#var zoom_tween = get_tree().create_tween();
	#zoom_tween.tween_property(self, "zoom", PLANT_ZOOM, ZOOM_ANIMATION_DURATION + 0.1);

func _on_block_camera():
	camera_blocked = true
	

func _on_unlock_camera():
	camera_blocked = false
