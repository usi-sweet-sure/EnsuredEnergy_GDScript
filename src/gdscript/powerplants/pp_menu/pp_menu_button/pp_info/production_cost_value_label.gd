extends Label


func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.production_costs).pad_decimals(2) + "M CHF"
