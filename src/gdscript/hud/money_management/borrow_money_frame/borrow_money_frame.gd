extends Control

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		hide()
	

func _on_toggle_borrow_money_frame_button_pressed():
	visible = not visible


func _on_close_button_pressed():
	hide()
