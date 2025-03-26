extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hide()
	Gameloop.player_can_start_playing_new_turn.connect(_on_player_can_start_playing)
	Gameloop.next_turn_button_pressed.connect(func(): hide())
	

func _on_player_can_start_playing() -> void:
	if Gameloop.current_turn == Gameloop.total_number_of_turns:
		animation_player.play("appear")
