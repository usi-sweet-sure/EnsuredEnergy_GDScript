extends Node

var hand_press = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-Pointer-press.png")
var hand_normal = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-Pointer.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_custom_mouse_cursor(hand_press)
	else:
		Input.set_custom_mouse_cursor(hand_normal)
