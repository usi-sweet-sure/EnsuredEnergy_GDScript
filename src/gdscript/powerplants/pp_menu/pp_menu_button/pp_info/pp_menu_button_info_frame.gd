extends NinePatchRect


func _ready():
	PowerplantsManager.powerplant_build_requested.connect(_on_build_requested)


# Repositions the most right info box when it goes off screen
func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "info_frame_show":
		# Detects if the box is enterily on screen or not.
		var viewport_width = get_viewport_rect().size.x
		var infobox_right_side_position_x = get_global_transform().get_origin().x + (size.x * scale.x)
		var right_margin = 20 # space to not place the info box too far on the right of the screen

		if infobox_right_side_position_x > viewport_width - right_margin:
			var x_correction = (viewport_width - infobox_right_side_position_x - right_margin)
			position = Vector2(position.x + x_correction, position.y)


func _on_build_requested(_target_node: Node, _metrics: PowerplantMetrics):
	hide()
