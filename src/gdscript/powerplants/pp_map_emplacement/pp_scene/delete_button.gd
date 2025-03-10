extends TextureButton

var building = false
var metrics: PowerplantMetrics

func _on_metrics_updated(metrics_: PowerplantMetrics):
	metrics = metrics_
	if not building:
		visible = metrics_.can_delete

func _on_appear_animation_finished() -> void:
	building = false
	
	if metrics.can_delete:
		show()


func _on_pressed() -> void:
	hide()


func _on_construction_animation_requested(metrics: PowerplantMetrics) -> void:
	building = true
	hide()
