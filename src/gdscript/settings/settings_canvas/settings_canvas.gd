extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Gameloop.toggle_settings.connect(_on_toggle_settings)


func _on_toggle_settings():
	if visible:
		hide()
	else:
		animation_player.play("settings_appear")


func _on_quit_button_pressed():
	Gameloop.game_quit_requested.emit()
