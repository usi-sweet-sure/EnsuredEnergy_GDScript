extends TextureButton

# Each policy added in policy_manager.gd have an inspector id corresponding to one of
# the values below, making it easy to assign a policy to a policy button
# Energy campaigns buttons are treated as policy buttons, they just don't need a vote
@export_enum("ENVIRONMENTAL CAMPAIGN", "ENERGY CAMPAIGN", "ENABLE ALPINE SOLAR PV",
	"FAST TRACK WIND PARKS", "WIND PARKS REGULATION", "MANDATORY BUILDING INSULATION",
	"INDUSTRY SUBSIDY") var policy: String
	
@onready var thumbs_up = $ThumbsUp

	
func _ready():
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_pressed():
	PolicyManager.policy_button_clicked.emit(policy)


func _on_policy_voted(vote_passed: bool):
	if not disabled:
		var was_the_voted_policy = PolicyManager.last_policy_clicked.inspector_id == policy
		var is_campaign = PolicyManager.last_policy_clicked.policy_type == Policy.PolicyType.CAMPAIGN
		var disable = vote_passed and was_the_voted_policy and not is_campaign
		if disable:
			disabled = true
			texture_normal = texture_pressed
			thumbs_up.show()
