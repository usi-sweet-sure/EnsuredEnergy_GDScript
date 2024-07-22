extends TextureButton

@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock: Shock):
	if shock.player_reactions_texts.size() >= 3:
		label.text = tr(shock.player_reactions_texts[2])


func _on_pressed():
	ShockManager.apply_reaction(2)
