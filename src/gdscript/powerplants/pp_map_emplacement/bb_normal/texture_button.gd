extends TextureButton

@onready var animation_player = $AnimationPlayer

# Used to detect a drag
var mouse_position_on_press: Vector2
# Sometimes when we click we move the mouse event if we didn't want to,
# so we use a tolerance were a drag will not be triggered and a normal click will
# be detected
var drag_tolerance = Vector2(5.0, 5.0)


func _ready():
	PowerplantsManager.pp_scene_toggled.connect(_on_pp_scene_toggled)
	PowerplantsManager.build_button_normal_toggled.connect(_on_build_button_normal_toggled)
	PowerplantsManager.build_button_in_construction_toggled.connect(_on_build_button_in_construction_toggled)
	PowerplantsManager.powerplant_build_requested.connect(_on_powerplant_build_requested)
	
	
func _on_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_mouse_exited():
	set_modulate(Color(1, 1, 1))


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
			animation_player.stop()


func _on_pp_scene_toggled(_toggled_on: bool, pp_scene: PpScene):
	PowerplantsManager.hide_build_menu.emit()
	set_pressed_no_signal(false)
	material.set_shader_parameter("show", false)
	animation_player.stop()
	

func _on_toggled(toggled_on: bool):
	if toggled_on:
		material.set_shader_parameter("show", true)
		animation_player.play("animate_focus")
	else:
		material.set_shader_parameter("show", false)
		animation_player.stop()
		

func _on_build_button_normal_toggled(toggled_on:bool, map_emplacement: Node, _can_build: Array[PowerplantsManager.EngineTypeIds]):
	if toggled_on and map_emplacement.get_node("BbNormal") != self:
		set_pressed_no_signal(false)
		material.set_shader_parameter("show", false)
		animation_player.stop()
	

func _on_powerplant_build_requested(map_emplacement: Node2D, metrics: PowerplantMetrics):
	if map_emplacement.get_node("BbNormal") == self:
		set_pressed_no_signal(false)
		material.set_shader_parameter("show", false)
		animation_player.stop()


func _on_build_button_in_construction_toggled(toggled_on: bool, map_emplacement: Node2D):
	PowerplantsManager.hide_build_menu.emit()
	set_pressed_no_signal(false)
	material.set_shader_parameter("show", false)
	animation_player.stop()
