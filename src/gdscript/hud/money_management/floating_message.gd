extends Control


@onready var floating_message = $FloatingMessage

var player_can_start_playing_first_turn = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.player_can_start_playing_first_turn.connect(_on_player_can_start_playing_first_turn)
	Gameloop.available_money_message_requested.connect(_on_message_requested)


func _change_text_to_green():
	floating_message.set("theme_override_colors/font_color", Color(0,0.882,0))
	

func _change_text_to_red():
	floating_message.set("theme_override_colors/font_color", Color(1.0, 0.129, 0.208))


func _on_message_requested(message: String, positiv: bool):
	if player_can_start_playing_first_turn:
		floating_message.text = message
		if positiv:
			_change_text_to_green()
			floating_message.stop()
			floating_message.float_up()
		else:
			_change_text_to_red()
			floating_message.stop()
			floating_message.float_down()


func _on_player_can_start_playing_first_turn():
	player_can_start_playing_first_turn = true
