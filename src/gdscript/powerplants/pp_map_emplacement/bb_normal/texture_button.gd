extends TextureButton

@onready var animation_player = $AnimationPlayer


func _on_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_mouse_exited():
	set_modulate(Color(1, 1, 1))


func _on_pressed():
	animation_player.play("animate_focus")
	
	
func _on_focus_entered():
	animation_player.play("animate_focus")


func _on_focus_exited():
	animation_player.stop()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		animation_player.stop()

