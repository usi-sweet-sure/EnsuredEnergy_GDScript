extends Node2D

@export var message: String
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_pannel_mouse_entered() -> void:
	animation_player.play("rock")
	Cursor.show_tooltip.emit(message)
	audio_stream_player.play()


func _on_pannel_mouse_exited() -> void:
	Cursor.hide_tooltip.emit()
