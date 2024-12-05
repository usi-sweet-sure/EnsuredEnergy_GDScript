extends Control

@onready var shock_chip: TextureRect = $ShockChip
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var powerplant: PpScene = null
# Used to animate the chip going from the center of the screen to it's position
# in the pp when a shock starts affecting it
var final_global_position: Vector2
var starting_global_position = Vector2(969, 606) # Center of shock screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	ShockManager.shock_resolved.connect(_on_shock_resolved)
	powerplant = get_parent()
	final_global_position = global_position + Vector2(-32, -32)


func _on_shock_resolved(shock: Shock):
	var is_affected_by_shock = false
	
	for affected_powerplant in shock.affected_powerplants:
		if affected_powerplant.type == powerplant.metrics.type:
			is_affected_by_shock = true
			break
			
	if is_affected_by_shock:
		shock_chip.texture = load(shock.img)
		global_position = starting_global_position
		show()
	
		
		animation_player.play("appear_grow")
		await animation_player.animation_finished
		var tween = get_tree().create_tween()
		tween.tween_property(shock_chip, "global_position", final_global_position, 1) 
		animation_player.play("appear_move_to_place")
		await animation_player.animation_finished
		animation_player.play("breath")
	else:
		hide()


func _on_shock_chip_mouse_entered() -> void:
	var effect_text_key = ""
	var shock = Gameloop.most_recent_shock
	
	for affected_powerplant in shock.affected_powerplants:
		if affected_powerplant.type == powerplant.metrics.type:
			effect_text_key = affected_powerplant.text_key
			break
			
	var tooltip_text = tr(shock.title_key) + "\n" + tr(effect_text_key)
	Cursor.show_tooltip.emit(tooltip_text)
	
	
func _on_shock_chip_mouse_exited() -> void:
	Cursor.hide_tooltip.emit()
