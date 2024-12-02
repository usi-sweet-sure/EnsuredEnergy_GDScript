extends Control


func _on_metrics_updated(metrics: PowerplantMetrics):
	visible = metrics.can_upgrade
