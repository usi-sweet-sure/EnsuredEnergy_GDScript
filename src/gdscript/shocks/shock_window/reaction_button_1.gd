extends TextureButton

@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock: Shock):
	if shock != null:
		if shock.player_reactions_texts.size() >= 1  && not shock._are_requirements_to_absorb_shock_met():
			show()
			label.text = tr(shock.player_reactions_texts[0])
		else:
			hide()

func _on_pressed():
	ShockManager.apply_reaction(0)
