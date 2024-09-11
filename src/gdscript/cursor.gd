extends Node

var hand_press = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-Pointer-press.png")
var hand_normal = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-Pointer.png")
var hand_help = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-help.png")
var hand_help_press = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-help-press.png")
var ibeam = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-ibeam.png")
var mode = "normal"


func _ready():
	var inputs: Array = get_tree().get_nodes_in_group("inputs")
	for input in inputs:
		input.mouse_entered.connect(_on_input_mouse_entered)
		input.mouse_exited.connect(_on_input_mouse_exited)
	
	var help_buttons: Array = get_tree().get_nodes_in_group("help_buttons")
	for button in help_buttons:
		button.mouse_entered.connect(_on_help_button_mouse_entered)
		button.mouse_exited.connect(_on_help_button_mouse_exited)


func _process(delta):
	match mode:
		"normal":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Input.set_custom_mouse_cursor(hand_press, Input.CURSOR_ARROW, Vector2(0,0))
			else:
				Input.set_custom_mouse_cursor(hand_normal, Input.CURSOR_ARROW, Vector2(0,0))
		"help":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Input.set_custom_mouse_cursor(hand_help_press, Input.CURSOR_HELP, Vector2(2, 26))
			else:
				Input.set_custom_mouse_cursor(hand_help, Input.CURSOR_HELP, Vector2(2, 26))
		"ibeam":
			Input.set_custom_mouse_cursor(ibeam, Input.CURSOR_IBEAM, Vector2(8, 16))


func _on_input_mouse_entered():
	mode = "ibeam"
	
	
func _on_input_mouse_exited():
	mode = "normal"


func _on_help_button_mouse_entered():
	mode = "help"
	
	
func _on_help_button_mouse_exited():
	mode = "normal"
