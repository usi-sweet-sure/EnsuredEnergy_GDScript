extends Control

class_name PpScene

# Used to update children
signal metrics_updated(metrics: PowerplantMetrics)
signal show_info_frame
signal hide_info_frame
signal powerplant_delete_requested
signal texture_on_changed(image: Image)
signal texture_off_changed(image: Image)

var metrics: PowerplantMetrics

func _ready():
	GroupManager.buttons_group_updated.emit()
	GroupManager.switches_group_updated.emit()


func set_metrics(metrics: PowerplantMetrics):
	self.metrics = metrics.copy()
	texture_on_changed.emit(PowerplantsManager.powerplants_textures_on[metrics.type])
	texture_off_changed.emit(PowerplantsManager.powerplants_textures_off[metrics.type])
	metrics_updated.emit(self.metrics)


func activate():
	metrics.active = true
	metrics_updated.emit(metrics)
	

func deactivate():
	metrics.active = false
	metrics_updated.emit(metrics)


func _on_close_button_pressed():
	powerplant_delete_requested.emit()


func _on_pp_focus_exited():
	hide_info_frame.emit()


func _on_pp_toggled(toggled_on: bool):
	PowerplantsManager.pp_scene_toggled.emit(toggled_on, self)
	

func _on_pp_hide_info_frame_requested():
	hide_info_frame.emit()


func _on_pp_show_info_frame_requested():
	show_info_frame.emit()


func _on_switch_toggled(toggled_on: bool):
	metrics.active = toggled_on
	metrics_updated.emit(metrics)
