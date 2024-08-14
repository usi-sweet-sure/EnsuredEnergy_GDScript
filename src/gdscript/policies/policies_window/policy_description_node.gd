extends Control

@onready var title = $Title
@onready var text = $Text



# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)
	

func _on_policy_button_clicked(policy_id: String):
	var policy: Policy = PolicyManager.get_policy(policy_id)
	title.text = tr(policy.title_key)
	text.text = tr(policy.text_key)
	show()
