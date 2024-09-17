extends Label


func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.availability.x * metrics.capacity).pad_decimals(0)
