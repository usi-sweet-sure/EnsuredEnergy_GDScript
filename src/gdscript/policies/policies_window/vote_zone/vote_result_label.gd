extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_voted.connect(_on_policy_voted)
	Gameloop.next_turn.connect(_on_next_turn)
	

func _on_policy_voted(vote_passed: bool):
	if not vote_passed:
		text = tr("VOTE_FAILED")
		show()


func _on_next_turn():
	hide()
