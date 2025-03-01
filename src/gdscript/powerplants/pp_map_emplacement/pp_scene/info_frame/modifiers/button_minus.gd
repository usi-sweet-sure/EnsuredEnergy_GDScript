extends TextureButton
	
	
func _on_metrics_updated(metrics: PowerplantMetrics):
	visible = metrics.can_upgrade
	
	var previous_value = disabled
		
	disabled = not metrics.active
	
	if not disabled and metrics.current_upgrade == metrics.min_upgrade:
		disabled = true


	if disabled != previous_value:
		if disabled:
			mouse_filter = Control.MOUSE_FILTER_IGNORE
			remove_from_group("buttons")
			add_to_group("disabled_buttons")
		else:
			mouse_filter = Control.MOUSE_FILTER_STOP
			remove_from_group("disabled_buttons")
			add_to_group("buttons")
			
		GroupManager.buttons_group_updated.emit()
		GroupManager.disabled_buttons_group_updated.emit()
