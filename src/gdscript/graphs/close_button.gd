extends BaseButton


func _on_pressed():
	Gameloop.toggle_graphs.emit()
