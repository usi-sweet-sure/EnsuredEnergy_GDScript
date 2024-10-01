extends Label


func _on_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.current_upgrade) + "/" + str(metrics.max_upgrade)
