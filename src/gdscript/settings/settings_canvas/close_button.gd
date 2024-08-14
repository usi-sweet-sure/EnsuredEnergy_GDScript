extends Button


func _on_pressed():
	Gameloop.toggle_settings.emit()
