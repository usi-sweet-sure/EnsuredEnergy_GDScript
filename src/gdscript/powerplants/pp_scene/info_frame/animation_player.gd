extends AnimationPlayer


func _on_button_plus_mouse_entered():
	play("show_modifiers")


func _on_button_plus_mouse_exited():
	play("hide_modifiers")


func _on_button_minus_mouse_entered():
	play("show_modifiers")


func _on_button_minus_mouse_exited():
	play("hide_modifiers")
