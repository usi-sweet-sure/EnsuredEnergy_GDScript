extends CheckButton


func _on_metrics_updated(metrics: PowerplantMetrics):
	disabled = not metrics.can_activate
	set_pressed_no_signal(metrics.active)
