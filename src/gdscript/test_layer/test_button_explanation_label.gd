extends Label


func _ready():
	Gameloop.game_started.connect(_on_play_test_button_pressed)
	
	
func _on_play_test_button_pressed():
	hide()
