extends Control

class_name Powerplant

# Used to update children
signal metrics_updated(metrics: PowerplantMetrics)
signal toggle_info_frame
signal powerplant_delete_requested

var metrics: PowerplantMetrics


func _ready():
	GroupManager.buttons_group_updated.emit()
	GroupManager.switches_group_updated.emit()

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


func _on_close_button_pressed():
	powerplant_delete_requested.emit()
