extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)


func _on_policy_button_clicked(policy_id):
	var policy = PolicyManager.get_policy(policy_id)
	visible = not policy.policy_type == Policy.PolicyType.CAMPAIGN


func _on_pressed():
	PolicyManager.vote_button_clicked.emit()
