extends TextureRect


func _on_show_info_frame():
	var tween = get_tree().create_tween()

	var new_scale = scale
	scale = Vector2()
	visible = true
	tween.tween_property(self, "scale", new_scale, 0.1)


func _on_hide_info_frame():
	hide()
