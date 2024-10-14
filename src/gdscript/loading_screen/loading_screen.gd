extends CanvasLayer

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Gameloop.game_started.connect(_on_game_started)
	Gameloop.player_can_start_playing_first_turn.connect(_on_player_can_play_first_turn)
	
	
func _on_game_started():
	show()
	animation_player.play("loading")
	
	
func _on_player_can_play_first_turn():
	hide()
	animation_player.stop()
