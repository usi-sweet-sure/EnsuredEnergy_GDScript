extends AnimationPlayer


func _on_texture_button_mouse_entered():
	play("tooltip_scale_up")


func _on_texture_button_mouse_exited():
	play("tooltip_scale_down")
