extends TextureButton


func _on_slider_value_changed(value):
	disabled = value == 0
	
	if disabled:
		remove_from_group("buttons")
		add_to_group("disabled_buttons")
	else:
		remove_from_group("disabled_buttons")
		add_to_group("buttons")
		
	GroupManager.buttons_group_updated.emit()
	GroupManager.disabled_buttons_group_updated.emit()
