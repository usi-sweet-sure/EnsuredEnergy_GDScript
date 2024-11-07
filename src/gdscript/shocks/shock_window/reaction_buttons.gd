extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock: Shock):
	if shock != null:
		$Button/thumbs_down.hide()
		$Button2/poll_icon.hide()
		$Button3/money_icon.hide()
		if shock.player_reactions.size() > 0 && not shock._are_requirements_to_absorb_shock_met():
			show()
			if shock.player_reactions.size() > 2:
				$Button/thumbs_down.show()
				$Button2/poll_icon.show()
				$Button3/money_icon.show()


func _on_button1_pressed():
	hide()


func _on_button2_pressed():
	hide()


func _on_button3_pressed():
	hide()
