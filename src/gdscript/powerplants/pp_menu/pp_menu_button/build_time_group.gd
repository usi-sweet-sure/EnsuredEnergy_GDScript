extends Control


func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	visible = metrics.build_time_in_turns > 0
