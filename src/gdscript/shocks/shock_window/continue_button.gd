extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock: Shock):
	visible = shock.player_reactions.size() == 0


func _on_reaction_button1_pressed():
	show()


func _on_reaction_button2_pressed():
	show()
	
	
func _on_reaction_button3_pressed():
	show()
