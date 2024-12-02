extends ColorRect


func _on_metrics_updated(metrics: PowerplantMetrics):
	visible = not metrics.can_activate
