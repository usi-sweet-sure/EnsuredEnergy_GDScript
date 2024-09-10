extends TextureButton


func _on_player_name_text_changed(new_text: String):
	disabled = new_text.length() == 0
	
	if disabled:
		remove_from_group("buttons")
		add_to_group("disabled_buttons")
		GroupManager.buttons_group_updated.emit()
		GroupManager.disabled_buttons_group_updated.emit()
	else:
		remove_from_group("disabled_buttons")
		add_to_group("buttons")
		GroupManager.buttons_group_updated.emit()
		GroupManager.disabled_buttons_group_updated.emit()
