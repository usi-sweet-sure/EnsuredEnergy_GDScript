extends AudioStreamPlayer

var in_focus := false

func _on_pp_scene_metrics_updated(metrics: PowerplantMetrics) -> void:
	var ambience_path = PowerplantsManager.powerplants_ambiences[metrics.type]
	
	if ambience_path != "":
		stream = load(ambience_path)


func _on_on_show_info_frame_requested() -> void:
	in_focus = true
	play()


func _on_on_hide_info_frame_requested() -> void:
	in_focus = true
	stop()


func _on_pp_scene_powerplant_deactivated(metrics: PowerplantMetrics) -> void:
	stop()


func _on_pp_scene_powerplant_activated(metrics: PowerplantMetrics) -> void:
	if in_focus:
		play()
