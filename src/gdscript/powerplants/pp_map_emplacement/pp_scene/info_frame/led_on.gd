extends Sprite2D


func _on_metrics_updated(metrics: PowerplantMetrics):
	visible = metrics.active
