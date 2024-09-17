extends Label


func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.build_time_in_turns)
