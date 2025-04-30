extends ColorRect

func _on_mouse_entered() -> void:
	Cursor.show_tooltip.emit(tr("PERSONAL_SUPPORT_LINE_NAME"))


func _on_mouse_exited() -> void:
	Cursor.hide_tooltip.emit()
