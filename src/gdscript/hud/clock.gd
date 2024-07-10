extends Node

@onready var clock_info_sticker = $TurnInfoContainer

func clock_pressed():
	clock_info_sticker.visible = not clock_info_sticker.visible


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		clock_info_sticker.hide()
