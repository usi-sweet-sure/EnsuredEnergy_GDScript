extends LineEdit

func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)
	
	
func _on_focus_entered():
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	placeholder_text = ""


func _on_focus_exited():
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	placeholder_text = tr("PLAYER_NAME_PLACEHOLDER")


func _on_locale_updated(_locale):
	placeholder_text = tr("PLAYER_NAME_PLACEHOLDER")


func _on_play_button_clicked_when_disabled():
	if not has_focus():
		grab_focus()
