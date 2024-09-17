extends TextureRect


func _on_powerplant_metrics_updated(metrics:PowerplantMetrics):
	var texture_name = "res://assets/used_assets/textures/powerplants/pp_sprite_neon_" + PowerplantsManager.EngineTypeIds.keys()[metrics.type].to_lower() + ".png"
	texture = load(texture_name)
