extends CanvasLayer


# Will be populated at run time when clicking on a "bb_normal" on the map
@onready var pp_buttons_container = $ColorRect/HBoxContainer
@onready var animation_player = $AnimationPlayer

var pp_button_scene = preload("res://scenes/powerplants/menu/pp_menu_button.tscn")
var previous_emplacement_pressed = null

func _ready():
	visible = false
	PowerplantsManager.map_emplacement_pressed.connect(_on_map_emplacement_pressed)
	PowerplantsManager.powerplant_build_requested.connect(_on_build_requested)


# Hides or show the menu
func _on_map_emplacement_pressed(target_map_emplacement: Node2D, can_build: Array[PowerplantsManager.EngineTypeIds]):
	# If the same emplacement is clicked, whe close the menu
	if previous_emplacement_pressed != null and previous_emplacement_pressed == target_map_emplacement:
		animation_player.play("slide_down")
	else:
		for n in pp_buttons_container.get_children():
				pp_buttons_container.remove_child(n)
				n.queue_free() 

		if not visible:
			animation_player.play("slide_up")

		# Adds buttons to the menu
		for id in can_build:
			var new_pp_button = pp_button_scene.instantiate()
			pp_buttons_container.add_child(new_pp_button)
			new_pp_button.assign_powerplant(id, target_map_emplacement)
	
	previous_emplacement_pressed = target_map_emplacement


# Hides the menu
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT and visible:
		animation_player.play("slide_down")


func _on_build_requested(_target_node: Node, _metrics: PowerplantMetrics):
	animation_player.play("slide_down")
	
	
# Removes all buttons when menu is hidden
func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "slide_down":
		previous_emplacement_pressed = null
		for n in pp_buttons_container.get_children():
			pp_buttons_container.remove_child(n)
			n.queue_free()
