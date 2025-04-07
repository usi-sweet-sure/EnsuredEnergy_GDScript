extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Gameloop.toggle_settings.connect(_on_toggle_settings)
	Gameloop.toggle_credits.connect(_on_toggle_credits)


func _on_toggle_settings(toggled: bool):
	if toggled:
		animation_player.play("settings_appear")
	else:
		hide()


func _on_quit_button_pressed():
	Gameloop.game_quit_requested.emit()


func _on_toggle_credits(toggled: bool) -> void:
	if visible:
		if toggled:
			animation_player.play("goes_out_left")
		else:
			# Waiting for the credits to go away
			var timer = get_tree().create_timer(0.2)
			await timer.timeout
			animation_player.play("comes_in_left")
			
			
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			Gameloop.toggle_settings.emit(true)
