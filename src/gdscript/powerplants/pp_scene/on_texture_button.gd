extends TextureButton

# Used to detect a drag
var mouse_position_on_press: Vector2
# Sometimes when we click we move the mouse event if we didn't want to,
# so we use a tolerance were a drag will not be triggered and a normal click will
# be detected
var drag_tolerance = Vector2(5.0, 5.0)

signal hide_info_frame_requested
signal show_info_frame_requested


func _ready():
	PowerplantsManager.build_button_normal_toggled.connect(_on_build_button_toggled)
	PowerplantsManager.build_button_in_construction_toggled.connect(_on_build_button_in_construction_toggled)
	PowerplantsManager.pp_scene_toggled.connect(_on_pp_scene_toggled)
	PowerplantsManager.carbon_sequestration_toggled.connect(_on_carbon_sequestration_toggled)
	

func _on_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_mouse_exited():
	set_modulate(Color(1, 1, 1))


func _on_close_button_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_close_button_mouse_exited():
	set_modulate(Color(1, 1, 1))


func _on_pp_scene_texture_on_changed(texture: Texture):
	texture_normal = texture
	
	# Get the image from the texture normal
	var image = texture_normal.get_image()
	# Create the BitMap
	var bitmap = BitMap.new()
	# Fill it from the image alpha
	bitmap.create_from_image_alpha(image)
	# Assign it to the mask
	texture_click_mask = bitmap


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


func _on_build_button_toggled(_toggled_on: bool, _map_emplacement: Node, _can_build: Array[PowerplantsManager.EngineTypeIds]):
	material.set_shader_parameter("show", false)
	set_pressed_no_signal(false)
	hide_info_frame_requested.emit()


func _on_toggled(toggled_on: bool):
	if toggled_on:
		material.set_shader_parameter("show", true)
		show_info_frame_requested.emit()
	else:
		material.set_shader_parameter("show", false)
		hide_info_frame_requested.emit()


func _on_pp_scene_toggled(_toggled_on: bool, pp_scene: PpScene):
	if pp_scene.get_node("On") != self:
		material.set_shader_parameter("show", false)
		set_pressed_no_signal(false)
		hide_info_frame_requested.emit()


func _on_build_button_in_construction_toggled(_toggled_on: bool, _map_emplacement: Node2D):
	material.set_shader_parameter("show", false)
	set_pressed_no_signal(false)
	hide_info_frame_requested.emit()


func _on_switch_toggled(toggled_on: bool):
	material.set_shader_parameter("show", toggled_on)
	set_pressed_no_signal(toggled_on)


func _on_metrics_updated(metrics: PowerplantMetrics):
	visible = metrics.active


func _on_carbon_sequestration_toggled(_toggled_on: bool):
	material.set_shader_parameter("show", false)
	set_pressed_no_signal(false)
	hide_info_frame_requested.emit()
