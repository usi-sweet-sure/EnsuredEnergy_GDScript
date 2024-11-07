extends Node

signal show_tooltip(text: String)
signal hide_tooltip

var hand_press = preload("res://assets/textures/cursor/cursor_press.png")
var hand_normal = preload("res://assets/textures/cursor/cursor.png")
var hand_help = preload("res://assets/textures/cursor/cursor_info.png")
var hand_help_press = preload("res://assets/textures/cursor/cursor_info_press.png")
var hand_drag = preload("res://assets/textures/cursor/cursor_drag.png")
var hand_drag_press = preload("res://assets/textures/cursor/cursor_drag_press.png")
var ibeam = preload("res://assets/textures/cursor/cursor_ibeam.png")


func _ready():
	Input.set_custom_mouse_cursor(hand_normal, Input.CURSOR_ARROW, Vector2(0,0))
	Input.set_custom_mouse_cursor(hand_help, Input.CURSOR_HELP, Vector2(0, 26))
	Input.set_custom_mouse_cursor(hand_drag, Input.CURSOR_DRAG, Vector2(0,11))
	Input.set_custom_mouse_cursor(ibeam, Input.CURSOR_IBEAM, Vector2(8, 16))


func _input(event):
	if event.is_action_pressed("left_click"):
		Input.set_custom_mouse_cursor(hand_press, Input.CURSOR_ARROW, Vector2(0,0))
		Input.set_custom_mouse_cursor(hand_help_press, Input.CURSOR_HELP, Vector2(0, 26))
		Input.set_custom_mouse_cursor(hand_drag_press, Input.CURSOR_DRAG, Vector2(0,11))
	
	if event.is_action_released("left_click"):
		Input.set_custom_mouse_cursor(hand_normal, Input.CURSOR_ARROW, Vector2(0,0))
		Input.set_custom_mouse_cursor(hand_help, Input.CURSOR_HELP, Vector2(0, 26))
		Input.set_custom_mouse_cursor(hand_drag, Input.CURSOR_DRAG, Vector2(0,11))
