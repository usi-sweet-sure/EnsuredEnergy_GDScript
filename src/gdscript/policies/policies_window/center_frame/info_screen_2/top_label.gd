extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_policy_window_opened():
	if PolicyManager.policy_voted_this_turn != null:
		text = tr("CANNOT_VOTE_OR_START_CAMPAIGN")
		set("theme_override_colors/font_color", Color(0.948, 0.489, 0.437))
		set("theme_override_colors/font_shadow_color", Color(0.656, 0, 0.079, 0.518))
	else:
		text = tr("CAN_VOTE_OR_START_CAMPAIGN")
		set("theme_override_colors/font_color", Color(0,0.882,0))
		set("theme_override_colors/font_shadow_color", Color(1, 0.541, 0.596, 0.518))


func _on_policy_button_clicked(policy_id: String):
	var policy: Policy = PolicyManager.get_policy(policy_id)
	set("theme_override_colors/font_shadow_color", Color(1, 0.541, 0.596, 0.518))
	
	if not policy.is_campaign():
		if PolicyManager.policy_already_passed(policy):
			text = tr("POLICY_ALREADY_PASSED")
			set("theme_override_colors/font_color", Color(0,0.882,0))
		else:
			if PolicyManager.policy_voted_this_turn == null:
				text = tr("ESTIMATED_ACCEPTANCE_CHANCE")
				set("theme_override_colors/font_color", Color(0,0.882,0))
			else:
				text = tr("CANNOT_VOTE")
				set("theme_override_colors/font_color", Color(0.948, 0.489, 0.437))
				set("theme_override_colors/font_shadow_color", Color(0.656, 0, 0.079, 0.518))
	else:
		if PolicyManager.policy_voted_this_turn == null:
			text = tr("CAN_START_CAMPAIGN")
			set("theme_override_colors/font_color", Color(0,0.882,0))
		else:
			text = tr("CANNOT_START_CAMPAIGN")
			set("theme_override_colors/font_color", Color(0.948, 0.489, 0.437))
			set("theme_override_colors/font_shadow_color", Color(0.656, 0, 0.079, 0.518))


func _on_policy_voted(vote_passed: bool):
	if not PolicyManager.policy_voted_this_turn.is_campaign():
		if vote_passed:
			text = tr("VOTE_PASSED")
			set("theme_override_colors/font_color", Color(0,0.882,0))
			set("theme_override_colors/font_shadow_color", Color(1, 0.541, 0.596, 0.518))
		else:
			text = tr("VOTE_DIDNT_PASSED")
			set("theme_override_colors/font_color", Color(0.948, 0.489, 0.437))
			set("theme_override_colors/font_shadow_color", Color(0.656, 0, 0.079, 0.518))
	else:
		text = tr("CAMPAIGN_ONGOING")
		set("theme_override_colors/font_color", Color(0,0.882,0))
		set("theme_override_colors/font_shadow_color", Color(1, 0.541, 0.596, 0.518))
