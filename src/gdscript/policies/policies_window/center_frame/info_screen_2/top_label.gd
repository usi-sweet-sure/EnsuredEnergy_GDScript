extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_policy_window_opened():
	if PolicyManager.policy_voted_this_turn != null:
		text = tr("CANNOT_VOTE_OR_START_CAMPAIGN")
		_change_text_to_red()
	else:
		text = tr("CAN_VOTE_OR_START_CAMPAIGN")
		_change_text_to_green()


func _on_policy_button_clicked(policy_id: String):
	var policy: Policy = PolicyManager.get_policy(policy_id)
	
	if not policy.is_campaign():
		if PolicyManager.did_policy_already_passed(policy):
			if PolicyManager.get_turn_of_successful_policy(policy) == Gameloop.current_turn:
				text = tr("JUST_VOTED_AND_SUCCEEDED")
			else:
				text = tr("POLICY_ALREADY_PASSED")
			
			_change_text_to_green()
		else:
			if PolicyManager.policy_voted_this_turn == null:
				text = tr("ESTIMATED_ACCEPTANCE_CHANCE")
				_change_text_to_green()
			else:
				if PolicyManager.policy_voted_this_turn.title_key == policy.title_key:
					text = tr("JUST_VOTED_AND_FAILED")
				else:
					text = tr("CANNOT_VOTE")
				
				_change_text_to_red()
	else:
		if PolicyManager.policy_voted_this_turn == null:
			text = tr("CAN_START_CAMPAIGN")
			_change_text_to_green()
		else:
			if PolicyManager.policy_voted_this_turn.title_key == policy.title_key:
				text = tr("CAMPAIGN_ONGOING")
				_change_text_to_green()
			else:
				text = tr("CANNOT_START_CAMPAIGN")
				_change_text_to_red()


func _on_policy_voted(vote_passed: bool):
	if not PolicyManager.policy_voted_this_turn.is_campaign():
		if vote_passed:
			%AnimationPlayer.play("Vote_yes")
			await %AnimationPlayer.animation_finished
			text = tr("VOTE_PASSED")
			_change_text_to_green()
		else:
			%AnimationPlayer.play("Vote_yes")
			await %AnimationPlayer.animation_finished
			text = tr("VOTE_FAILED")
			_change_text_to_red()
	else:
		text = tr("CAMPAIGN_ONGOING")
		_change_text_to_green()


func _change_text_to_green():
	set("theme_override_colors/font_color", Color(0,0.882,0))
	#set("theme_override_colors/font_shadow_color", Color(1, 0.541, 0.596, 0.518))
	

func _change_text_to_red():
	set("theme_override_colors/font_color", Color(0.948, 0.489, 0.437))
	#set("theme_override_colors/font_shadow_color", Color(0.656, 0, 0.079, 0.518))
