extends CanvasLayer

@onready var explanation = $Control/CenterFrame/Explanation
@onready var policy_description = $Control/CenterFrame/Description
@onready var policy_effect = $Control/CenterFrame/Effect
@onready var vote_zone = $Control/CenterFrame/Vote
@onready var start_campaign_zone = $Control/CenterFrame/StartCampaign


@onready var policy_buttons: Array[TextureButton] = [
	$Control/LeftFrame/campaign_env,
	$Control/LeftFrame/Upgrade_PV,
	$Control/LeftFrame/Wind_buildtime,
	$Control/LeftFrame/Upgrade_wind,
	$Control/RightFrame/campaign_demand,
	$Control/RightFrame/home_regulation,
	$Control/RightFrame/industry_subsidy,
]


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)


func _on_open_policies_window_button_pressed():
	explanation.show()
	policy_description.hide()
	policy_effect.hide()
	vote_zone.hide()
	start_campaign_zone.hide()
	
	# Buttons stay pressed when closing the window, so we unpress them
	for button in policy_buttons:
		if not button.disabled:
			button.button_pressed = false
	
	show()
	

func _on_policy_button_clicked(policy_id):
	explanation.hide()


func _on_backdrop_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		hide()
