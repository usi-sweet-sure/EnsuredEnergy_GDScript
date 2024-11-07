extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_policy_button_clicked(policy_id: String):
	var policy: Policy = PolicyManager.get_policy(policy_id)
	
	if not policy.is_campaign():
		if PolicyManager.did_policy_already_passed(policy):
			hide()
		else:
			if PolicyManager.policy_voted_this_turn == null:
				show()
				text = str(policy.acceptance_probability * 100).pad_decimals(0) + "%"
				_change_text_to_green()
				set("theme_override_font_sizes/font_size", 30)
			else:
				hide()
	else:
		hide()


func _on_policy_window_opened():
	hide()


func _on_policy_voted(_vote_passed: bool):
	hide()


func _change_text_to_green():
	set("theme_override_colors/font_color", Color(0,0.882,0))
	#set("theme_override_colors/font_shadow_color", Color(1, 0.541, 0.596, 0.518))
	

func _change_text_to_red():
	set("theme_override_colors/font_color", Color(0.948, 0.489, 0.437))
	#set("theme_override_colors/font_shadow_color", Color(0.656, 0, 0.079, 0.518))
