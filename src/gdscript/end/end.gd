extends CanvasLayer


func _ready():
	Gameloop.show_ending_screen_requested.connect(_on_show_ending_screen)
	
	
func _on_show_ending_screen():
	show()


func _on_close_button_pressed():
	hide()
