extends Label


func _on_metrics_updated(metrics: PowerplantMetrics):
	visible = metrics.can_upgrade
	
	text = str(metrics.current_upgrade)
