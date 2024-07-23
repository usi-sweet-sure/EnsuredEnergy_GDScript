extends Sprite2D


func _on_credits_button_pressed():
	show()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		hide()
