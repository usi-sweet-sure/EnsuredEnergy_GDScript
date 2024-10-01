extends TextureButton

signal powerplant_cancel_construction_requested(metrics: PowerplantMetrics)
signal powerplant_construction_ended(metrics: PowerplantMetrics)
signal metrics_updated(metrics: PowerplantMetrics)
signal show_info_frame
signal hide_info_frame

# Used to detect a drag
var mouse_position_on_press: Vector2
# Sometimes when we click we move the mouse event if we didn't want to,
# so we use a tolerance were a drag will not be triggered and a normal click will
# be detected
var drag_tolerance = Vector2(5.0, 5.0)
var metrics: PowerplantMetrics


func _ready():
	PowerplantsManager.build_button_normal_toggled.connect(_on_build_button_normal_toggled)
	PowerplantsManager.build_button_in_construction_toggled.connect(_on_build_button_in_construction_toggled)
	PowerplantsManager.pp_scene_toggled.connect(_on_pp_scene_toggled)
	PowerplantsManager.carbon_sequestration_toggled.connect(_on_carbon_sequestration_toggled)

	
func set_metrics(metrics_to_copy: PowerplantMetrics):
	metrics = metrics_to_copy.copy()
	Gameloop.next_turn.connect(_on_next_turn)
	metrics_updated.emit(metrics)
	
	
func _on_next_turn():
	metrics.can_delete = false
	metrics_updated.emit(metrics)
	
	if metrics.construction_started_on_turn + metrics.build_time_in_turns == Gameloop.current_turn:
		powerplant_construction_ended.emit(metrics)
		hide()
	
	
func _on_mouse_entered():
	set_self_modulate(Color(1.1, 1.1, 1.1))


func _on_mouse_exited():
	set_self_modulate(Color(1, 1, 1))


func _on_close_button_mouse_entered():
	set_self_modulate(Color(1.1, 1.1, 1.1))


func _on_close_button_mouse_exited():
	set_self_modulate(Color(1, 1, 1))


func _on_close_button_pressed():
	Gameloop.next_turn.disconnect(_on_next_turn)
	powerplant_cancel_construction_requested.emit(metrics)
	hide_info_frame.emit()
	

func _on_toggled(toggled_on: bool):
	if toggled_on:
		material.set_shader_parameter("show", true)
		show_info_frame.emit()
	else:
		material.set_shader_parameter("show", false)
		hide_info_frame.emit()
		
		
func _on_focus_entered():
	material.set_shader_parameter("show", true)


func _on_focus_exited():
	material.set_shader_parameter("show", false)


# Triggers the lost of focus.
# We lose focus when we click outside of the button, but we don't want to loose focus
# when we drag.
func _unhandled_input(event):
	# Mouse press
	if event is InputEventMouseButton and event.button_mask == 1:
		mouse_position_on_press = event.position

	# Mouse release
	if event is InputEventMouseButton and event.button_mask == 0:
		if not mouse_position_on_press - drag_tolerance >= event.position and not mouse_position_on_press + drag_tolerance <= event.position:
			PowerplantsManager.hide_build_menu.emit()
			set_pressed_no_signal(false)
			material.set_shader_parameter("show", false)
			hide_info_frame.emit()
			

func _on_build_button_normal_toggled(toggled_on: bool, map_emplacement: Node2D, can_build: Array[PowerplantsManager.EngineTypeIds]):
	set_pressed_no_signal(false)
	material.set_shader_parameter("show", false)
	hide_info_frame.emit()


func _on_build_button_in_construction_toggled(toggled_on: bool, map_emplacement: Node2D):
	if toggled_on and map_emplacement.get_node("BbInConstruction") != self:
		set_pressed_no_signal(false)
		material.set_shader_parameter("show", false)
		hide_info_frame.emit()
	

func _on_pp_scene_toggled(_toggled_on: bool, pp_scene: PpScene):
	set_pressed_no_signal(false)
	material.set_shader_parameter("show", false)
	hide_info_frame.emit()


func _on_carbon_sequestration_toggled(_toggled_on: bool):
	set_pressed_no_signal(false)
	material.set_shader_parameter("show", false)
	hide_info_frame.emit()
