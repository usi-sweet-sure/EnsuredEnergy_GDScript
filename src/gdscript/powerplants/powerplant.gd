extends Control

class_name Powerplant

# Used to update children
signal metrics_updated(metrics: PowerplantMetrics)
signal toggle_info_frame

var metrics: PowerplantMetrics


func _ready():
	GroupManager.buttons_group_updated.emit()


func set_metrics(metrics: PowerplantMetrics):
	self.metrics = metrics.copy()
	metrics_updated.emit(self.metrics)


func activate():
	metrics.active = true
	metrics_updated.emit(metrics)
	

func deactivate():
	metrics.active = false
	metrics_updated.emit(metrics)


func _on_pp_pressed():
	toggle_info_frame.emit()
