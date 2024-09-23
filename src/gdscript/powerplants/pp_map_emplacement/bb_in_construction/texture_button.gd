extends TextureButton

signal powerplant_cancel_construction_requested


func _on_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_mouse_exited():
	set_modulate(Color(1, 1, 1))


func _on_close_button_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_close_button_mouse_exited():
	set_modulate(Color(1, 1, 1))


func _on_close_button_pressed():
	powerplant_cancel_construction_requested.emit()
	

func _on_pressed():
	material.set_shader_parameter("show", true)

	
func _on_focus_entered():
	material.set_shader_parameter("show", true)


func _on_focus_exited():
	material.set_shader_parameter("show", false)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		material.set_shader_parameter("show", false)
