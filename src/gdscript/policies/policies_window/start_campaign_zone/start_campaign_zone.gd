extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)
	PolicyManager.policy_voted.connect(_on_policy_voted)
	Gameloop.next_turn.connect(_on_next_turn)
	Gameloop.game_ended.connect(_on_game_ended)


func _on_policy_button_clicked(policy_id):
	var policy = PolicyManager.get_policy(policy_id)
	visible = policy.policy_type == Policy.PolicyType.CAMPAIGN


func _on_pressed():
	PolicyManager.vote_button_clicked.emit()


func _on_policy_voted(_vote_passed: bool):
	disabled = true


func _on_next_turn():
	disabled = false


func _on_game_ended():
	disabled = true


func _on_policy_window_opened():
	hide()
