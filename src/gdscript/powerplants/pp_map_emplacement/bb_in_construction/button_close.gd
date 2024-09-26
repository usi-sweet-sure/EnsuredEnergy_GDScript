extends TextureButton


func _on_metrics_updated(metrics: PowerplantMetrics):
	visible = metrics.can_delete
