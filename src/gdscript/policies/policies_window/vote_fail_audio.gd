extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_policy_voted(passed: bool):
	if not passed:
		play()
