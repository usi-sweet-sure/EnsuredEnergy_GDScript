extends Control

@onready var shock_chip: TextureRect = $ShockChip
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var powerplant: PpScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Gameloop.player_can_start_playing_new_turn.connect(_on_new_turn)
	powerplant = get_parent()


func _on_new_turn():
	var most_recent_shock = Gameloop.most_recent_shock
	
	if most_recent_shock != null:
		var is_affected_by_shock = false
		
		for affected_powerplant in most_recent_shock.affected_powerplants:
			if affected_powerplant.type == powerplant.metrics.type:
				is_affected_by_shock = true
				break
				
		if is_affected_by_shock:
			shock_chip.texture = load(most_recent_shock.img)		
			show()
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
