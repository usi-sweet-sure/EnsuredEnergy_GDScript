extends Control

@export_multiline var cursor_tooltip: String = ""

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	

func _on_mouse_entered() -> void:
	Cursor.show_tooltip.emit(cursor_tooltip)
	

func _on_mouse_exited() -> void:
	Cursor.hide_tooltip.emit()
