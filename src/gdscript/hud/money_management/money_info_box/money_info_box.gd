extends Control

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func _ready() -> void:
	hide()


func _on_toggle_money_info_box_button_pressed():
	if not visible:
		animation_player.play("info_frame_appears")
	else:
		animation_player.play("info_frame_goes_away")


func _on_close_button_pressed() -> void:
	animation_player.play("info_frame_goes_away")
