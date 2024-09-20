extends TextureButton


func _on_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_mouse_exited():
	set_modulate(Color(1, 1, 1))


func _on_pressed():
	#breathe
	pass
	
func _on_focus_entered():
	#breathe
	pass

func _on_focus_exited():
	# stop breathing
	pass


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		# stop breathing
		pass
