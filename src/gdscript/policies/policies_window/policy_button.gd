extends TextureButton

# Each policy added in policy_manager.gd have an inspector id corresponding to one of
# the values below, making it easy to assign a policy to a policy button
# Energy campaigns buttons are treated as policy buttons, they just don't need a vote
@export_enum("ENVIRONMENTAL CAMPAIGN", "ENERGY CAMPAIGN", "ENABLE ALPINE SOLAR PV",
	"FAST TRACK WIND PARKS", "WIND PARKS REGULATION", "MANDATORY BUILDING INSULATION",
	"INDUSTRY SUBSIDY") var policy: String


func _on_pressed():
	PolicyManager.policy_button_clicked.emit(policy)
