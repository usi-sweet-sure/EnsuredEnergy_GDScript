extends Sprite2D


func _on_ready():
	Gameloop.toggle_settings.connect(_on_toggle_settings)
	
	
func _on_credits_button_pressed():
	show()
	
	
func _on_toggle_settings():
	hide()
