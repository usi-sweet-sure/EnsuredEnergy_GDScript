extends CanvasLayer


func _on_score_toggled(toggled_on):
	$EndWindow.visible = !toggled_on
