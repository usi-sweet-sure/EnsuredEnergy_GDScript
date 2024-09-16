extends NinePatchRect


func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "info_frame_show":
		# Detect if the box is enterily on screen or not.
		# This is useful to reposition the most right info box when it goes out screen
		var viewport_width = get_viewport_rect().size.x
		var infobox_right_side_position_x = get_global_transform().get_origin().x + (size.x * scale.x)
		var right_margin = 20 # space to not place the info box too far on the right of the screen

		if infobox_right_side_position_x > viewport_width - right_margin:
			var x_correction = (viewport_width - infobox_right_side_position_x - right_margin)
			position = Vector2(position.x + x_correction, position.y)
