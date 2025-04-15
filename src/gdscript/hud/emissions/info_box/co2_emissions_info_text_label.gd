extends HBoxContainer


func _ready() -> void:
	hide()


func _on_help_button_pressed() -> void:
	visible = not visible
