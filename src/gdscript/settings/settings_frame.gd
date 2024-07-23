extends ColorRect


func _on_open_settings_frame_button_pressed():
	show()


func _on_instructions_button_pressed():
	print("fdsljkhfsad")
	Gameloop.show_tutorial.emit()
	hide()
