extends TextureButton


signal show_info_frame_requested
signal hide_info_frame_requested

# Used to detect a drag
var mouse_position_on_press: Vector2
# Sometimes when we click we move the mouse event if we didn't want to,
# so we use a tolerance were a drag will not be triggered and a normal click will
# be detected
var drag_tolerance = Vector2(5.0, 5.0)


func _ready():
	PowerplantsManager.build_button_normal_toggled.connect(_on_build_button_toggled)
	PowerplantsManager.build_button_in_construction_toggled.connect(_on_build_button_in_construction_toggled)
	PowerplantsManager.pp_scene_toggled.connect(_on_pp_scene_toggled)


func _on_toggled(toggled_on: bool):
	if toggled_on:
		material.set_shader_parameter("show", true)
		show_info_frame_requested.emit()
	else:
		material.set_shader_parameter("show", false)
		hide_info_frame_requested.emit()
	
	PowerplantsManager.carbon_sequestration_toggled.emit(toggled_on)
	

func _on_build_button_toggled(toggled_on: bool, map_emplacement: Node, can_build: Array[PowerplantsManager.EngineTypeIds]):
	material.set_shader_parameter("show", false)
	set_pressed_no_signal(false)
	hide_info_frame_requested.emit()
	
	
func _on_build_button_in_construction_toggled(toggled_on: bool, map_emplacement: Node2D):
	material.set_shader_parameter("show", false)
	set_pressed_no_signal(false)
	hide_info_frame_requested.emit()
	
	
func _on_pp_scene_toggled(_toggled_on: bool, _pp_scene: PpScene):
	material.set_shader_parameter("show", false)
	set_pressed_no_signal(false)
	hide_info_frame_requested.emit()


# We lose focus when we click outside of the pp, but we don't want to loose focus
# when we drag.
func _unhandled_input(event):
	# Mouse press
	if event is InputEventMouseButton and event.button_mask == 1:
		mouse_position_on_press = event.position

	# Mouse release
	if event is InputEventMouseButton and event.button_mask == 0:
		if not mouse_position_on_press - drag_tolerance >= event.position and not mouse_position_on_press + drag_tolerance <= event.position:
			material.set_shader_parameter("show", false)
			set_pressed_no_signal(false)
			hide_info_frame_requested.emit()


func _on_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_mouse_exited():
	set_modulate(Color(1, 1, 1))
