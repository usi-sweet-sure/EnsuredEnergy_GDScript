extends TextureRect


func _on_metrics_updated(metrics):
	var image = PowerplantsManager.powerplants_textures_neon[metrics.type]
	texture = load(image)
