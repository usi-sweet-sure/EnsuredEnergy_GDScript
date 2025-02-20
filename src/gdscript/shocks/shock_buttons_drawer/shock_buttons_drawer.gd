extends Control

var shock_button_scene = preload("res://scenes/hud/shock_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ShockManager.shock_resolved.connect(_on_shock_resolved)
	ShockManager.toggle_shock_buttons.connect(_on_toggle_shock_buttons)


func _on_shock_resolved(shock: Shock):
	var shock_button = shock_button_scene.instantiate()
	shock_button.shock = shock
	shock_button.hide()
	add_child(shock_button)
	
	#Moves button from center to it's position
	var final_position = shock_button.global_position
	var starting_position = get_viewport_rect().size / 2 # Center of screen
	shock_button.global_position = starting_position
	shock_button.show()
	var texture = shock_button.get_node("TextureButton")
	var tween = get_tree().create_tween()
	tween.tween_property(texture, "scale", Vector2(1.5, 1.5), 0.15)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(texture, "scale", Vector2(1.3, 1.3), 0.15)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(texture, "scale", Vector2(1.5, 1.5), 0.1)
	await tween.finished
	tween = get_tree().create_tween()
	tween.parallel().tween_property(texture, "scale", Vector2(1, 1), 0.75)
	tween.parallel().tween_property(shock_button, "global_position", final_position, 0.6)
	await tween.finished
	ShockManager.shock_button_in_place.emit(shock)

func _on_toggle_shock_buttons(toggle: bool):
	var direction = 1
	
	if not toggle:
		direction = -1
		
	var shock_buttons = get_children()
	shock_buttons.reverse()
	shock_buttons.pop_front()
	var index = 1
	
	var space_below_top_button = 20
	var space_between_buttons = 5
	
	for button in shock_buttons:
		var actual_button = button.get_button()
		var new_y = button.spawn_position.y
		
		if direction == 1:
			new_y = space_below_top_button + button.spawn_position.y + (index * (actual_button.size.y + space_between_buttons)) * direction
		var tween = get_tree().create_tween()
		tween.tween_property(button, "position", Vector2(button.spawn_position.x, new_y), 0.15)
		index += 1
