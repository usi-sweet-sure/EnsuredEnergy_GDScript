extends Sprite2D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func _on_next_turn_gui_input(event: InputEvent) -> void:
	if (
			event is InputEventMouseButton
			and event.button_mask == MOUSE_BUTTON_MASK_LEFT
			and not Gameloop._check_supply()
		):
		animation_player.play("not_enough_energy_warning")
