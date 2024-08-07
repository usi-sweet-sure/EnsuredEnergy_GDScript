extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock: Shock):
	print(shock.player_reactions.size() == 0 || shock._are_requirements_to_absorb_shock_met())
	visible = shock.player_reactions.size() == 0 || shock._are_requirements_to_absorb_shock_met()


func _on_reaction_button1_pressed():
	show()


func _on_reaction_button2_pressed():
	show()
	
	
func _on_reaction_button3_pressed():
	show()
