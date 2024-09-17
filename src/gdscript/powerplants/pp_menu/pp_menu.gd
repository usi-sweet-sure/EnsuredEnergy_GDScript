extends CanvasLayer


# Will be populated at run time when clicking on a build button
@onready var pp_buttons_container = $ColorRect/HBoxContainer
@onready var animation_player = $AnimationPlayer

var pp_button_scene = preload("res://scenes/powerplants/menu/pp_menu_button.tscn")


func _ready():
	visible = false
	PowerplantsManager.toggle_menu.connect(_on_toggle_menu)


# Hides or show the menu
func _on_toggle_menu(can_build: Array[PowerplantsManager.EngineTypeIds]):
	if visible:
		animation_player.play("slide_down")
	else:
		# Adds buttons to the menu
		for id in can_build:
			var new_pp_button = pp_button_scene.instantiate()
			pp_buttons_container.add_child(new_pp_button)
			new_pp_button.assign_powerplant(id)
		
		animation_player.play("slide_up")


# Hides the menu
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT and visible:
		animation_player.play("slide_down")


# Removes all buttons when menu is hidden
func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "slide_down":
		for n in pp_buttons_container.get_children():
			pp_buttons_container.remove_child(n)
			n.queue_free() 
