extends AudioStreamPlayer

var in_focus := false
var ambience_path :String = ""
@onready var ambience_fade: AnimationPlayer = $"../AmbienceFade"


func _on_pp_scene_metrics_updated(metrics: PowerplantMetrics) -> void:
	var new_ambience_path = PowerplantsManager.powerplants_ambiences[metrics.type]
	var old_ambience_path = ambience_path
	
	ambience_path = new_ambience_path
	
	if ambience_path != "" and new_ambience_path != old_ambience_path:
		stream = load(ambience_path)
		
		if in_focus:
			ambience_fade.play("fade_in")


func _on_on_show_info_frame_requested() -> void:
	in_focus = true
	ambience_fade.play("fade_in")


func _on_on_hide_info_frame_requested() -> void:
	in_focus = false
	ambience_fade.play("fade_out")


func _on_pp_scene_powerplant_deactivated(metrics: PowerplantMetrics) -> void:
	ambience_fade.play("fade_out")


func _on_pp_scene_powerplant_activated(metrics: PowerplantMetrics) -> void:
	if in_focus:
		play()
