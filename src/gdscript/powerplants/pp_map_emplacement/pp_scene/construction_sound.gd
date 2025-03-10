extends AudioStreamPlayer

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func _on_construction_animation_requested(metrics: PowerplantMetrics) -> void:
	animation_player.play("fade_out")
