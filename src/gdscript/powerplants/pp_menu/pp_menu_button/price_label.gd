extends Label


func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.building_costs + metrics.production_costs).pad_decimals(1) + "M"
