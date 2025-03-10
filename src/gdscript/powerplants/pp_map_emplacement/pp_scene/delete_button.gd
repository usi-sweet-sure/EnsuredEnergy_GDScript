extends TextureButton

var building = false

func _on_metrics_updated(metrics: PowerplantMetrics):
	if not building:
		visible = metrics.can_delete


func _on_construction_appear_requested() -> void:
	building = true
	hide()


func _on_appear_animation_finished() -> void:
	building = false
	show()
