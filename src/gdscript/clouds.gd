extends CanvasLayer

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var parallax_background_2: ParallaxBackground = $ParallaxBackground2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_player: AnimationPlayer = $SoundPlayer

func _ready() -> void:
	_hide()
	Gameloop.toggle_settings.connect(_toggle_clouds.bind(1))
		
		
func _toggle_clouds(toggled: bool, ambience: int):
	if toggled:
		animation_player.play("clouds_appear")
		sound_player.play("play_ambience_" + str(ambience))
	else:
		animation_player.play("clouds_go_away")
		sound_player.play("stop_ambience_" + str(ambience))
		
		
func _hide():
	hide()
	parallax_background.hide()
	parallax_background_2.hide()
