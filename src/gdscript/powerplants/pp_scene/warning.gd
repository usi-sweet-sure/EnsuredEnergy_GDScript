extends Control

@onready var warning_icon: TextureRect = $Warning
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var life_span := 0
var built_on_turn := 0


func _ready() -> void:
	hide()
	Gameloop.player_can_start_playing_new_turn.connect(_on_next_turn)
	Gameloop.player_can_start_playing_first_turn.connect(_on_next_turn)
	ShockManager.shock_resolved.connect(_on_shock_resolved)


func _on_warning_mouse_entered() -> void:
	Cursor.show_tooltip.emit(tr("PLANT_WILL_DECOMMISSION_NEXT_TURN"))


func _on_warning_mouse_exited() -> void:
	Cursor.hide_tooltip.emit()


func _on_metrics_updated(metrics: PowerplantMetrics):
	life_span = metrics.life_span_in_turns
	built_on_turn = metrics.built_on_turn
	
	
func _on_next_turn():
	_update()
	
# To play the animation after the shock screen is gone
func _on_shock_resolved(_shock: Shock):
	_update()
	
func _update():
	var shutting_down_in = life_span - (Gameloop.current_turn - built_on_turn)
	var remaining_turns = Gameloop.total_number_of_turns - Gameloop.current_turn + 1
	
	if shutting_down_in == 1:
		animation_player.play("appear")
		show()
		await animation_player.animation_finished
		animation_player.play("breath")
	else:
		hide()
		animation_player.stop()
