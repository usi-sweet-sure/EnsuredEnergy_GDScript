extends TextureButton


func _ready() -> void:
	Gameloop.game_ended.connect(_on_game_ended)
	

func _on_pressed():
	TutorialManager.tutorial_started.emit()
	Gameloop.toggle_settings.emit()


func _on_game_ended():
	disabled = true
	_change_button_group()
	
	
func _change_button_group():
	if disabled:
		remove_from_group("buttons")
		add_to_group("disabled_buttons")
	else:
		remove_from_group("disabled_buttons")
		add_to_group("buttons")
		
	GroupManager.buttons_group_updated.emit()
	GroupManager.disabled_buttons_group_updated.emit()
