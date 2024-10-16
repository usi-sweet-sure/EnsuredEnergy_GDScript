extends TextureButton

# Each policy added in policy_manager.gd have an inspector id corresponding to one of
# the values below, making it easy to assign a policy to a policy button
# Energy campaigns buttons are treated as policy buttons, they just don't need a vote
@export_enum("ENVIRONMENTAL CAMPAIGN", "ENERGY CAMPAIGN", "ENABLE ALPINE SOLAR PV",
	"FAST TRACK WIND PARKS", "WIND PARKS REGULATION", "MANDATORY BUILDING INSULATION",
	"INDUSTRY SUBSIDY") var policy: String
@export_enum("LEFT", "RIGHT") var side: String
	
@onready var thumbs_up = $ThumbsUp
@onready var thumbs_down = $ThumbsDown
@onready var animation_player = $AnimationPlayer


func _ready():
	if side == "LEFT":
		thumbs_up.position = Vector2(102, 29)
		thumbs_down.position = Vector2(102, 29)
		thumbs_up.flip_h = false
		thumbs_down.flip_h = true
	else:
		thumbs_up.position = Vector2(24, 29)
		thumbs_down.position = Vector2(24, 29)
		thumbs_up.flip_h = true
		thumbs_down.flip_h = false
		
	thumbs_up.visible = false
	thumbs_down.visible = false
	PolicyManager.policy_voted.connect(_on_policy_voted)
	Gameloop.next_turn.connect(_on_next_turn)
	

func _on_next_turn():
	thumbs_down.hide()


func _on_policy_voted(vote_passed: bool):
	var was_the_voted_policy = PolicyManager.last_policy_clicked.inspector_id == policy
	var is_campaign = PolicyManager.last_policy_clicked.policy_type == Policy.PolicyType.CAMPAIGN
	
	if vote_passed and not is_campaign and was_the_voted_policy:
		%AnimationPlayer.play("Vote_yes")
		await %AnimationPlayer.animation_finished
		if side == "LEFT":
			animation_player.play("show_left_thumbs_up")
		else:
			animation_player.play("show_right_thumbs_up")
	elif not vote_passed and not is_campaign and was_the_voted_policy:
		%AnimationPlayer.play("Vote_no")
		await %AnimationPlayer.animation_finished
		if side == "LEFT":
			animation_player.play("show_left_thumbs_down")
		else:
			animation_player.play("show_right_thumbs_down")
			
	# Disables campaign buttons if the limit of passed campaigns is reached
	var all_voted_policies = PolicyManager.voted_policies
	var number_of_passed_env_campaign = 0
	var number_of_passed_energy_campaign = 0
	
	for voted_policy in all_voted_policies:
		var pol: Policy = voted_policy.policy
		var passed = voted_policy.passed
		
		if pol.inspector_id == "ENVIRONMENTAL CAMPAIGN" and passed:
			number_of_passed_env_campaign += 1
	
		if pol.inspector_id == "ENERGY CAMPAIGN" and passed:
			number_of_passed_energy_campaign += 1
	
	if policy == "ENVIRONMENTAL CAMPAIGN" and number_of_passed_env_campaign >= 2:
		disabled = true
	
	if policy == "ENERGY CAMPAIGN" and number_of_passed_energy_campaign >= 2:
		disabled = true
		

func _on_toggled(toggled_on: bool):
	if toggled_on:
		PolicyManager.policy_button_clicked.emit(policy)
	else:
		PolicyManager.policy_button_unclicked.emit()
