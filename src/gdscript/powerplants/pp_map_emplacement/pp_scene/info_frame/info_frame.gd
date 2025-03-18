extends TextureRect

@onready var position_label: Label = $Position

func _on_show_info_frame():
	var tween = get_tree().create_tween()

	var new_scale = scale
	scale = Vector2()
	visible = true
	tween.tween_property(self, "scale", new_scale, 0.1)
	await tween.finished
	
	# The InfoFrame accepted positions have been determined by testing in game.
	var y_top_limit = 0
	var x_left_limit = 475
	var x_right_limit = 1117
	var padding = 25
	var pos = get_global_transform_with_canvas().get_origin()

	var camera_correction := Vector2()
	
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
