extends TextureButton


func _on_pressed():
	Gameloop.show_tutorial.emit()
	Gameloop.toggle_settings.emit()
