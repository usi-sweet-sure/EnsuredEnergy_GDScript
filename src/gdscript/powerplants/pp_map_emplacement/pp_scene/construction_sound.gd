extends AudioStreamPlayer

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _on_construction_sound_requested() -> void:
	animation_player.play("fade_out")
