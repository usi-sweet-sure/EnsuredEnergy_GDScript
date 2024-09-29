extends TextureButton


func _on_metrics_updated(metrics: PowerplantMetrics):
	var previous_value = disabled
	
	disabled = not metrics.active
	
	if not disabled and metrics.current_upgrade == metrics.max_upgrade:
		disabled = true
		
	if disabled != previous_value:
		if disabled:
			remove_from_group("buttons")
			add_to_group("disabled_buttons")
		else:
			remove_from_group("disabled_buttons")
			add_to_group("buttons")
			
		GroupManager.buttons_group_updated.emit()
		GroupManager.disabled_buttons_group_updated.emit()
