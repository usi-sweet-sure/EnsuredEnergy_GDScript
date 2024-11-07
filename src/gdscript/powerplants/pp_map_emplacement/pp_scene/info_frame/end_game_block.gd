extends ColorRect


func _ready() -> void:
	hide()
	Gameloop.game_ended.connect(_on_game_ended)


func _on_game_ended() -> void:
	show()
