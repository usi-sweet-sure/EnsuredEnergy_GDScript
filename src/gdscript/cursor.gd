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
var mode = "normal"
# When we are dragging something, the cursor stays in grab mode. We want it to switch
# to the cursor it should have been when the mouse left click is released
var mode_to_switch_to_on_mouse_release = ""


func _ready():
	var inputs: Array = get_tree().get_nodes_in_group("inputs")
	for input in inputs:
		input.mouse_entered.connect(_on_input_mouse_entered)
		input.mouse_exited.connect(_on_input_mouse_exited)
	
	var help_buttons: Array = get_tree().get_nodes_in_group("help_buttons")
	for button in help_buttons:
		button.mouse_entered.connect(_on_help_button_mouse_entered)
		button.mouse_exited.connect(_on_help_button_mouse_exited)
		
	var draggables: Array = get_tree().get_nodes_in_group("draggables")
	for draggable in draggables:
		draggable.mouse_entered.connect(_on_draggable_mouse_entered)
		draggable.mouse_exited.connect(_on_draggable_mouse_exited)


func _process(delta):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mode_to_switch_to_on_mouse_release != "":
		mode = mode_to_switch_to_on_mouse_release
		mode_to_switch_to_on_mouse_release = ""
	
	# The cursor mode is not changed, doing so make the cursor jitter on high refresh rate screens
	match mode:
		"normal":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Input.set_custom_mouse_cursor(hand_press, Input.CURSOR_ARROW, Vector2(0,0))
			else:
				Input.set_custom_mouse_cursor(hand_normal, Input.CURSOR_ARROW, Vector2(0,0))
		"help":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Input.set_custom_mouse_cursor(hand_help_press, Input.CURSOR_ARROW, Vector2(0, 26))
			else:
				Input.set_custom_mouse_cursor(hand_help, Input.CURSOR_ARROW, Vector2(0, 26))
		"drag":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Input.set_custom_mouse_cursor(hand_drag_press, Input.CURSOR_ARROW, Vector2(0, 0))
			else:
				Input.set_custom_mouse_cursor(hand_drag, Input.CURSOR_ARROW, Vector2(0,11))
		"ibeam":
			Input.set_custom_mouse_cursor(ibeam, Input.CURSOR_ARROW, Vector2(8, 16))
			


func _on_input_mouse_entered():
	if not (mode == "drag" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		mode = "ibeam"
		mode_to_switch_to_on_mouse_release = ""
	else:
		mode_to_switch_to_on_mouse_release = "ibeam"
	
	
func _on_input_mouse_exited():
	if not (mode == "drag" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		mode = "normal"
		mode_to_switch_to_on_mouse_release = ""
	else:
		mode_to_switch_to_on_mouse_release = "normal"

func _on_help_button_mouse_entered():
	if not (mode == "drag" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		mode = "help"
		mode_to_switch_to_on_mouse_release = ""
	else:
		mode_to_switch_to_on_mouse_release = "help"
	
func _on_help_button_mouse_exited():
	if not (mode == "drag" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		mode = "normal"
		mode_to_switch_to_on_mouse_release = ""
	else:
		mode_to_switch_to_on_mouse_release = "normal"

func _on_draggable_mouse_entered():
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mode = "drag"
		mode_to_switch_to_on_mouse_release = ""
	else:
		mode_to_switch_to_on_mouse_release = "drag"
	
	
func _on_draggable_mouse_exited():
	if not (mode == "drag" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		mode = "normal"
		mode_to_switch_to_on_mouse_release = ""
	else:
		mode_to_switch_to_on_mouse_release = "normal"
