extends Button


func _on_pressed():
	TutorialManager.tutorial_ended.emit()
