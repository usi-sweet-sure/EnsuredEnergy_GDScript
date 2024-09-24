extends Label


func _on_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.land_use).pad_decimals(2) + " ha"
