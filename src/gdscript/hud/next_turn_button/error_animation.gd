extends AnimationPlayer


func _ready():
	Gameloop.game_ended.connect(_on_game_ended)

func _on_next_turn_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT and !Gameloop.can_go_to_next_turn():
		stop()
		play("warning")


func _on_game_ended():
	active = false
