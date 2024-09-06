extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)


func _on_policy_window_opened():
	text = "[center][font_size=25]" + tr("POLICIES_EXPLANATION_CAMPAIGNS_TITLE") + "[/font_size]\n" + tr("POLICIES_EXPLANATION_CAMPAIGNS_TEXT") + "\n\n[font_size=25]" + tr("POLICIES_EXPLANATION_POLICIES_TITLE") + "[/font_size]\n" + tr("POLICIES_EXPLANATION_POLICIES_TEXT") + "[/center]"
	show()


func _on_policy_button_clicked(policy_id: String):
	var policy: Policy = PolicyManager.get_policy(policy_id)
	var effects_text = ""
	
	for effect_text: String in policy.effects_texts:
		effects_text += tr(effect_text) + "\n"
	
	text = "[center][font_size=24]" + tr(policy.title_key) + "[/font_size]\n" + tr(policy.text_key) + "\n\n[font_size=22]" + tr("EFFECT") + "[/font_size]\n" + effects_text + "[/center]"
