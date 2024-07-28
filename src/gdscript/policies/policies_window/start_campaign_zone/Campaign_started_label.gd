extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_voted.connect(_on_policy_voted)
	

func _on_policy_voted(vote_passed: bool):
	visible = PolicyManager.last_policy_clicked.is_campaign()
