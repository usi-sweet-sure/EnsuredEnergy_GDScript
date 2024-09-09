extends CanvasLayer

func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)
	
	
func _on_most_recent_shock_updated(shock):
	if shock != null:
		if(shock.show_shock_window):
			show()


func _on_continue_button_pressed():
	hide()
	
	ShockManager.shock_resolved.emit(Gameloop.most_recent_shock)
	
	if Gameloop.current_turn == 2:
		Gameloop.enable_graphs_button.emit()
