extends TextureRect


func _on_powerplant_metrics_updated(metrics:PowerplantMetrics):
	var image = PowerplantsManager.powerplants_textures_neon[metrics.type]
	texture = load(image)

