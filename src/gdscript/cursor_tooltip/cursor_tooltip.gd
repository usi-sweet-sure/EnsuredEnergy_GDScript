extends Control

@onready var label = $MarginContainer/MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Cursor.show_tooltip.connect(_on_show_tooltip)
	Cursor.hide_tooltip.connect(_on_hide_tooltip)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position() + Vector2(30, -10)


func _on_show_tooltip(text: String):
	label.text = text
	show()


func _on_hide_tooltip():
	hide()
