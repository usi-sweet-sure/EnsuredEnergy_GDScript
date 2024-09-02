extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.game_ended.connect(_on_game_ended)


func _on_game_ended():
	disabled = true
