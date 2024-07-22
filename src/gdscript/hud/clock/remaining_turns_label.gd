extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.current_turn_updated.connect(_on_current_turn_updated)
	_on_current_turn_updated(Gameloop.current_turn)

func _on_current_turn_updated(value):
	text = str(Gameloop.total_number_of_turns - value)
