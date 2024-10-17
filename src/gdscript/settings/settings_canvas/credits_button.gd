extends TextureButton


func _on_pressed():
	Gameloop.toggle_credits.emit()
