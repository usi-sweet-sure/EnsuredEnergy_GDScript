extends Control

@onready var text = $Text


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)
	

func _on_policy_button_clicked(policy_id: String):
	var policy: Policy = PolicyManager.get_policy(policy_id)
	var effects_text = ""
	
	for effect_text: String in policy.effects_texts:
		effects_text += tr(effect_text) + "\n"
	
	text.text = effects_text
	show()
