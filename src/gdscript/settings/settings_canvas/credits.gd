extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var opened_from_settings = false

func _ready():
	hide()
	Gameloop.toggle_credits.connect(_on_toggle_credits)
	Gameloop.toggle_settings.connect(_on_settings_toggled)
	
	
func _on_toggle_credits(toggled: bool):
	if toggled:
		# Waiting for the settings leaving animation to almost finish
		if opened_from_settings:
			var timer = get_tree().create_timer(0.2)
			await timer.timeout
		
		animation_player.play("credits_appear")
	else:
		animation_player.play("credits_go_away")


func _on_close_button_pressed():
	Gameloop.toggle_credits.emit(false)


func _on_backdrop_button_pressed():
	Gameloop.toggle_credits.emit(false)


func _on_settings_toggled(toggled: bool) -> void:
	opened_from_settings = toggled
