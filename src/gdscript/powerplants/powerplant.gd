extends Node2D

class_name Powerplant

# Used to update children
signal metrics_updated(metrics: PowerplantMetrics)

var metrics: PowerplantMetrics


func set_metrics(metrics: PowerplantMetrics):
	self.metrics = metrics.copy()
	metrics_updated.emit(self.metrics)


func activate():
	metrics.active = true
	metrics_updated.emit(metrics)
	

func deactivate():
	metrics.active = false
	metrics_updated.emit(metrics)
