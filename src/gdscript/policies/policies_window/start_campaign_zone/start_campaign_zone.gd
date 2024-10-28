extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)
	PolicyManager.policy_voted.connect(_on_policy_voted)
	Gameloop.next_turn.connect(_on_next_turn)
	Gameloop.game_ended.connect(_on_game_ended)
	

func _on_policy_button_clicked(policy_id: String):
	var policy = PolicyManager.get_policy(policy_id)
	visible = policy.policy_type == Policy.PolicyType.CAMPAIGN


func _on_pressed():
	PolicyManager.vote_button_clicked.emit()


func _on_policy_voted(_vote_passed: bool):
	disabled = true
	_change_button_group()


func _on_next_turn():
	disabled = false
	_change_button_group()


func _on_game_ended():
	disabled = true
	_change_button_group()


func _on_policy_window_opened():
	hide()


func _change_button_group():
	if disabled:
		remove_from_group("buttons")
		add_to_group("disabled_buttons")
	else:
		remove_from_group("disabled_buttons")
		add_to_group("buttons")
		
	GroupManager.buttons_group_updated.emit()
	GroupManager.disabled_buttons_group_updated.emit()
