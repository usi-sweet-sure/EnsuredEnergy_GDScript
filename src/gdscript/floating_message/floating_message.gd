@tool
extends Label

@export_enum("NONE", "ERROR") var play_sound = "ERROR"

@onready var animation_player = $AnimationPlayer
@onready var error = $Error



func _ready():
	set_self_modulate(Color(1, 1, 1, 1))
	
	if Engine.is_editor_hint():
		show()
	else:
		hide()


func float_up():
	if play_sound == "ERROR":
		error.stop()
		error.play()
		
	animation_player.play("float_up")


func float_down():
	if play_sound == "ERROR":
		error.stop()
		error.play()
		
	animation_player.play("float_down")
	
	
func stop():
	animation_player.stop()
