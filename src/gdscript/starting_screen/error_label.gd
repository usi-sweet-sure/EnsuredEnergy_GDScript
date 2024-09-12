extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func _on_play_clicked_when_disabled():
	show()


func _on_player_name_text_changed(new_text: String):
	visible = new_text.length() == 0
