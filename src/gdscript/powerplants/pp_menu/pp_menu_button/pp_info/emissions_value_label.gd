extends Label




func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.emissions).pad_decimals(2) + "Mt CO2"
