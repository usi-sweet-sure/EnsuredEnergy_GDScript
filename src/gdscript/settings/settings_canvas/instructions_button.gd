extends TextureButton


func _on_pressed():
	TutorialManager.tutorial_started.emit()
	Gameloop.toggle_settings.emit()
