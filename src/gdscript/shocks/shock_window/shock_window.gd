extends CanvasLayer

func _ready():
	Gameloop.player_can_start_playing_new_turn.connect(_on_player_can_start_playing_new_turn)
	
	
func _on_player_can_start_playing_new_turn():
	if Gameloop.most_recent_shock != null && Gameloop.most_recent_shock.show_shock_window:
		show()
		CameraManager.block_camera.emit()


func _on_continue_button_pressed():
	CameraManager.unlock_camera.emit()
	hide()
	
	ShockManager.shock_resolved.emit(Gameloop.most_recent_shock)
	
	if Gameloop.current_turn == 2:
		Gameloop.enable_graphs_button.emit()
