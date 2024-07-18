extends Control


func _on_open_info_box_button_pressed():
	visible = not visible


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		hide()
