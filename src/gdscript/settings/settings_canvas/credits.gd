extends CanvasLayer

func _ready():
	Gameloop.toggle_credits.connect(_on_toggle_credits)
	
	
func _on_toggle_credits():
	visible = not visible


func _on_close_button_pressed():
	_on_toggle_credits()


func _on_backdrop_button_pressed():
	_on_toggle_credits()
