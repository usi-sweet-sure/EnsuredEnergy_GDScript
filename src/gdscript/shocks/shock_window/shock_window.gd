extends CanvasLayer

func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)
	
	
func _on_most_recent_shock_updated(shock):
	if(shock.show_shock_window):
		show()


func _on_continue_button_pressed():
	hide()
