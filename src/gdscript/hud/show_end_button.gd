extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Gameloop.game_ended.connect(_on_game_ended)


func _on_game_ended() -> void:
	show()


func _on_pressed() -> void:
	Gameloop.show_ending_screen_requested.emit()
