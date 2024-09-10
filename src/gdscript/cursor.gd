extends Node

var hand_press = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-Pointer-press.png")
var hand_normal = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-Pointer.png")
var ibeam = preload("res://assets/UI Elements/All-HQ-Assets-D_0004s_0021_Icon-ibeam.png")
var block_cursor_change = false

func _ready():
	var inputs: Array = get_tree().get_nodes_in_group("input")
	for input in inputs:
		input.mouse_entered.connect(_on_input_mouse_entered)
		input.mouse_exited.connect(_on_input_mouse_exited)


func _process(delta):
	if not block_cursor_change:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			Input.set_custom_mouse_cursor(hand_press, Input.CURSOR_ARROW, Vector2(0,0))
		else:
			Input.set_custom_mouse_cursor(hand_normal, Input.CURSOR_ARROW, Vector2(0,0))


func _on_input_mouse_entered():
	block_cursor_change = true
	Input.set_custom_mouse_cursor(ibeam, Input.CURSOR_IBEAM, Vector2(8, 16))
	
	
func _on_input_mouse_exited():
	block_cursor_change = false
