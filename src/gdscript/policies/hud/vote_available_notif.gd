extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.next_turn.connect(_on_next_turn)
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_policy_voted(_passed: bool):
	hide()


func _on_next_turn():
	show()
