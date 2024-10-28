extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	HttpManager.http_request_active_updated.connect(_on_request_active_updated)


func _on_request_active_updated(active: bool):
	var previous_value = disabled
		
	disabled = active

	if disabled != previous_value:
		if disabled:
			remove_from_group("buttons")
			add_to_group("disabled_buttons")
		else:
			remove_from_group("disabled_buttons")
			add_to_group("buttons")
			
		GroupManager.buttons_group_updated.emit()
		GroupManager.disabled_buttons_group_updated.emit()
