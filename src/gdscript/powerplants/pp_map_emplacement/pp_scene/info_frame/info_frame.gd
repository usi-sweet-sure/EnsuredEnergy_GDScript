extends TextureRect

@onready var position_label: Label = $Position

func _on_show_info_frame():
	var tween = get_tree().create_tween()

	var new_scale = scale
	scale = Vector2()
	visible = true
	tween.tween_property(self, "scale", new_scale, 0.1)
	await tween.finished

	
	# The limits depend on where on the screen is the infoframe,
	# since the ui has multiple elements hidings more or less of the screen,
	# like the clock or the continue button.
	# The InfoFrame accepted positions have been determined by testing in game.
	# This is the logic used :
	# If pos.y is less than 112, then pos.x can't be less than 380
	# If pos.y is between 112 and 313, then pos.x can't be less than 447
	# If pos.y is less than 275, then pos.x can't be more than 1117
	# If pos.y is more that 313, then pos.x can't be less 475
	# If pos.y is more than 587, then pos.x can't be more than 1123
	# pos.y can't be less than 0
	var pos = get_global_transform_with_canvas().get_origin()
	var camera_correction := Vector2()
	var padding = 25
	var y_top_limit = 0
	var x_left_limit = 0
	var x_right_limit = 1432
	
	
	if pos.y <= 112:
		x_left_limit = 380
		x_right_limit = 1117
	elif pos.y > 112 and pos.y <= 313:
		x_left_limit = 447
		
		if pos.y <= 275:
			x_right_limit = 1117
	else:
		x_left_limit = 475
		
		if pos.y > 587:
			x_right_limit = 1123

	if pos.y < y_top_limit:
		camera_correction.y = y_top_limit - pos.y + padding
		
	if pos.x < x_left_limit:
		camera_correction.x = x_left_limit - pos.x + padding
		
	if pos.x > x_right_limit:
		camera_correction.x = x_right_limit - pos.x - padding
	
	position_label.text = "screen position : " + str(pos) + "\ncamera correction : " + str(camera_correction)
	if camera_correction:
		CameraManager.move_camera_by.emit(camera_correction)


func _on_hide_info_frame():
	hide()
