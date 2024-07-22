extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock: Shock):
	if shock._are_requirements_to_absorb_shock_met():
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector2(size.x - 15, position.y), 0.4)


func _on_continue_buttton_pressed():
	position.x = -10
